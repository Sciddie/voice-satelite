import numpy as np, soundfile as sf
from scipy.signal import butter, sosfiltfilt
def bp(x,fs): return sosfiltfilt(butter(4,[100,7900],btype='band',fs=fs,output='sos'),x-np.mean(x))
def env(x,fs,w=0.02):
    y=bp(x,fs); n=int(w*fs); return 10*np.log10(np.array([np.mean(y[i:i+n]**2) for i in range(0,len(y)-n+1,n)])+1e-20)
def segment(x,fs,n_expected=10,thr_db=12):
    e=env(x,fs); w=0.02; nf=np.percentile(e,20)
    act=e>nf+thr_db
    ed=np.flatnonzero(np.diff(np.r_[0,act.astype(int),0])); segs=[[a*w,b*w] for a,b in zip(ed[::2],ed[1::2])]
    segs=[s for s in segs if s[1]-s[0]>=0.08]
    m=[]
    for s in segs:
        if m and s[0]-m[-1][1]<0.6: m[-1][1]=s[1]
        else: m.append(s)
    m=[s for s in m if s[1]-s[0]>=0.35]
    while len(m)>n_expected:
        g=[m[i+1][0]-m[i][1] for i in range(len(m)-1)]; i=int(np.argmin(g)); m[i][1]=m[i+1][1]; del m[i+1]
    return m,nf
