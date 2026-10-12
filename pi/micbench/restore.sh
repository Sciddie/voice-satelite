#!/bin/bash
# Restore baseline ALSA state + restart services
a() { amixer -c wm8960soundcard -q "$@"; }
# ALC off and force real register writes (ASoC skips writes of unchanged cached values; ALC may have moved the PGA)
a cset name='ALC Function' 0
a cset name='Capture Volume' 0,0
a cset name='ADC High Pass Filter Switch' on
a cset name='Left Input Boost Mixer LINPUT1 Volume' 0
a cset name='Right Input Boost Mixer RINPUT1 Volume' 0
sudo alsactl restore -f ~/micbench/alsa-baseline.state wm8960soundcard
amixer -c wm8960soundcard contents > ~/micbench/amixer-after-restore.txt
if diff ~/micbench/amixer-baseline.txt ~/micbench/amixer-after-restore.txt > /dev/null; then echo ALSA_RESTORED_IDENTICAL; else echo ALSA_DIFF; diff ~/micbench/amixer-baseline.txt ~/micbench/amixer-after-restore.txt; fi
sudo systemctl start linux-voice-assistant lva-respeaker2mic
sleep 8
systemctl is-active linux-voice-assistant lva-respeaker2mic
ss -ltnp 2>/dev/null | grep -E ':6053|:6055' || echo NO_PORT
