# Mikrofon-Benchmark Voice-Satellit (Pi Zero 2 W + ReSpeaker 2-Mic v1.0 / WM8960) – Endbericht 11.10.2026

## Ergebnis in Kürze
**Empfehlung, angewendet am 11.10.2026 um 14:10 und persistent:** analoger Pfad wie bisher (Capture 41, Boost +20 dB, ADC PCM 195, HPF aus) **plus WM8960-ALC Stereo** (`ALC Function`=3) mit den Default-Parametern (Target 4, Max Gain 7, Min Gain 0, Hold 0, Decay 3, Attack 2, Mode ALC, Noise Gate aus).
- TTS-Benchmark: Mono-Mittel L+R, je 3 Läufe: **6,2 % WER** gegenüber 10,4 % bei der Baseline. Die Sprachpegel steigen von -42 auf -26 dBFS, der SNR bleibt bei 20,7 dB.
- Live-Stimme, pro Äußerung: **2,5 % WER** (8/10 Sätze exakt), praktisch gleichauf mit dem EVO4-Studiomikro derselben Aufnahme (1,2 %). Baseline-Take B: 11,2 % (EVO4 ebenfalls 11,2 %), Capture 54: 7,5 % (EVO4 6,2 %). Kein Clipping, Peak -2,9 dBFS, SNR 25 dB.
- Nachteil: In Sprechpausen regelt die ALC hoch, der Rauschboden steigt von ca. -65 auf ca. -48 dBFS. Der SNR während Sprache bleibt gleich. Die Wake-Word-Erkennung sollte beobachtet werden (Fehlauslösungen).
- Rückweg zur Baseline: `amixer -c wm8960soundcard cset name='ALC Function' 0; amixer -c wm8960soundcard cset name='Capture Volume' 0,0; amixer -c wm8960soundcard cset name='Capture Volume' 41,41; sudo alsactl store`. Backups liegen in `~/micbench/` (`alsa-baseline.state`, `asound.state.bak-*`, `alsa-setup.sh.bak-*`).

## Aufbau
- 10 deutsche TTS-Sätze (edge-tts de-DE Conrad/Katja), RMS-normalisiert, Playlist mit 1-kHz-Sync-Beep (Start + Ende) und Pausen von 1,5 s, abgespielt nur auf „Speakers (JBL Flip 5)“ (WASAPI, Windows-Lautstärke 34,6 % / -15,7 dB, unverändert).
- Pi: `arecord -D hw:wm8960soundcard -f S16_LE -c 2`, dazu je 10 s Raumruhe für den Rauschboden. Parallel lief die EVO4-Referenz (Line 1, 48 kHz).
- Segmentierung über Beep-Erkennung (Drift < 0,1 %). Metriken je Satz: RMS, Peak, Clipping, Rauschboden (100–7900 Hz), SNR, HF-Anteil 4–8 kHz.
- STT: faster-whisper **medium int8** (CPU, de, beam 5, T=0, `cpu_threads=1` für deterministische Ergebnisse) und zusätzlich **small int8** (für einen Teil der Runs). WER/CER nach Normalisierung (Kleinschreibung, Zahlen als Wörter, Bindestriche zusammengezogen).
- Mehrfach gemessen: Baseline 3×, Capture 54 3×, ALC 3×, Cap47+Boost29 2×.

## Ergebnisse (Kanal = Mittel L+R, medium-WER über Wiederholungen gepoolt)
Siehe `summary_by_config.csv`, `metrics.csv`, `metrics_per_sentence.csv` und `chart_wer_snr.png`.

