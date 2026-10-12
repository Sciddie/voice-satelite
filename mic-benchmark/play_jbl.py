import sys, time, numpy as np, soundfile as sf, sounddevice as sd
gain=float(sys.argv[2]) if len(sys.argv)>2 else 1.0
x,fs=sf.read(sys.argv[1],dtype='float32')
dev=[i for i,d in enumerate(sd.query_devices()) if 'JBL Flip 5' in d['name'] and sd.query_hostapis(d['hostapi'])['name']=='Windows WASAPI' and d['max_output_channels']>0]
assert len(dev)==1, dev
y=np.column_stack([x,x])*gain
print('device',dev[0],sd.query_devices(dev[0])['name'],'fs',fs,'gain',gain,flush=True)
sd.play(y,fs,device=dev[0],blocking=True)
print('done',time.time())
