import json, numpy as np, soundfile as sf
from scipy.signal import butter, sosfiltfilt, resample_poly
META=json.load(open('/workspace/mic-benchmark/playlist_meta.json'))
def bp(x,fs,lo,hi,order=4):
    return sosfiltfilt(butter(order,[lo,hi],btype='band',fs=fs,output='sos'),x)
def find_beep(x,fs,t_lo,t_hi):
    a,b=int(t_lo*fs),int(min(t_hi*fs,len(x)))
    seg=x[a:b]; y=np.abs(bp(seg,fs,900,1100))
    w=int(0.02*fs); env=np.convolve(y,np.ones(w)/w,'same')
    # require beep to be dominant: compare with broadband envelope
    thr=0.5*env.max(); i=np.argmax(env>thr)
    return (a+i)/fs, 20*np.log10(env.max()+1e-12)
def align(x,fs):
    """returns function mapping playlist time -> recording time"""
    t1,l1=find_beep(x,fs,0,12)
    exp_end=META['end_beep_start']
    t2,l2=find_beep(x,fs,t1-META['beep_start']+exp_end-2,t1-META['beep_start']+exp_end+2)
    scale=(t2-t1)/(exp_end-META['beep_start'])
    return (lambda t: t1+(t-META['beep_start'])*scale), dict(beep1=t1,beep2=t2,drift_ppm=(scale-1)*1e6,beep_lvl=l1)

import re
from num2words import num2words
def num_de(n):
    return num2words(int(n),lang='de')
def normalize(t):
    t=t.lower()
    t=re.sub(r'(\d+)[:.](\d\d)\s*uhr', lambda m: f"{num_de(m[1])} uhr {num_de(m[2]) if int(m[2]) else ''}", t)
    t=re.sub(r'(\d+)\s*uhr\s*(\d\d)', lambda m: f"{num_de(m[1])} uhr {num_de(m[2])}", t)
    t=re.sub(r'(\d+),(\d+)', lambda m: f"{num_de(m[1])} komma {' '.join(num_de(c) for c in m[2])}", t)
    t=t.replace('°c',' grad ').replace('%',' prozent ').replace('°',' grad ')
    t=re.sub(r'\d+', lambda m: num_de(m[0]), t)
    t=re.sub(r'(\w)-(\w)', r'\1\2', t)   # hyphenated compounds -> joined
    t=re.sub(r"[^\wäöüß ]", ' ', t)
    return ' '.join(t.split())
import jiwer
def wer_cer(refs,hyps):
    R=[normalize(r) for r in refs]; H=[normalize(h) for h in hyps]
    o=jiwer.process_words(R,H); c=jiwer.process_characters(R,H)
    return o.wer, c.cer, (o.substitutions+o.deletions+o.insertions), sum(len(r.split()) for r in R)
_model=None
def model(name='medium'):
    global _model
    if _model is None:
        from faster_whisper import WhisperModel
        _model=WhisperModel(name,device='cpu',compute_type='int8',cpu_threads=1)
    return _model
def transcribe16(x16):
    segs,_=model().transcribe(x16.astype(np.float32),language='de',beam_size=5,condition_on_previous_text=False,vad_filter=False,temperature=0.0)
    return ' '.join(s.text.strip() for s in segs).strip()