| Setting | n | WER medium | WER je Lauf | CER | Sprach-RMS dBFS | Peak dBFS | Rauschboden dBFS | SNR dB |
|---|---|---|---|---|---|---|---|---|
| Baseline 16k (Cap 41, Boost +20) | 3 | 10,4 % | 8,8/10,0/12,5 | 2,7 % | -42,4 | -26,3 | -63,7 | 20,5 |
| **Baseline + SW HP80 + Normalisierung** | 3 | **4,6 %** | 6,2/3,8/3,8 | 2,1 % | -17,2 | -1,0 | -38,4 | 20,7 |
| Baseline + noisereduce | 3 | 11,7 % | | 3,7 % | -45,8 | | -80,3 | 33,8 |
| Baseline + RNNoise | 3 | 77,5 % | | 61 % | | | -95,7 | 41,4 |
| ALC an (Stereo, Default-Parameter) | 3 | 6,2 % | 6,2/2,5/10,0 | 1,7 % | -26,2 | -10,2 | -47,6 | 20,7 |
| Capture 54 (85 %) | 3 | 9,2 % | 7,5/11,2/8,8 | 2,1 % | -32,7 | -11,9 | -54,3 | 20,8 |
| Capture 54 + HP80/Norm | 3 | 8,3 % | | 1,8 % | | | | 23,3 |
| Cap 47 + Boost +29 | 2 | 10,6 % | 11,2/10,0 | 2,3 % | -29,0 | -9,9 | -50,7 | 20,8 |
| Capture 28 / 35 / 47 | 1 | 10,0 / 7,5 / 8,8 % | | | -52,2 / -47,0 / -38,0 | | | 20,0–20,5 |
| Boost 0 / +13 / +29 dB | 1 | 12,5 / 12,5 / 11,2 % | | | -62,0 / -49,6 / -33,6 | | | 20,5–20,9 |
| ADC-HPF an | 1 | 16,2 % | | 5,3 % | -42,4 | | -63,9 | 20,7 |
| Cap 54 + HPF | 1 | 10,0 % | | | -32,8 | | | 20,7 |
| 48 kHz → 16 kHz | 1 | 12,5 % | | | -42,4 | | -64,2 | 21,0 |
| EVO4-Referenz (Obergrenze Raum + Lautsprecher) | 22 Läufe | 3,8–15 %, Baseline-Läufe 8,8 % | | | | | | ~23 |

Kanäle (Baseline, 3×): L 12,1 %, R 12,1 %, **avg 10,4 %**. Der Mittelwert hat ca. 2,5 dB mehr SNR als L. Das linke Mikro rauscht oberhalb von 2 kHz rund 4–5 dB stärker, und sein HF-Anteil von 5,8 % besteht großteils aus Rauschen. Das linke Mikro hatte außerdem zwei Whisper-Wiederholungsschleifen (boost1, cap47), die zu WER > 100 % führten.

## Beobachtungen
1. **Der SNR ist durch den Raum begrenzt, nicht durch die Elektronik.** Über 34 dB Gain-Variation (Boost 0 bis Cap 54/ALC) bleibt der SNR bei 20–21 dB, der Rauschboden wandert 1:1 mit. Mehr analoger Gain verbessert also nicht den SNR, sondern nur den digitalen Pegel.
2. **Der Pegel an Whisper zählt.** Die Baseline liegt bei nur -42 dBFS RMS. Wird das Signal in Software angehoben (HP80 + Normalisierung) oder per ALC, sinkt die WER von 10,4 % auf 4,6 % bzw. 6,2 %. Reine Hardware-Gain-Erhöhungen (Cap 54, Boost +29) brachten nur wenig. Die Streuung zwischen Wiederholungen liegt bei ±3–4 Prozentpunkten; 1 Wort entspricht 1,25 %.
3. Rauschunterdrückung hilft nicht. noisereduce ist neutral bis leicht schlechter. RNNoise dämpft die (über Lautsprecher wiedergegebene, verhallte) Sprache um 3–17 dB und zerstört die Erkennung.
4. ADC-HPF und 48 kHz bringen keinen Vorteil. Bei 0 Clipping-Samples in allen Läufen gab es keine Übersteuerung.
5. Buffer/xrun: Periode 64 bis 1024 Frames (4–64 ms) bei 16 kHz, je 20 s: **keine Overruns**. Das betrifft nur Latenz/Robustheit, nicht die Erkennung.
6. AEC wurde nicht getestet: Ohne gleichzeitige Wiedergabe über den Pi selbst ist das nicht sinnvoll messbar.
7. Treiber-Falle: Nach ALC=aus bleibt die PGA auf dem letzten ALC-Wert, weil ASoC unveränderte Werte nicht neu schreibt. Daher sind die Runs `pgastuck16/48` (effektiv ca. Cap 62) separat ausgewiesen. Ab dann wurde die PGA in jedem Run per 0→Wert neu geschrieben.

