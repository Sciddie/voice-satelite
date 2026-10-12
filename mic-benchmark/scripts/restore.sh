#!/bin/bash
sudo alsactl restore -f ~/micbench/alsa-baseline.state wm8960soundcard
amixer -c wm8960soundcard contents > ~/micbench/amixer-after-restore.txt
diff <(grep -A2 "name=" ~/micbench/amixer-baseline.txt) <(grep -A2 "name=" ~/micbench/amixer-after-restore.txt) && echo ALSA_RESTORED_IDENTICAL
systemctl --user start linux-voice-assistant lva-respeaker2mic
sleep 3
systemctl --user is-active linux-voice-assistant lva-respeaker2mic
