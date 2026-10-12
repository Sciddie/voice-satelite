#!/bin/bash
# Apply recommended config: baseline analog path + WM8960 ALC (stereo) with default parameters; persist via alsactl store
set -e
a() { amixer -c wm8960soundcard -q "$@"; }
cp ~/alsa-setup.sh ~/micbench/alsa-setup.sh.bak-$(date +%Y%m%d-%H%M)
sudo cp /var/lib/alsa/asound.state ~/micbench/asound.state.bak-$(date +%Y%m%d-%H%M)
sudo chown florian: ~/micbench/asound.state.bak-*
# start from the saved baseline, then force real register writes
a cset name='ALC Function' 0
a cset name='Capture Volume' 0,0
sudo alsactl restore -f ~/micbench/alsa-baseline.state wm8960soundcard 2>/dev/null || true
a cset name='Capture Volume' 41,41
a cset name='ADC High Pass Filter Switch' off
a cset name='ALC Target' 4
a cset name='ALC Max Gain' 7
a cset name='ALC Min Gain' 0
a cset name='ALC Hold Time' 0
a cset name='ALC Decay' 3
a cset name='ALC Attack' 2
a cset name='ALC Mode' 0
a cset name='Noise Gate Switch' off
a cset name='ALC Function' 3
sudo alsactl store
# keep the user's setup script consistent
if ! grep -q "ALC Function" ~/alsa-setup.sh; then
  sed -i "s/^a sset 'ADC PCM' 195$/a sset 'ADC PCM' 195\n# ALC (stereo, WM8960 defaults: target 4, max gain 7) - chosen by mic benchmark 2026-10-11\na cset name='ALC Target' 4\na cset name='ALC Max Gain' 7\na cset name='ALC Function' 3/" ~/alsa-setup.sh
fi
amixer -c wm8960soundcard contents > ~/micbench/amixer-applied.txt
diff ~/micbench/amixer-baseline.txt ~/micbench/amixer-applied.txt || true
grep -n ALC ~/alsa-setup.sh
sudo systemctl start linux-voice-assistant lva-respeaker2mic
sleep 25
systemctl is-active linux-voice-assistant lva-respeaker2mic
ss -ltn | grep -E ':6053|:6055' || echo NO_PORT
journalctl -u linux-voice-assistant -n 4 --no-pager | cut -c1-200
fuser -v /dev/snd/* 2>&1
