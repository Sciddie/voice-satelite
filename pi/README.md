# Konfiguration des laufenden Satelliten

Kopien der Dateien vom eingerichteten Pi Zero 2 W. Pfade unter `pi/` entsprechen den Pfaden auf dem Gerät. `alsa-setup.sh` lag im Home-Verzeichnis (`~/alsa-setup.sh`), `micbench/` lag unter `~/micbench/`.

| Datei | Auf dem Pi | Inhalt |
|---|---|---|
| `boot/firmware/config.txt` | `/boot/firmware/config.txt` | Overlay `wm8960-soundcard`, I2C, I2S, SPI, Onboard-Audio aus |
| `alsa-setup.sh` | `~/alsa-setup.sh` | Mixer setzen und mit `alsactl store` sichern |
| `var/lib/alsa/asound.state` | `/var/lib/alsa/asound.state` | Gespeicherter ALSA-Stand, inklusive ALC Stereo |
| `etc/systemd/system/linux-voice-assistant.service` | gleich | LVA, Benutzer `florian`, Ports und Geräte |
| `etc/systemd/system/lva-respeaker2mic.service` | gleich | APA102-LEDs und Taste GPIO 17 |
| `micbench/apply_alc.sh` | `~/micbench/apply_alc.sh` | ALC anwenden, Skript und State sichern |
| `micbench/rec.sh` | `~/micbench/rec.sh` | Eine Benchmark-Aufnahme mit erzwungenem PGA-Schreibvorgang |
| `micbench/restore.sh` | `~/micbench/restore.sh` | Zurück auf `alsa-baseline.state` |

Beide Dienste sind **System-Units** unter `/etc/systemd/system/`, nicht Benutzer-Units. Sie laufen als Benutzer `florian` (UID 1000).

Nicht mit exportiert, weil sie Zugangsdaten wären oder schlicht nicht in diesem Paket lagen:

- `user-data`, `network-config` und SSH-Schlüssel der Erstinstallation
- `~/micbench/alsa-baseline.state` und `amixer-baseline.txt` (braucht `restore.sh`)
- `preferences.json` von LVA
- die Symlinks unter `multi-user.target.wants`

Die Dateien enthalten keine Passwörter, WLAN-Schlüssel oder Adressen. Die Einrichtung im Wurzel-README folgt diesen Dateien.
