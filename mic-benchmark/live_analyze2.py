import os; os.environ.setdefault("OMP_NUM_THREADS","1")
import sys, json, csv, itertools, numpy as np, soundfile as sf
sys.path.insert(0,'/workspace/mic-benchmark')
from scipy.signal import resample_poly, welch
from live_seg import segment, env, bp
B='/workspace/mic-benchmark'
def init():
    import mb; mb.model('medium')
def job(a):
    import mb; k,clip=a; return k, mb.transcribe16(clip)
def main():
    from mb import wer_cer, normalize, META
    from swproc import sw_hp80norm
    REFS=[s['text'] for s in META['segments']]
    runs=['live_base','live_base_b','live_cap54','live_alc']
    data={}; jobs=[]
    for run in runs:
        xi,fs=sf.read(f'{B}/live/{run}_speech.wav',dtype='int16')
        if run=='live_base':
            ni,_=sf.read(f'{B}/live/{run}_noise.wav',dtype='int16'); xi=np.concatenate([xi,np.zeros((fs,2),np.int16),ni])
        x=xi/32768.0; clip=[int(np.sum(np.abs(xi[:,c].astype(int))>=32767)) for c in (0,1)]
        r,rfs=sf.read(f'{B}/live/{run}_ref.wav'); r=r if r.ndim==1 else r[:,0]; r16=resample_poly(r,1,3)
        segs,_=segment(x.mean(1),fs)
        # EVO4 offset via envelope xcorr (20 ms frames)
        ea=env(x.mean(1),fs); eb=env(r16,16000); ea=ea-np.median(ea); eb=eb-np.median(eb)
        ea=np.clip(ea,0,None); eb=np.clip(eb,0,None)
        c=np.correlate(np.pad(eb,(0,max(0,len(ea)-len(eb)))),ea,'full'); lag=(np.argmax(c)-(len(ea)-1))*0.02  # evo time = pi time + lag
        V={'avg':(x.mean(1),sum(clip),0.0),'L':(x[:,0],clip[0],0.0),'R':(x[:,1],clip[1],0.0),'evo4':(r16,int(np.sum(np.abs(r)>=0.999)),lag),
           'avg+hp80norm':(sw_hp80norm(x.mean(1),fs,None),sum(clip),0.0)}
        data[run]=(segs,V,fs,lag)
        for v,(s,cl,off) in V.items():
            for i,(a,b) in enumerate(segs):
                a0=max(int((a+off-0.3)*16000),0); b0=min(int((b+off+0.4)*16000),len(s))
                jobs.append((f'{run}|{v}|{i}',s[a0:b0].astype(np.float32)))
    cache_p=f'{B}/live_transcripts_seg.json'
    cache=json.load(open(cache_p)) if os.path.exists(cache_p) else {}
    todo=[j for j in jobs if j[0] not in cache]; print('jobs',len(todo),flush=True)
    if todo:
        import multiprocessing as mp
        with mp.get_context('spawn').Pool(4,initializer=init) as P:
            for k,t in P.imap_unordered(job,todo): cache[k]=t
        json.dump(cache,open(cache_p,'w'),ensure_ascii=False,indent=0)
    out=[]; per=[]
    for run,(segs,V,fs,lag) in data.items():
        n=len(segs)
        # map segments to sentences (monotonic; if fewer segments, skip the ref that gives min CER using avg hyps)
        hyp_avg=[cache[f'{run}|avg|{i}'] for i in range(n)]
        best=None
        for skip in itertools.combinations(range(10),10-n):
            idx=[j for j in range(10) if j not in skip]
            c=sum(wer_cer([REFS[j]],[h])[1] for j,h in zip(idx,hyp_avg))
            if best is None or c<best[0]: best=(c,idx)
        idx=best[1]
        for v,(s,cl,off) in V.items():
            hyps=[cache[f'{run}|{v}|{i}'] for i in range(n)]; refs=[REFS[j] for j in idx]
            w,ce,e,nw=wer_cer(refs,hyps); exact=sum(normalize(a)==normalize(b) for a,b in zip(refs,hyps))
            # signal metrics
            e20=env(s,16000 if v=='evo4' else fs); fr=0.02
            act=np.zeros(len(e20),bool)
            for a,b in segs: act[int((a+off)/fr):int((b+off)/fr)]=True
            pre=e20[:max(int((segs[0][0]+off-0.5)/fr),25)]
            nf=10*np.log10(np.mean(10**(np.sort(pre)[:max(len(pre)//2,1)]/10)))  # quieter half of lead-in
            sp=10*np.log10(np.mean(10**(e20[act]/10)))
            sig=s
            f,p=welch(resample_poly(sig,16000,fs) if (v!='evo4' and fs!=16000) else sig,16000,nperseg=1024)
            hf=100*p[(f>=4000)&(f<8000)].sum()/p[(f>=50)&(f<8000)].sum()
            pk=20*np.log10(np.abs(sig-np.mean(sig)).max()) if v!='evo4' else 20*np.log10(np.abs(sig).max())
            out.append(dict(run=run,variant=v,sentences=n,wer=w,cer=ce,word_errors=e,ref_words=nw,sent_exact=f'{exact}/{n}',speech_rms_dbfs=sp,peak_dbfs=pk,clip_samples=cl,
                            noise_floor_dbfs=nf,snr_db=10*np.log10(max(10**((sp-nf)/10)-1,1e-9)),hf_ratio_pct=hf,evo4_lag_s=lag if v=='evo4' else 0.0))
            for j,h in zip(idx,hyps): per.append(dict(run=run,variant=v,sentence=META['segments'][j]['id'],ref=REFS[j],hyp=h,wer=wer_cer([REFS[j]],[h])[0]))
    for fn,rows in [('live_metrics.csv',out),('live_per_sentence.csv',per)]:
        with open(f'{B}/{fn}','w',newline='') as f:
            w=csv.DictWriter(f,fieldnames=list(rows[0].keys())); w.writeheader()
            for o in rows: w.writerow({k:(round(v,4) if isinstance(v,float) else v) for k,v in o.items()})
    for o in out: print(f"{o['run']:12s} {o['variant']:13s} n={o['sentences']} WER {100*o['wer']:5.1f} CER {100*o['cer']:4.1f} ex {o['sent_exact']:5s} rms {o['speech_rms_dbfs']:6.1f} pk {o['peak_dbfs']:6.1f} clip {o['clip_samples']} nf {o['noise_floor_dbfs']:6.1f} snr {o['snr_db']:5.1f} hf {o['hf_ratio_pct']:4.2f} lag {o['evo4_lag_s']:.2f}")
if __name__=='__main__': main()
