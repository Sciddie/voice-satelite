import os; os.environ.setdefault("OMP_NUM_THREADS","1")
import sys, json, csv, numpy as np, soundfile as sf
sys.path.insert(0,'/workspace/mic-benchmark')
from mb import wer_cer, normalize, META
from scipy.signal import butter, sosfiltfilt, resample_poly
from swproc import sw_hp80norm
REF=' '.join(s['text'] for s in META['segments'])
def bp(x,fs): return sosfiltfilt(butter(4,[100,7900],btype='band',fs=fs,output='sos'),x-np.mean(x))
def frames(y,fs,w=0.1):
    n=int(w*fs); return 10*np.log10(np.array([np.mean(y[i:i+n]**2) for i in range(0,len(y)-n+1,n)])+1e-20)
def sig(x,fs,clip):
    y=bp(x,fs); e=frames(y,fs)
    # noise floor: 10th percentile of first 3 s (before speech onset) and overall p10
    nf=np.percentile(e[:30],50); act=e>nf+10
    sp=10*np.log10(np.mean(10**(e[act]/10)))
    on=np.argmax(act)*0.1
    return dict(speech_rms_dbfs=sp,peak_dbfs=20*np.log10(np.abs(x-np.mean(x)).max()),clip_samples=clip,noise_floor_dbfs=nf,
                snr_db=10*np.log10(max(10**((sp-nf)/10)-1,1e-9)),speech_onset_s=on,active_s=act.sum()*0.1)
def hf(x,fs):
    from scipy.signal import welch
    x16=resample_poly(x,16000,fs) if fs!=16000 else x
    f,p=welch(x16,16000,nperseg=1024); return 100*p[(f>=4000)&(f<8000)].sum()/p[(f>=50)&(f<8000)].sum()
_m=None
def stt(x16):
    global _m
    if _m is None:
        from faster_whisper import WhisperModel
        _m=WhisperModel(os.environ.get('WM','medium'),device='cpu',compute_type='int8',cpu_threads=8)
    segs,_=_m.transcribe(x16.astype(np.float32),language='de',beam_size=5,condition_on_previous_text=False,temperature=0.0,vad_filter=True)
    return [s.text.strip() for s in segs]
runs=['live_base','live_base_b','live_cap54','live_alc']
out=[]; tr={}
for run in runs:
    xi,fs=sf.read(f'live/{run}_speech.wav',dtype='int16')
    if run=='live_base':  # take overflowed into the noise window -> append it (1 s gap lost)
        ni,_=sf.read(f'live/{run}_noise.wav',dtype='int16'); xi=np.concatenate([xi,np.zeros((fs,2),np.int16),ni])
    x=xi/32768.0; clip=[int(np.sum(np.abs(xi[:,c].astype(int))>=32767)) for c in (0,1)]
    r,rfs=sf.read(f'live/{run}_ref.wav'); r=r if r.ndim==1 else r[:,0]
    variants={'avg':(x.mean(1),fs,sum(clip)),'L':(x[:,0],fs,clip[0]),'R':(x[:,1],fs,clip[1]),'evo4':(r,rfs,int(np.sum(np.abs(r)>=0.999)))}
    variants['avg+hp80norm']=(sw_hp80norm(x.mean(1),fs,None),fs,sum(clip))
    for v,(s,sfs,c) in variants.items():
        m=sig(s,sfs,c); s16=resample_poly(s,16000,sfs) if sfs!=16000 else s
        segs=stt(s16); hyp=' '.join(segs)
        w,ce,e,nw=wer_cer([REF],[hyp])
        m.update(run=run,variant=v,wer=w,cer=ce,word_errors=e,ref_words=nw,hf_ratio_pct=hf(s,sfs),hyp=hyp)
        out.append(m); tr[f'{run}|{v}']=segs
        print(f"{run:12s} {v:13s} WER {100*w:5.1f} CER {100*ce:4.1f} rms {m['speech_rms_dbfs']:6.1f} pk {m['peak_dbfs']:6.1f} clip {c} nf {m['noise_floor_dbfs']:6.1f} snr {m['snr_db']:5.1f} hf {m['hf_ratio_pct']:4.2f} onset {m['speech_onset_s']:.1f}",flush=True)
json.dump(tr,open('live_transcripts.json','w'),ensure_ascii=False,indent=1)
with open('live_metrics.csv','w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=list(out[0].keys())); w.writeheader()
    for o in out: w.writerow({k:(round(v,4) if isinstance(v,float) else v) for k,v in o.items()})