## Typische Fehler (auch in der EVO4-Referenz)
„Querflöte“→„Querflute“, „Rollläden“→„Ruhlein/Rundern/Ruhläden“, „Wärmepumpen…“→„Wärmepunkten…“, „Fischers“→„Fischer's“. Das sind überwiegend Whisper/TTS-Effekte und kaum mikrofonabhängig.

## Ursprüngliche Empfehlung nach dem TTS-Teil (überholt durch die Live-Tests)
Analog Baseline beibehalten oder moderat anheben, Mono = Mittel L+R, und in Software Pegel-Normalisierung bzw. AGC + Hochpass 80 Hz. Keine Rauschunterdrückung.
```
amixer -c wm8960soundcard cset name='ALC Function' 0
amixer -c wm8960soundcard cset name='Capture Volume' 0,0      # erzwingt echten Register-Write
amixer -c wm8960soundcard cset name='Capture Volume' 54,54    # (Baseline 41; 54 = +9,75 dB, Peak TTS -12 dBFS)
amixer -c wm8960soundcard cset name='Left Input Boost Mixer LINPUT1 Volume' 2
amixer -c wm8960soundcard cset name='Right Input Boost Mixer RINPUT1 Volume' 2
amixer -c wm8960soundcard cset name='ADC High Pass Filter Switch' off
amixer -c wm8960soundcard cset name='ADC PCM Capture Volume' 195,195
```
Alternative, rein in Hardware: `ALC Function` = 3 (Stereo) mit den Default-Parametern (Target 4, MaxGain 7). Das ergab 6,2 % WER, hebt aber in Sprechpausen den Rauschboden auf -47 dBFS an (Pumpen, mögliche Wirkung auf die Wake-Word-Erkennung). Vor der Übernahme mit der Live-Stimme verifizieren.

## Caveats
TTS über einen Bluetooth-Lautsprecher ist nicht dasselbe wie eine echte Stimme (Abstrahlung, Pegel, Dynamik). Whisper medium/small auf x86 ist nicht dasselbe wie das HA-Setup auf dem Pi 4 (dort Modell/Beam/Temperatur-Fallback anders). Die Stichprobe ist mit 80 Wörtern pro Lauf klein. Der absolute Schalldruck ist nicht kalibriert (kein SPL-Meter). Das EVO4-Gain ist unbekannt, daher dient es nur als relativer Konsistenz-Check: Playback-Pegel über alle gültigen Läufe -51,0 bis -51,8 dBFS RMS, ein Lauf -49,8.


## Live-Test mit echter Stimme (Florian, 4 Takes)
Ablauf: Pi 16 kHz stereo, EVO4 parallel. Ohne Sync-Beep, weil der JBL nicht mehr verbunden war. Die Äußerungen wurden per Energie-VAD auf dem Pi-Signal segmentiert, der EVO4-Versatz per Hüllkurven-Kreuzkorrelation bestimmt (ca. -1,8 s). Whisper medium int8 pro Äußerung (+0,3/+0,4 s Rand), deterministisch. Daten: `live_metrics.csv`, `live_per_sentence.csv`, `live_transcripts_seg.json`, WAVs unter `live/`.

