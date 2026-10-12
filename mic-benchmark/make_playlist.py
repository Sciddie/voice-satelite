import json, numpy as np, soundfile as sf
from scipy.signal import resample_poly
FS=44100
S=json.load(open('sentences.json'))
def beep(d=0.5):
    t=np.arange(int(d*FS))/FS; b=0.5*np.sin(2*np.pi*1000*t)
    r=int(0.01*FS); w=np.ones_like(b); w[:r]=np.linspace(0,1,r); w[-r:]=np.linspace(1,0,r); return b*w
out=[np.zeros(FS)]; meta={'fs':FS,'segments':[]}
pos=FS; meta['beep_start']=pos/FS; b=beep(); out.append(b); pos+=len(b)
g=np.zeros(int(1.5*FS))
out.append(g); pos+=len(g)
for sid,v,t in S:
    x,fs=sf.read(f'tts/{sid}.wav'); x=resample_poly(x,2,1)
    # trim leading/trailing silence
    nz=np.where(np.abs(x)>0.003)[0]; x=x[max(nz[0]-480,0):nz[-1]+480]
    x=x/np.sqrt(np.mean(x**2))*10**(-20/20)
    pk=np.max(np.abs(x))
    if pk>0.89: x*=0.89/pk
    meta['segments'].append({'id':sid,'text':t,'voice':v,'start':pos/FS,'end':(pos+len(x))/FS})
    out.append(x); pos+=len(x); out.append(g); pos+=len(g)
meta['end_beep_start']=pos/FS; out.append(b); pos+=len(b); out.append(np.zeros(FS)); pos+=FS
y=np.concatenate(out); meta['duration']=len(y)/FS
sf.write('playlist_44k_mono.wav',y.astype(np.float32),FS,subtype='PCM_16')
json.dump(meta,open('playlist_meta.json','w'),indent=1,ensure_ascii=False)
print(meta['duration'], [round(s['end']-s['start'],2) for s in meta['segments']], 20*np.log10(np.max(np.abs(y))))
