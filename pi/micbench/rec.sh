#!/bin/bash
# usage: rec.sh NAME RATE CAPTURE BOOST HPF(on/off) ALC(0-3) [SPEECH_SECS]
NAME=$1; RATE=$2; CAP=$3; BOOST=$4; HPF=$5; ALC=$6; SECS=${7:-60}
D=~/micbench/rec; mkdir -p $D
a() { amixer -c wm8960soundcard -q "$@"; }
# force a real register write (ASoC skips unchanged values; ALC may have left the PGA elsewhere)
a cset name='ALC Function' 0
a cset name='Capture Volume' 0,0
a cset name='Capture Volume' $CAP,$CAP
a cset name='Left Input Boost Mixer LINPUT1 Volume' $BOOST
a cset name='Right Input Boost Mixer RINPUT1 Volume' $BOOST
a cset name='ADC High Pass Filter Switch' $HPF
a cset name='ALC Function' $ALC
amixer -c wm8960soundcard contents > $D/$NAME.amixer.txt
echo start $(date +%s.%N) > $D/$NAME.log
arecord -D hw:wm8960soundcard -f S16_LE -c 2 -r $RATE -d $SECS $D/${NAME}_speech.wav >> $D/$NAME.log 2>&1
sleep 1
arecord -D hw:wm8960soundcard -f S16_LE -c 2 -r $RATE -d 10 $D/${NAME}_noise.wav >> $D/$NAME.log 2>&1
echo DONE $(date +%s.%N) >> $D/$NAME.log
