import os; os.environ.setdefault("OMP_NUM_THREADS","1")
# usage: analyze.py  -> processes every variant listed in variants() and writes metrics.csv / transcripts.json
import sys, os, json, csv, glob
sys.path.insert(0,'/workspace/mic-benchmark')
from mb import *
from multiprocessing import Pool
B='/workspace/mic-benchmark'
SEGS=META['segments']; REFS=[s['text'] for s in SEGS]
def load(path):
    x,fs=sf.read(path,always_2d=True); return x,fs
def to16(x,fs):
    if fs==16000: return x
    from math import gcd
    g=gcd(16000,fs); return resample_poly(x,16000//g,fs//g)
def band_energy(x,fs,lo,hi):
    from scipy.signal import welch
    f,p=welch(x,fs,nperseg=1024); m=(f>=lo)&(f<hi); return p[m].sum()
def seg_metrics(x,fs,noise,clipmask=None):
    """x: mono float signal (full recording), returns per-seg metrics + 16k clips for STT"""
    m,info=align(x,fs)
    nf_p=np.mean((noise-noise.mean())**2) if noise is not None else np.nan
    # noise floor in speech band too (100-8000)
    nb=bp(noise-noise.mean(),fs,100,7900) if noise is not None else None
    nfb_p=np.mean(nb**2) if nb is not None else np.nan
    rows=[]; clips=[]
    xd=x-np.mean(x)
    xb=bp(xd,fs,100,7900)
    for s in SEGS:
        a,b=int(m(s['start'])*fs),int(m(s['end'])*fs)
        seg=xd[a:b]; segb=xb[a:b]
        p=np.mean(seg**2); pb=np.mean(segb**2)
        r=dict(seg=s['id'],rms_dbfs=10*np.log10(p),peak_dbfs=20*np.log10(np.abs(seg).max()+1e-12),
               snr_db=10*np.log10(max(pb-nfb_p,1e-20)/nfb_p) if nfb_p==nfb_p else np.nan,
               hf_ratio=band_energy(to16(seg,fs),16000,4000,8000)/band_energy(to16(seg,fs),16000,50,8000))
        rows.append(r)
        pa,pb_=int(m(s['start']-0.4)*fs),int(m(s['end']+0.5)*fs)
        clips.append(to16(x[max(pa,0):pb_],fs).astype(np.float32))
    return rows,clips,info,10*np.log10(nf_p),10*np.log10(nfb_p)
def stt_job(args):
    key,i,clip=args
    return key,i,transcribe16(clip)

def runs_available():
    return sorted(os.path.basename(p)[:-len('_speech.wav')] for p in glob.glob(f'{B}/raw/*_speech.wav'))
def build_variants(extra=None):
    V=[]  # (name, run, kind, mono signal, fs, noise, clipcount, extra fields)
    for run in runs_available():
        xi,fs=sf.read(f'{B}/raw/{run}_speech.wav',dtype='int16',always_2d=True)
        ni,_=sf.read(f'{B}/raw/{run}_noise.wav',dtype='int16',always_2d=True)
        x=xi/32768.0; n=ni/32768.0
        clipL=int(np.sum(np.abs(xi[:,0].astype(int))>=32767)); clipR=int(np.sum(np.abs(xi[:,1].astype(int))>=32767))
        V.append((f'{run}|L',run,'L',x[:,0],fs,n[:,0],clipL))
        V.append((f'{run}|R',run,'R',x[:,1],fs,n[:,1],clipR))
        V.append((f'{run}|avg',run,'avg',x.mean(1),fs,n.mean(1),clipL+clipR))
        rp=f'{B}/ref/{run}_ref.wav'
        if os.path.exists(rp):
            r,rfs=sf.read(rp); r=r if r.ndim==1 else r[:,0]
            m,info=align(r,rfs); pre=r[:max(int((info['beep1']-0.15)*rfs),int(0.3*rfs))]
            V.append((f'{run}|evo4',run,'evo4',r,rfs,pre,int(np.sum(np.abs(r)>=0.999))))
    sw_runs=[r for r in os.environ.get('SW_RUNS','').split(',') if r]
    if sw_runs:
        from swproc import SW
        for name,run,ch,x,fs,noise,cl in list(V):
            if run in sw_runs and ch in ('avg',):
                h=len(noise)//2; prof=noise[:h]; test=noise[h:]
                for k,f in SW.items():
                    V.append((f'{name}+{k}',run,f'{ch}+{k}',f(x,fs,prof),fs,f(test,fs,prof) if k!='hp80norm' else f(np.concatenate([test,x]),fs,prof)[:len(test)],cl))
    return V
_M=None
def init(): 
    import mb; mb.model(os.environ.get('WM','medium'))
def main(only=None):
    V=build_variants()
    cache_p=f'{B}/transcripts.json' if os.environ.get('WM','medium')=='medium' else f"{B}/transcripts_{os.environ['WM']}.json"
    cache=json.load(open(cache_p)) if os.path.exists(cache_p) else {}
    out=[]; jobs=[]; per={}
    for name,run,ch,x,fs,noise,clips_n in V:
        if only and not any(o in name for o in only): continue
        rows,clips,info,nf,nfb=seg_metrics(x,fs,noise)
        per[name]=(run,ch,fs,rows,info,nf,nfb,clips_n)
        for i,c in enumerate(clips):
            k=f'{name}#{SEGS[i]["id"]}'
            if k not in cache: jobs.append((k,i,c))
    print('stt jobs',len(jobs),flush=True)
    if jobs:
        import multiprocessing as mp
        with mp.get_context('spawn').Pool(4,initializer=init) as P:
            for n_,(k,i,t) in enumerate(P.imap_unordered(stt_job,jobs,chunksize=2)):
                cache[k]=t
                if n_%20==0: json.dump(cache,open(cache_p,'w'),ensure_ascii=False,indent=0); print(n_,flush=True)
        json.dump(cache,open(cache_p,'w'),ensure_ascii=False,indent=0)
    seg_rows=[]; sum_rows=[]
    for name,(run,ch,fs,rows,info,nf,nfb,clips_n) in per.items():
        hyps=[cache[f'{name}#{s["id"]}'] for s in SEGS]
        for r,h,ref in zip(rows,hyps,REFS):
            w,c,e,nw=wer_cer([ref],[h]); seg_rows.append(dict(variant=name,run=run,channel=ch,**r,wer=w,cer=c,hyp=h,ref=ref))
        w,c,e,nw=wer_cer(REFS,hyps)
        exact=sum(1 for r,h in zip(REFS,hyps) if normalize(r)==normalize(h))
        sum_rows.append(dict(variant=name,run=run,channel=ch,fs=fs,wer=w,cer=c,word_errors=e,ref_words=nw,sent_exact=exact,
            speech_rms_dbfs=10*np.log10(np.mean([10**(r['rms_dbfs']/10) for r in rows])),
            peak_dbfs=max(r['peak_dbfs'] for r in rows),clip_samples=clips_n,
            noise_floor_dbfs=nf,noise_floor_band_dbfs=nfb,
            snr_db=float(np.mean([r['snr_db'] for r in rows])),hf_ratio_pct=100*float(np.mean([r['hf_ratio'] for r in rows])),
            beep_dbfs=info['beep_lvl'],drift_ppm=info['drift_ppm']))
    return seg_rows,sum_rows
def write(seg_rows,sum_rows):
    for fn,rows in [('metrics_per_sentence.csv',seg_rows),('metrics.csv',sum_rows)]:
        with open(f'{B}/{fn}','w',newline='') as f:
            w=csv.DictWriter(f,fieldnames=list(rows[0].keys())); w.writeheader()
            for r in rows: w.writerow({k:(round(v,4) if isinstance(v,float) else v) for k,v in r.items()})
if __name__=='__main__':
    s,u=main(sys.argv[1:] or None); write(s,u)
    for r in sorted(u,key=lambda r:r['variant']): print(f"{r['variant']:22s} WER {100*r['wer']:5.1f} CER {100*r['cer']:5.1f} rms {r['speech_rms_dbfs']:6.1f} pk {r['peak_dbfs']:6.1f} clip {r['clip_samples']:4d} nf {r['noise_floor_band_dbfs']:6.1f} snr {r['snr_db']:5.1f} hf {r['hf_ratio_pct']:5.2f} beep {r['beep_dbfs']:6.1f} drift {r['drift_ppm']:7.0f}")
