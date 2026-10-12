#!/bin/bash
# ALSA setup for ReSpeaker 2-Mic HAT v1 (WM8960, stock wm8960-soundcard overlay)
a() { amixer -c wm8960soundcard -q "$@"; }
# capture path (mics on LINPUT1/RINPUT1)
a sset 'Capture' 65% cap
a sset 'Left Boost Mixer LINPUT1' on
a sset 'Right Boost Mixer RINPUT1' on
a sset 'Left Input Mixer Boost' on
a sset 'Right Input Mixer Boost' on
a sset 'Left Input Boost Mixer LINPUT1' 2
a sset 'Right Input Boost Mixer RINPUT1' 2
a sset 'ADC PCM' 195
# ALC (stereo, WM8960 defaults: target 4, max gain 7) - chosen by mic benchmark 2026-10-11
a cset name='ALC Target' 4
a cset name='ALC Max Gain' 7
a cset name='ALC Function' 3
# playback path (DAC -> output mixer -> speaker/headphone)
a sset 'Left Output Mixer PCM' on
a sset 'Right Output Mixer PCM' on
a sset 'Playback' 230
a sset 'Speaker' 114
a sset 'Speaker AC' 0
a sset 'Speaker DC' 0
a sset 'Headphone' 100
a sset 'Speaker Playback ZC' on
a sset 'Headphone Playback ZC' on
sudo alsactl store
