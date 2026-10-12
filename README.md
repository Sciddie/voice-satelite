# Voice-Satellit

Ein Home-Assistant-Sprachsatellit im gedruckten Gehäuse: Raspberry Pi Zero 2 W, keyestudio ReSpeaker 2-Mic Pi HAT v1.0 und ein kleiner Breitbandlautsprecher. Wake Word und Wiedergabe laufen auf dem Pi, die Sprachpipeline in Home Assistant. Die Anbindung nutzt die ESPHome-Integration.

![Gehäuse v3.7, Rendering](case/renders/c_cover.png)

| | |
|---|---|
| Gehäuse | [case/](case/README.md), Druck und Montage in [docs/voicesat-montageanleitung.pdf](docs/voicesat-montageanleitung.pdf) |
| Softwarestand des laufenden Pi | [pi/](pi/README.md) |
| Mikrofon-Messreihe | [mic-benchmark/](mic-benchmark/README.md) |

## Hardware

- **Raspberry Pi Zero 2 W**
- **keyestudio ReSpeaker 2-Mic Pi HAT v1.0** (WM8960, zwei Mikrofone, drei APA102-LEDs, Taste an GPIO 17, JST-Lautsprecherbuchse, Micro-USB). Dokumentation des Boards: [KS0314](https://docs.keyestudio.com/projects/KS0314/en/latest/docs/KS0314.html)
- **Kinyo-Lautsprecher**, 4 Ω, 5 W, quadratischer 3"-Korb, an der JST-Buchse des HAT
- **Versorgung über die Micro-USB-Buchse des HAT**
- Gedruckt auf einem **Bambu Lab A1**: Körper, Deckel, Gitter, Rohre und Stößel in **Bambu PLA Matte schwarz**, LED-Diffusor (Leuchtfläche 0,6 mm) in **Bambu PLA Basic weiß**

### Schrauben

Aus einem ISO-7380-Satz (Linsenkopf) mit ISO-4032-Muttern:

| Verbindung | Schraube | Mutter | Scheibe |
|---|---|---|---|
| Lautsprecher, 4 Ecken | M3×12 | M3, Tasche hinter der Front | M3, nötig (Langlöcher im Korb) |
| Deckel, 6 Dome | M3×12 | M3, von unten eingezogen | keine |
| HAT, Frontplatte, Rohr, Pi | M2.5×16, von vorn durchgehend | M2.5 auf der Pi-Rückseite | keine |

Summe: **10 × M3×12**, **4 × M2.5×16**, **10 × M3-Muttern**, **4 × M2.5-Muttern**, **4 × M3-Scheiben**. Optional, falls eine Schnapplasche am Gitter ausfällt: 2 × M2×6 und 2 × M2-Muttern.

Der Pi-HAT-Stapel klemmt über ein gedrucktes Rohr. Platinenabstand **11,0 mm** (3,0 mm Platte hinter der Rohrsenkung plus 8,0 mm Rohr). Die M2.5×16 endet 0,2 mm in der Mutter, etwa vier Gänge tragen. Nicht überziehen und keine Scheiben dazwischensetzen.

Dazu etwa 0,5 m geschlossenzelliges Schaumstoffband (3 mm breit, ca. 2 mm dick) für den Deckelrand, Knete oder Heißkleber zum Abdichten, 15–25 g Polyfill. Optional Silikonfüße Ø 10 mm und Bespannstoff.

## Drucken

Drucker Bambu Lab A1, Düse 0,4 mm, Prozess **0.20mm Standard @BBL A1**, Textured PEI. Schwarz PLA Matte, weiß PLA Basic. Vier Wände, fünf Decklagen, vier Bodenlagen, 25 % Gyroid, keine Stützen, keine Brim. Rohre und Stößel massiv (sechs Wände, 100 % Infill), Gitter 40 % Infill, die unteren 2,2 mm des Deckels massiv, Diffusor 100 % Infill.

Die 3MF-Dateien unter [`case/3mf/`](case/3mf/) sind schon platziert. Beim Import erscheint „load geometry data only“; das bestätigen, danach nicht drehen und nicht anordnen. Reihenfolge: schwarze Platte 1 (Gehäuse, fünf Rohre, zwei Stößel), schwarze Platte 2 (Deckel, Gitter), weiße Platte (zwei Diffusoren). Schätzungen in der PDF: etwa 204 g / 5 h, 67 g / 2 h 26 min und unter 1 g. Das sind PrusaSlicer-Werte, keine Bambu-Studio-Zeiten.

Einzelheiten, Objektausnahmen und was nach dem Druck zu beschneiden ist: [`case/README.md`](case/README.md) und die PDF.

## Montage

Die bebilderte Reihenfolge steht in [`docs/voicesat-montageanleitung.pdf`](docs/voicesat-montageanleitung.pdf). Kurz:

1. Sechs M3-Muttern in die Deckel-Dome ziehen, solange die Wanne leer ist. Vorn links mit der Pinzette.
2. Lautsprecher mit Scheiben von vorn verschrauben, Kabel am Treiber anschließen.
3. Schaumstoffband auf den Deckelrand.
4. HAT, vier M2.5×16, vier Rohre, Pi von hinten aufschieben, Muttern auf der Pi-Rückseite. Bei v3.7 darf die microSD stecken.
5. JST-Stecker durch den Schlitz über dem HAT in SPEAKER. Schlitz, Header-Schlitz und die vier HAT-Bohrungen von innen abdichten, sonst trifft der Gehäusedruck die Mikrofone.
6. Polyfill links der Mittelwand, weg von Membran und Pi.
7. Deckel mit sechs M3×12, Band etwa 1 mm zusammendrücken.
8. Diffusor und Stößel ins Gitter, Gitter einhaken und einklicken.

Eine SD-Anreißschablone liegt bei, falls noch ein v3.6-Körper im Einsatz ist. Für v3.7 ist sie unnötig. Details in [`case/README.md`](case/README.md).

## Software

Betriebssystem auf diesem Satelliten: **Raspberry Pi OS Lite, 64 Bit (Debian Trixie)**. Anmeldung per SSH-Schlüssel, eingerichtet über cloud-init. Die beiden Dienste und der ALSA-Stand sind vom laufenden Gerät kopiert und liegen unter [`pi/`](pi/README.md). Wo ein Schritt nur aus der Upstream-Doku stammt und nicht durch diese Dateien gedeckt ist, steht das dabei.

Konto auf diesem Gerät: **`florian`**, UID **1000**. Wer ein anderes Konto anlegt, ersetzt den Namen in den Unit-Dateien, in den Pfaden und die UID in `PULSE_SERVER` und `XDG_RUNTIME_DIR`.

### Image schreiben

Image: Raspberry Pi OS Lite (64-bit), Release auf Debian Trixie, über den [Raspberry Pi Imager](https://www.raspberrypi.com/software/). Aktuelle Trixie-Images richten den ersten Start per cloud-init ein (`user-data` und `network-config` auf der FAT-Boot-Partition). Beschreibung von Raspberry Pi: [Cloud-init on Raspberry Pi OS](https://www.raspberrypi.com/news/cloud-init-on-raspberry-pi-os/). Die `user-data` dieses Satelliten war nicht im Export. Die folgende Datei ist deshalb eine Vorlage nach dieser Beschreibung, zugeschnitten auf das Konto aus den Unit-Dateien, und nicht die Datei von der Karte.

```yaml
#cloud-config
hostname: HIER-HOSTNAME
manage_etc_hosts: true
users:
  - name: florian
    groups: users,adm,dialout,audio,netdev,video,plugdev,input,gpio,spi,i2c,render,sudo
    shell: /bin/bash
    lock_passwd: true
    ssh_authorized_keys:
      - ssh-ed25519 AAAA...hier den eigenen öffentlichen Schlüssel einsetzen...
    sudo: ALL=(ALL) NOPASSWD:ALL
enable_ssh: true
ssh_pwauth: false
```

Die Zeile `#cloud-config` muss die erste Zeile sein. `lock_passwd: true` und `ssh_pwauth: false` schalten die Passwortanmeldung ab. Den öffentlichen Schlüssel lokal einsetzen, nicht ins Repository schreiben.

WLAN steht in `network-config` auf derselben Partition (Netplan, Renderer NetworkManager). Die Datei bleibt auf der Karte. Kein WLAN-Schlüssel und keine Adresse gehören in dieses Repository. Ohne Netz beim ersten Start erreicht cloud-init den Pi nicht per SSH.

SPI, I2C und I2S setzt auf diesem Gerät nicht die cloud-init-Vorlage, sondern [`pi/boot/firmware/config.txt`](pi/boot/firmware/config.txt).

### Soundkarte (WM8960)

Der HAT hängt am Overlay **`wm8960-soundcard`** aus der Raspberry-Pi-Firmware, nicht am älteren DKMS-Treiber `seeed-voicecard` und nicht am Seeed-Overlay `respeaker-2mic-v1_0`. Das steht so in der kopierten `config.txt`; der Kommentar in [`pi/alsa-setup.sh`](pi/alsa-setup.sh) nennt es das „stock wm8960-soundcard overlay“. Die ALSA-Karte heißt dadurch `wm8960soundcard`. Das Seeed-Overlay meldet die Karte als `seeed2micvoicec`. Die Mixer-Befehle unten träfen dann daneben. Das Beispiel in der LVA-Doku (`sudo ./install.sh` aus `respeaker/seeed-voicecard`) beschreibt diesen Satelliten nicht.

Das Overlay liegt im Kernel-Baum als [`wm8960-soundcard-overlay.dts`](https://github.com/raspberrypi/linux/blob/rpi-6.12.y/arch/arm/boot/dts/overlays/wm8960-soundcard-overlay.dts) und als fertiges `wm8960-soundcard.dtbo` im [Firmware-Repository](https://github.com/raspberrypi/firmware/blob/master/boot/overlays/wm8960-soundcard.dtbo). Der README-Eintrag des Kernels bezeichnet es als Waveshare-WM8960-Overlay. Derselbe Codec und dieselbe Beschaltung sitzen auf dem keyestudio-HAT v1.0; auf diesem Pi ist die Karte damit hochgekommen (`state.wm8960soundcard` in der gesicherten `asound.state`).

In `/boot/firmware/config.txt` das Onboard-Audio aus lassen und unter `[all]` den Block aus der kopierten Datei setzen:

```ini
#dtparam=audio=on (disabled for ReSpeaker HAT)
dtparam=audio=off

[all]
# ReSpeaker 2-Mics Pi HAT v1 (WM8960)
dtparam=i2c_arm=on
dtparam=i2s=on
dtparam=spi=on
dtoverlay=wm8960-soundcard
```

`dtparam=spi=on` braucht der APA102-Streifen (GPIO 10/11, `/dev/spidev0.0`). Danach neu starten und prüfen:

```bash
ls /boot/firmware/overlays/wm8960-soundcard.dtbo
arecord -l
aplay -l
```

In der Liste muss `wm8960soundcard` stehen. Fehlt die `.dtbo`, ist das Firmware-Paket älter als das Overlay. Ein `sudo apt update && sudo apt full-upgrade` holt die Overlays der aktuellen Raspberry-Pi-Firmware. Ob jedes Trixie-Image die Datei schon am ersten Tag mitbringt, ist hier nicht an einem frischen Image geprüft; auf dem laufenden Satelliten ist das Overlay in `config.txt` eingetragen und die Karte existiert.

### PipeWire

LVA spricht PulseAudio. Auf Raspberry Pi OS ist das die Pulse-Schnittstelle von PipeWire. Pakete und Linger für ein Lite-Image ohne grafische Sitzung stehen in der [LVA-Audioserver-Doku](https://github.com/OHF-Voice/linux-voice-assistant/blob/main/docs/install_audioserver.md):

```bash
sudo apt update
sudo apt install -y pipewire wireplumber pipewire-audio-client-libraries \
  pipewire-audio pipewire-pulse pulseaudio-utils alsa-utils
sudo mkdir -p /var/lib/systemd/linger
sudo touch /var/lib/systemd/linger/florian
loginctl show-user florian | grep Linger
```

`Linger=yes` hält die Benutzersitzung nach dem Abmelden von SSH. Ohne sie verschwindet `/run/user/1000/pulse/native`, und die Unit findet keinen Ton. Ob Linger auf diesem Pi gesetzt war, liegt nicht in den exportierten Dateien. Die Unit verlangt den Socket an genau diesem Pfad.

Die optionale PipeWire-Taktung auf 16 kHz aus derselben Upstream-Doku ist hier nicht als Datei unter `/etc/pipewire/` mitgekommen. Der Benchmark hat nur gezeigt, dass eine 48-kHz-Aufnahme die Erkennung nicht verbessert.

### linux-voice-assistant

Projekt: [OHF-Voice/linux-voice-assistant](https://github.com/OHF-Voice/linux-voice-assistant). Dieser Satellit nutzt die Bare-Metal-Installation, nicht Docker Compose: die Unit startet `docker-entrypoint.sh` aus einem virtualenv, so wie es die [Installationsanleitung](https://github.com/OHF-Voice/linux-voice-assistant/blob/main/docs/install_application.md) für systemd beschreibt. Der Git-Stand und die beim Build gesetzten Compiler-Flags stehen nicht in der Unit. Für den Zero 2 W nennt Upstream `script/setup --cxxflags="-O1 -g0" --makeflags="-j1"`, weil der Bauvorgang sonst knapp an RAM und Zeit scheitert. Ob genau diese Flags verwendet wurden, ist nicht belegt.

```bash
sudo apt install -y avahi-utils pulseaudio-utils alsa-utils \
  pipewire-bin pipewire-alsa pipewire-pulse build-essential libmpv-dev \
  libasound2-plugins ca-certificates iproute2 procps git jq curl wget \
  python3-venv python3-dev
git clone https://github.com/OHF-Voice/linux-voice-assistant.git
cd linux-voice-assistant
chmod +x docker-entrypoint.sh
script/setup --cxxflags="-O1 -g0" --makeflags="-j1"
```

Die Unit vom Gerät nach `/etc/systemd/system/linux-voice-assistant.service` legen. Inhalt, geprüft gegen den laufenden Satelliten:

- Benutzer `florian`, Arbeitsverzeichnis `/home/florian/linux-voice-assistant`
- `CLIENT_NAME=voice-sat`
- `PORT=6053` (ESPHome-API)
- `PULSE_SERVER=/run/user/1000/pulse/native`, `XDG_RUNTIME_DIR=/run/user/1000`
- Eingabe `Built-in Audio Stereo`
- Ausgabe `pipewire/alsa_output.platform-soc_sound.stereo-fallback`
- Wake Word `okay_nabu`, Stoppwort `stop`
- `ExecStart=.../docker-entrypoint.sh`, Neustart immer, 5 Sekunden Pause

Die Gerätenamen sind die PipeWire-Namen dieses Pi. Nach dem ersten Start der Soundkarte mit `pactl list short sources` und `pactl list short sinks` gegenprüfen, falls eine neuere PipeWire-Version sie anders nennt. `preferences.json` wird von LVA angelegt und war nicht im Export; Wake Word und weitere Schalter lassen sich später auf der Geräte-Seite in Home Assistant ändern.

### LEDs und Taste

[`lva-respeaker2mic.service`](pi/etc/systemd/system/lva-respeaker2mic.service) startet das Upstream-Beispiel [`respeaker_2mic_hat.py`](https://github.com/OHF-Voice/linux-voice-assistant/blob/main/examples/ReSpeaker%202mic%20HAT/respeaker_2mic_hat.py) gegen `localhost:6055`. Eigenes virtualenv unter `/home/florian/lva-respeaker2mic/.venv`, Gruppen `gpio` und `spi` über `SupplementaryGroups`. Die Unit kommt nach `linux-voice-assistant.service`.

Die `requirements.txt` des Beispiels war nicht auf dem Pi exportiert. Upstream (Stand der Doku beim Schreiben) listet `websockets`, `spidev`, `gpiozero` und `lgpio`. Das virtualenv auf dem Gerät liegt an dem Pfad, den die Unit aufruft; die genauen Versionen darin sind nicht mitkopiert.

```bash
mkdir -p /home/florian/lva-respeaker2mic
python3 -m venv /home/florian/lva-respeaker2mic/.venv
/home/florian/lva-respeaker2mic/.venv/bin/pip install -r \
  "/home/florian/linux-voice-assistant/examples/ReSpeaker 2mic HAT/requirements.txt"
sudo cp pi/etc/systemd/system/lva-respeaker2mic.service /etc/systemd/system/
sudo cp pi/etc/systemd/system/linux-voice-assistant.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now linux-voice-assistant.service
sudo systemctl enable --now lva-respeaker2mic.service
```

`enable` trägt die Units in `multi-user.target` ein. Die exportierten Dateien haben `WantedBy=multi-user.target`; die Symlinks selbst waren nicht im Export.

Die drei LEDs und die Taste (ein Druck startet oder stoppt je nach Zustand, Doppel-, Dreifach- und Langdruck gehen als Ereignisse nach Home Assistant) beschreibt die [Beispiel-Doku](https://github.com/OHF-Voice/linux-voice-assistant/blob/main/examples/ReSpeaker%202mic%20HAT/DOCS.md). Dort ist der Weg Docker. Auf diesem Pi läuft dasselbe Skript als systemd-Dienst.

### ALSA-Einstellungen

Erst setzen, wenn `arecord -l` die Karte `wm8960soundcard` zeigt. [`pi/alsa-setup.sh`](pi/alsa-setup.sh) schreibt den Pfad und speichert ihn:

```bash
install -m 755 pi/alsa-setup.sh /home/florian/alsa-setup.sh
sudo -u florian /home/florian/alsa-setup.sh
```

Aufnahme, so wie sie im gespeicherten State und im Skript steht:

| Regler | Wert | Bedeutung im State |
|---|---|---|
| `Capture` | 65 % (`sset`), entspricht 41 von 0…63 | `Capture Volume` 41, 41 |
| `Left/Right Input Boost Mixer LINPUT1/RINPUT1` | 2 | +20 dB (`dbvalue` 2000) |
| `ADC PCM` | 195 | Digitalverstärkung 0 dB im State-Kommentar |
| `ADC High Pass Filter Switch` | aus | `false` |
| `ALC Function` | 3 | Stereo |
| `ALC Target` / `ALC Max Gain` | 4 / 7 | Codec-Defaults, im Skript gesetzt |
| `ALC Min Gain`, Hold, Decay, Attack, Mode, Noise Gate | 0, 0, 3, 2, ALC, aus | stehen so im State; das Setup-Skript lässt sie auf dem Treiber-Default |

Wiedergabe im Skript: `Playback` 230, `Speaker` 114, `Speaker AC` 0, `Speaker DC` 0, Zero-Cross an Speaker und Headphone. Der Lautsprecher am JST hängt am Speaker-Ausgang.

Abweichung: das Skript setzt `Headphone` auf 100, die gesicherte [`asound.state`](pi/var/lib/alsa/asound.state) hat `Headphone Playback Volume` auf 0. Für den JST-Lautsprecher zählt `Speaker` 114, das in beiden Quellen gleich ist. Wer den Kopfhörerausgang braucht, setzt `Headphone` danach bewusst und speichert erneut. Den zuletzt gesicherten Stand, inklusive Kopfhörer auf 0, spielt man so zurück:

```bash
sudo alsactl restore -f pi/var/lib/alsa/asound.state wm8960soundcard
```

ALC aus, Capture wieder auf 41, dann sichern. Der Zwischenschritt auf 0 erzwingt den Register-Schreibvorgang:

```bash
amixer -c wm8960soundcard cset name='ALC Function' 0
amixer -c wm8960soundcard cset name='Capture Volume' 0,0
amixer -c wm8960soundcard cset name='Capture Volume' 41,41
sudo alsactl store
```

[`pi/micbench/restore.sh`](pi/micbench/restore.sh) stellt zusätzlich eine Baseline-Datei `~/micbench/alsa-baseline.state` zurück. Die Datei ist nicht im Repository.

### Home Assistant

LVA meldet sich über die ESPHome-API. In Home Assistant: **Einstellungen → Geräte & Dienste → Integration hinzufügen → ESPHome → Weitere Instanz von ESPHome einrichten**, dann die Adresse des Satelliten mit Port **6053**. Das ist der Weg aus der [LVA-Doku](https://github.com/OHF-Voice/linux-voice-assistant/blob/main/docs/install_application.md); die Unit setzt `PORT=6053`. Die Peripherie-Websocket-API lauscht auf **6055** und bleibt auf dem Pi (`--host localhost`).

Prüfen, ohne eine Adresse zu notieren:

```bash
systemctl is-active linux-voice-assistant lva-respeaker2mic
ss -ltn | grep -E ':6053|:6055'
```

Beide Dienste sollen `active` sein, beide Ports sollen lauschen. `apply_alc.sh` macht denselben Check nach dem Setzen der ALC.

## Mikrofon-Benchmark

Die Messreihe ist in [`mic-benchmark/report.md`](mic-benchmark/report.md) ausgeschrieben, die Grafik liegt daneben.

Die übernommene Einstellung ist die aus dem ALSA-Abschnitt. Mit echter Stimme ging die Wortfehlerrate von Whisper medium von **11,2 %** (Baseline, Capture 41, Take B) auf **2,5 %** mit ALC Stereo (8 von 10 Sätzen exakt). Eine Studiomikrofon-Referenz derselben Aufnahme lag bei 1,2 %. Im TTS-Test über einen Lautsprecher fiel die WER von 10,4 % auf 6,2 %. Mehr analoge Verstärkung ohne ALC half wenig: der SNR bleibt bei etwa 20–25 dB und hängt am Raum, nicht am Codec.

Rauschunterdrückung (`noisereduce`, RNNoise) und eine Aufnahme mit 48 kHz, heruntergerechnet auf 16 kHz, haben die Erkennung nicht verbessert. Der ADC-Hochpass auch nicht. Software-Normalisierung plus 80-Hz-Hochpass kam der ALC nahe, ist in LVA aber nicht als Schalter vorhanden. `MIC_NOISE_SUPPRESSION` bleibt deshalb aus (Upstream-Default 0).

Grenze: in Pausen regelt die ALC hoch. Der Rauschboden steigt, der SNR während der Sprache bleibt. Fehlauslösungen des Wake Words beobachten. Die Stichprobe ist klein (zehn Sätze), der Schalldruck war nicht kalibriert, und Whisper auf dem Auswerterechner ist nicht dasselbe Modell wie die Pipeline in Home Assistant.

## Lizenz

Das Gehäuse ist ein persönliches Remix, angeregt vom MakerWorld-Modell [„Wyoming Satellite Homeassistant Jarvis Raspi 2W“](https://makerworld.com/en/models/638687). Für die Dateien unter `case/` liegt keine eigene Open-Source-Lizenz bei. Es gilt, was die Bedingungen des Originalmodells erlauben.

Die Auswerteskripte unter `mic-benchmark/` kann man unter der MIT-Lizenz weitergeben. Eine `LICENSE`-Datei ist bewusst nicht angelegt.

## Was nicht im Repository steckt

- WAV-Aufnahmen des Benchmarks (`*.wav` ist ignoriert)
- Gehäuse-Stände vor v3.7 und die Entwurfsskripte
- cloud-init-`user-data`, `network-config`, Passwörter, WLAN-Schlüssel, SSH-Schlüssel, IP-Adressen
- `preferences.json`, der LVA-Git-Stand, die pip-Versionen im Peripherie-virtualenv
- `~/micbench/alsa-baseline.state`
- ein Nachweis, dass Linger auf diesem Pi gesetzt ist und welche `script/setup`-Flags gelaufen sind
- ein Probelauf von Bambu Studio mit den 3MF-Dateien und ein Neutrendern der STL in OpenSCAD