| Take | Kanal | WER | CER | exakt | Sprach-RMS dBFS | Peak dBFS | Clip | Rauschboden dBFS | SNR dB |
|---|---|---|---|---|---|---|---|---|---|
| live_base (Cap 41) * | avg | 50,0 % | 46,4 % | 1/9 | -39,6 | -17,8 | 0 | -64,9 | 25,3 |
| live_base * | EVO4 | 35,7 % | | 3/9 | -46,5 | -23,8 | 0 | -75,1 | 28,7 |
| live_base_b (Cap 41) | avg | 11,2 % | 5,2 % | 4/10 | -39,6 | -16,8 | 0 | -64,9 | 25,3 |
| live_base_b | avg + HP80/Norm | 6,2 % | 2,0 % | 6/10 | -24,0 | -1,0 | 0 | | 25,3 |
| live_base_b | EVO4 | 11,2 % | 2,2 % | 6/10 | -45,2 | -21,4 | 0 | -73,1 | 27,9 |
| live_cap54 (Cap 54) | avg | 7,5 % | 2,6 % | 6/10 | -30,6 | -8,3 | 0 | -55,3 | 24,7 |
| live_cap54 | avg + HP80/Norm | 82,5 % ** | | 6/10 | | -1,0 | 0 | | 24,8 |
| live_cap54 | EVO4 | 6,2 % | 1,8 % | 6/10 | -45,9 | -22,2 | 0 | -74,8 | 28,9 |
| **live_alc (Cap 41 + ALC)** | **avg** | **2,5 %** | **0,6 %** | **8/10** | -23,7 | -2,9 | 0 | -48,7 *** | 25,0 |
| live_alc | avg + HP80/Norm | 1,2 % | 0,4 % | 9/10 | | -1,0 | 0 | | 25,0 |
| live_alc | EVO4 | 1,2 % | 0,4 % | 9/10 | -45,2 | -21,7 | 0 | -73,8 | 28,6 |

\* Take 1: Das Aufnahmefenster von 75 s war zu kurz. Satz 10 fehlt, Satz 9 lag im Rauschfenster. Die Segmentierung gelingt hier schlecht (abgeschnittene Clips, auch beim EVO4). Der Take ist nur für die Pegel aussagekräftig.
\*\* Ein einziger Whisper-Wiederholungsloop („frische Fische, …“ ×20) bei Satz 6. Die restlichen 9 Sätze sind korrekt.
\*\*\* Der ALC regelt in der Stille hoch, daher ist der Rauschboden im Vorlauf höher. Der SNR während Sprache ist unverändert.

Pegelvergleich: Die echte Stimme kam bei Cap 41 mit -39,6 dBFS RMS am Pi an (TTS: -42,4). Der TTS-Playbackpegel war also realistisch. Die Pi-WER liegt in jedem Take nahe an der EVO4-WER desselben Takes. Die Unterschiede zwischen Takes kommen also stark von Sprechweise und Whisper-Varianz, kaum vom Mikrofon. Das linke Mikro ist erneut auffällig: 2 Whisper-Loops, höherer HF-Rauschanteil.

## Gesamtbewertung
1. In keinem Setting gab es Clipping. Der SNR (20–25 dB) wird vom Raum bestimmt und ist vom Gain unabhängig.
2. Ein höherer digitaler Pegel (ca. -24 bis -30 dBFS RMS) bringt Whisper messbar weiter als -40 dBFS. Die robusteste Lösung ohne Software-Änderung in LVA ist die ALC: in beiden Tests bestes Pi-Setting, mit Begrenzung der Peaks.
3. Software-Normalisierung + HP80 wirkt ähnlich gut wie die ALC (TTS 4,6 %, live 6,2 % bzw. 1,2 %), ist aber in LVA nicht einfach konfigurierbar. Rauschunterdrückung (noisereduce, RNNoise) wird nicht empfohlen.
4. ADC-HPF, 48 kHz und das Boost-Setting zeigen keinen relevanten Effekt. Buffer-Größe: keine Overruns bis 64 Frames.
5. Mono als Mittel aus L+R (PipeWire-Downmix) ist besser oder gleich als ein einzelnes Mikro. Das linke Mikro ist das schwächere.

## Angewendet auf dem Pi (14:10)
- `~/micbench/apply_alc.sh`: Baseline wiederhergestellt, PGA per Echt-Write auf 41, ALC-Parameter gesetzt, `ALC Function`=3, `sudo alsactl store` (wird beim Boot über alsa-restore geladen). In `~/alsa-setup.sh` drei ALC-Zeilen ergänzt (Backup vorhanden).
- amixer-Diff gegenüber dem Ausgangszustand: nur `ALC Function` 0 → 3.
- Dienste `linux-voice-assistant` und `lva-respeaker2mic` laufen (active), Ports 6053/6055 lauschen, HA ist verbunden, PipeWire hält das Capture-Device.
