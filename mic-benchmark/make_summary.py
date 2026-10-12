import sys, json, csv, re, numpy as np
sys.path.insert(0,'/workspace/mic-benchmark')
from mb import wer_cer, normalize, META
import jiwer
B='/workspace/mic-benchmark'
REFS={s['id']:s['text'] for s in META['segments']}
CFG={'base16':'Baseline 16k (Cap41 / Boost+20dB)','cap28':'Capture 28 (45%)','cap35':'Capture 35 (55%)','cap47':'Capture 47 (75%)','cap54':'Capture 54 (85%)',
 'boost0':'Boost 0 dB','boost1':'Boost +13 dB','boost3':'Boost +29 dB','hpf_on':'ADC-HPF an','alc_on':'ALC an (Stereo, Default-Parameter)','base48':'Baseline 48k -> 16k',
 'cap47b3':'Capture 47 + Boost +29 dB','cap54_hpf':'Capture 54 + HPF an','pgastuck16':'PGA nach ALC haengengeblieben (~Cap 62) 16k','pgastuck48':'PGA nach ALC haengengeblieben (~Cap 62) 48k'}
def cfg_of(run):
    if run in CFG: return run
    r=re.sub(r'_(a|b|c|d)$','',run)
    return r if r in CFG else run
rows=list(csv.DictReader(open(f'{B}/metrics.csv')))
tm=json.load(open(f'{B}/transcripts.json')); ts=json.load(open(f'{B}/transcripts_small.json'))
def wer_for(trans,variants):
    R=[];H=[]
    for v in variants:
        for sid,ref in REFS.items():
            k=f'{v}#{sid}'
            if k in trans: R.append(ref); H.append(trans[k])
    if not R: return None,None,0
    w,c,e,n=wer_cer(R,H); ex=sum(normalize(a)==normalize(b) for a,b in zip(R,H)); return w,c,(ex,len(R))
groups={}
for r in rows:
    run=r['run']; ch=r['channel']; g=(cfg_of(run),ch)
    groups.setdefault(g,[]).append(r)
out=[]
for (cfg,ch),rs in sorted(groups.items()):
    vs=[r['variant'] for r in rs]
    wm,cm,exm=wer_for(tm,vs); wsm,csm,exs=wer_for(ts,vs)
    f=lambda k: float(np.mean([float(r[k]) for r in rs]))
    out.append(dict(config=cfg,label=CFG.get(cfg,cfg),channel=ch,repeats=len(rs),runs=' '.join(r['run'] for r in rs),
        wer_medium=wm,cer_medium=cm,sent_exact_medium=f'{exm[0]}/{exm[1]}',
        wer_small=wsm,cer_small=csm,sent_exact_small=(f'{exs[0]}/{exs[1]}' if wsm is not None else ''),
        wer_medium_per_repeat=' '.join(f"{100*float(r['wer']):.1f}" for r in rs),
        speech_rms_dbfs=f('speech_rms_dbfs'),peak_dbfs=max(float(r['peak_dbfs']) for r in rs),clip_samples=sum(int(r['clip_samples']) for r in rs),
        noise_floor_dbfs=f('noise_floor_band_dbfs'),snr_db=f('snr_db'),hf_ratio_pct=f('hf_ratio_pct')))
with open(f'{B}/summary_by_config.csv','w',newline='') as fh:
    w=csv.DictWriter(fh,fieldnames=list(out[0].keys())); w.writeheader()
    for o in out: w.writerow({k:(round(v,4) if isinstance(v,float) else v) for k,v in o.items()})
for o in out:
    ws='' if o['wer_small'] is None else f"{100*o['wer_small']:5.1f}"
    print(f"{o['config']:11s} {o['channel']:13s} n={o['repeats']} WERm {100*o['wer_medium']:5.1f} ({o['wer_medium_per_repeat']}) CERm {100*o['cer_medium']:4.1f} ex {o['sent_exact_medium']:6s} WERs {ws:>5s} rms {o['speech_rms_dbfs']:6.1f} pk {o['peak_dbfs']:6.1f} nf {o['noise_floor_dbfs']:6.1f} snr {o['snr_db']:5.1f} hf {o['hf_ratio_pct']:4.2f}")
