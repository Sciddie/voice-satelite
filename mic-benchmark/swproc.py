import numpy as np, soundfile as sf, tempfile, os
from scipy.signal import butter, sosfiltfilt, resample_poly
def sw_none(x,fs,noise): return x
def sw_nr(x,fs,noise):
    import noisereduce as nr
    return nr.reduce_noise(y=x,sr=fs,y_noise=noise,stationary=True,prop_decrease=0.9)
def sw_rnnoise(x,fs,noise):
    from pyrnnoise import RNNoise
    up=resample_poly(x,48000,fs) if fs!=48000 else x
    rn=RNNoise(48000); pcm=(np.clip(up,-1,1)*32767).astype(np.int16)[None,:]
    out=[f for _,f in rn.denoise_chunk(pcm,partial=True)]
    y=np.concatenate([np.atleast_2d(f) for f in out],axis=1)[0].astype(np.float64)/32768.0
    y=resample_poly(y,fs,48000) if fs!=48000 else y
    y=y[int(0.02*fs):]  # compensate 20 ms RNNoise/resampler latency (measured)
    y=np.pad(y,(0,max(0,len(x)-len(y))))[:len(x)]
    return y
def sw_hp80norm(x,fs,noise):
    y=sosfiltfilt(butter(4,80,btype='high',fs=fs,output='sos'),x-np.mean(x))
    return y*(10**(-1/20)/np.max(np.abs(y)))
SW={'nr':sw_nr,'rnnoise':sw_rnnoise,'hp80norm':sw_hp80norm}
