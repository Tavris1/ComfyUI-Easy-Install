<a id="de"></a>

<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<strong>Deutsch</strong> |
<a href="README.fr.md#fr">Français</a> |
<a href="README.ru.md#ru">Русский</a> |
<a href="README.tr.md#tr">Türkçe</a> |
<a href="README.vi.md#vi">Tiếng Việt</a>
</p>

---

<div align="center">
  <img src="EZi-Logo.svg" width="120" alt="EZi Logo">
  <h1>ComfyUI-Easy-Install</h1>
  <p align="center">
    <strong>Mit EZi Desktop kannst du die portable ComfyUI-Version mit einem Klick installieren, verwalten und anpassen.</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

<p align="center">
  <a href="#install">📥 <strong>Installieren</strong></a> &nbsp;·&nbsp;
  <a href="#features">✨ Funktionen</a> &nbsp;·&nbsp;
  <a href="#requirements">💻 Systemanforderungen</a> &nbsp;·&nbsp;
  <a href="#help">🩺 Hilfe</a> &nbsp;·&nbsp;
  <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
  <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
  <a href="#support">❤️ Unterstützen</a>
</p>

<br>

![ComfyUI Screenshot](ComfyUI-ivo.png)

**Neu bei EZi?** [EZi im Comic kennenlernen](#comic)

</div>

<a id="features"></a>

## ✨ Funktionen

**ComfyUI-Easy-Install** installiert eine portable ComfyUI-Version mit eigenem Python, einsatzbereiten Nodes und **EZi Desktop**.

- **Ein Klick** - Automatische Einrichtung von Git, Python, PyTorch, ComfyUI und Nodes
- **Keine manuelle Einrichtung** - Python, ComfyUI und Modelle in einem Ordner
- **Erweiterungen per Klick** - Nunchaku, SageAttention, FlashAttention, InsightFace und weitere
- **EZi Desktop** - Eigenes Fenster mit intelligenter Konsole und Menü
  - PyTorch/CUDA-Versionen (Torch-Pack)
  - ComfyUI- und Frontend-Versionen
  - Modellordner und Input/Output/User-Ordner
  - Startargumente und Dynamic VRAM
  - ComfyUI-Manager und festgeschriebene Pakete
  - UV/PIP-Cache und GGUF-Konvertierung
- **EZi Launcher** - Starten, aktualisieren, Ordner öffnen und Sicherungsstände speichern oder wiederherstellen

<details>
<summary><b>Funktionen von EZi Desktop</b></summary>

- ComfyUI im eigenen Fenster, im Browser oder in beiden ausführen
- Benachrichtigungen über neue ComfyUI- und EZi-Versionen
- Modelle direkt im passenden Ordner speichern
- **Konsole**
  - Suchen (Strg+F) und Protokoll als .txt speichern (Strg+S)
  - In ein separates Fenster auslagern
  - Markierten Text kopieren, speichern, mit Google suchen oder Claude und ChatGPT fragen
- **Bildschirmaufnahme** - Bildschirmfoto oder Video
- **Modellordner** - Mehrere vorhandene Ordner verknüpfen
- **Eigene Input-, Output- und User-Ordner**
- **Startargumente** - Editor mit allen Optionen
- **ComfyUI-Manager** - Neue oder klassische Oberfläche, Sicherheitsstufe, Installation per pip oder Git-URL
- **Paketversionen fixieren** - Versionen festschreiben, etwa `numpy==1.26.4`
- **Paketcache** - UV/PIP-Cache behalten oder leeren
- **Systeminformationen** - GPU, RAM, Python, Torch, ComfyUI, lange Pfade
- Design, Schriftgröße, Kurzinfos und Konsolenhintergrund
- Links zu Pixaromas Workflows und ComfyUI-Kurs

</details>

---

<a id="requirements"></a>

## 💻 Systemanforderungen

| | |
|---|---|
| **Betriebssystem** | Windows 10 / 11, 64 Bit |
| **GPU** | NVIDIA RTX Serie 20 oder neuer |
| **Treiber** | NVIDIA 580 oder neuer (empfohlen) |
| **RAM** | Mindestens 8 GB, empfohlen 16 GB oder mehr |
| **Speicherplatz** | Mindestens 15 GB frei plus Platz für Modelle (SSD empfohlen) |
| **Internet** | Während der Installation erforderlich |

> [!NOTE]
> Bei Treibern vor Version **580** werden **CUDA 12.8** und **Torch 2.8.0** installiert. Aktualisiere den Treiber für **CUDA 13.0** und **Torch 2.11.0**.

---

<a id="install"></a>

## 🖥️ Installation unter Windows

> [!IMPORTANT]
> - Verwende einen kurzen Pfad mit englischen Zeichen, etwa `D:\AI\`.

1. [**📥 Neueste Version herunterladen**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. ZIP-Datei in einen neuen Ordner entpacken
3. Ausführen: **`ComfyUI-Easy-Install.bat`**
4. Warten, bis die Installation abgeschlossen ist
5. Auf **Start ComfyUI** klicken oder die Desktopverknüpfung **ComfyUI-EZi Launcher** öffnen

<details>
<summary><b>Was wird installiert?</b></summary>

| Komponente | Version |
|---|---|
| [Git](https://git-scm.com/) | Neueste Version, nur wenn Git fehlt |
| [Python](https://www.python.org/downloads/release/python-31210/) | 3.12.10 Eingebettet, Prüfsumme geprüft |
| PyTorch | 2.11.0 + CUDA 13.0 oder 2.8.0 + CUDA 12.8 |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | Neueste Version |
| ComfyUI-Manager, Triton, ONNX Runtime GPU, llama-cpp-python | |
| [Enthaltene Nodes](#nodes) | Nodes aus den Pixaroma-Tutorials |
| Einstiegsworkflows | Juggernaut Reborn, Z-Image Turbo |
| Beispielmedien | Im Ordner `ComfyUI\input` |
| ComfyUI-EZi Launcher | Desktopverknüpfung |

</details>

---

<a id="start"></a>

## ▶️ ComfyUI starten

Öffne **ComfyUI-EZi Launcher** und wähle einen Modus.

- **Desktop** - Im Fenster von EZi Desktop
- **Browser** - Im Browser mit der klassischen Konsole
- **Hybrid** - Im Browser mit der EZi-Konsole

Mit **KitchenAttention**, **SageAttention** oder **FlashAttention** starten. Für Sage und Flash zuerst die Erweiterung installieren.

---

<a id="addons"></a>

## 🧩 Erweiterungen

Die Erweiterungen findest du im Ordner **Add-ons**, die meisten auch unter **EZi Desktop > Menu**.

| Erweiterung | Funktion |
|---|---|
| **Easy-Models-Linker** | Bindet den vorhandenen Ordner **models** ein.<br>Ausgenommen sind **LLM** und **llm_gguf**. |
| **Easy-System-Checker** | Zeigt Hardware- und Softwareinformationen |
| **Nunchaku** | Installiert [Nunchaku](https://github.com/nunchaku-ai/nunchaku) |
| **SageAttention-Multi** | Installiert [SageAttention](https://github.com/woct0rdho/SageAttention) v2.2.0 und v3 (v3 nur auf RTX 50) |
| **FlashAttention** | Installiert [FlashAttention](https://github.com/Dao-AILab/flash-attention) v2.8.3 |
| **InsightFace** | Installiert [InsightFace](https://github.com/deepinsight/insightface) |
| **Trellis2 + Pixal3D** | Installiert [Trellis 2.0 + Pixal3D @visualbruno](https://github.com/visualbruno/ComfyUI-Trellis2) samt Modell |
| **Torch-Pack** | Wechselt die PyTorch- und CUDA-Versionen |
| **Easy-model2GGUF** | Konvertiert Modelle zu GGUF (Q2_K bis Q8_0) |
| **Long-Paths-Enabler** | Aktiviert lange Windows-Pfade |
| **Toggle-DynamicVRAM** | Schaltet folgende Option um: `--disable-dynamic-vram` |

<details>
<summary><b>Torch-Pack-Versionen und unterstützte Erweiterungen</b></summary>

| Torch | CUDA | Nunchaku | Sage v2 | Sage v3 | Flash | Trellis2 |
|---|---|:---:|:---:|:---:|:---:|:---:|
| 2.7.1 | 12.8 | ✅ | ✅ | ✅ | ✅ | |
| 2.8.0 | 12.8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2.9.1 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.10.0 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| **2.11.0** (Standard) | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.12.1 | 13.0 | | ✅ | | ✅ | |
| 2.13.0 | 13.0 | | ✅ | | ✅ | |
| 2.14.1 | 13.0 | | ✅ | | ✅ | |

</details>

---

<a id="updates"></a>

## 🔄 Updates

Aktualisiere ComfyUI, Nodes und EZi über den Launcher. Speichere vor größeren Änderungen einen Sicherungsstand, den du mit einem Klick wiederherstellen kannst.

---

<a id="help"></a>

## 🩺 Fehlerbehebung

<details>
<summary><b>Installation abgebrochen oder fehlerhaft</b></summary>

- Bei Installationsfehlern öffne **Show log** und teile über **Copy details** die Einzelheiten im [Pixaroma-Discord](https://discord.gg/gggpkVgBf3).
- Das vollständige Protokoll steht in `ComfyUI-Easy-Install.log`.
- Lösche vor dem nächsten Versuch den unvollständigen Ordner `ComfyUI-Easy-Install`.

</details>

<details>
<summary><b>Windows 11: "Bad Image" (0xc0e90002)</b></summary>

- Bei „Bad Image“ (0xc0e90002) unter Windows 11 deaktiviere Smart App Control und starte ComfyUI neu.
- Dies verringert den Schutz vor nicht vertrauenswürdigen Apps.
- Lies vor dem Bestätigen die Windows-Warnung.

</details>

<details>
<summary><b>Dateien fehlen oder wurden blockiert</b></summary>

- Fehlen Dateien, prüfe den Schutzverlauf in Windows-Sicherheit auf blockierte Python-Dateien.
- Lasse die Dateien zu, lösche den Ordner und installiere erneut.

</details>

<details>
<summary><b>NVIDIA-Treiber nicht erkannt</b></summary>

- Wird der Treiber nicht erkannt, installiere den aktuellen von [nvidia.com/drivers](https://www.nvidia.com/drivers) und teste `nvidia-smi` im Terminal.

</details>

<details>
<summary><b>Nicht englische Zeichen im Pfad oder Benutzernamen</b></summary>

- Verschiebe das Installationsprogramm nach `D:\AI\`.
- Nicht englische Zeichen im Windows-Benutzernamen können weiterhin Probleme verursachen.

</details>

<details>
<summary><b>"ComfyUI is already running"</b></summary>

- Bei „ComfyUI is already running“ ist der Port (standardmäßig 8188) bereits belegt.
- Schließe das andere ComfyUI-Fenster und versuche es erneut.

</details>

<details>
<summary><b>Fehler bei langen Dateipfaden</b></summary>

- Bei Fehlern mit langen Pfaden starte **Long-Paths-Enabler** unter **Add-ons\Tools**.

</details>

---

<a id="uninstall"></a>

## 🧹 Deinstallation

Lösche den Ordner `ComfyUI-Easy-Install` und die Desktopverknüpfung **ComfyUI-EZi Launcher**.

---

<a id="nodes"></a>

## 📦 Enthaltene Nodes

<details>
<summary><b>Nodes aus den Pixaroma-Tutorials</b></summary>

| 🖼️ Bild | 🎬 Video | 🎵 Audio | 🧩 Werkzeuge und Workflows | 🤖 Modelle |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [WanVideoWrapper](https://github.com/kijai/ComfyUI-WanVideoWrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | | [KJNodes](https://github.com/kijai/ComfyUI-KJNodes) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | [SeedVR2 VideoUpscaler](https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler) | | [iTools](https://github.com/MohammadAboulEla/ComfyUI-iTools) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI Nodes](https://github.com/gseth/ControlAltAI-Nodes) | |
| [Krea2Edit](https://github.com/lbouaraba/comfyui-krea2edit) | | | ✨ [Pixaroma](https://gitlab.com/pixaroma/ComfyUI-Pixaroma) | |

</details>

---

<a id="comic"></a>

## 🎭 EZi im Comic kennenlernen

Neu bei EZi? Klicke im Comic auf ein Bild, um es in voller Größe zu sehen.

<table width="100%">
  <tr>
    <th width="16.66%">ComfyUI installieren</th>
    <th width="16.66%">EZi Launcher</th>
    <th width="16.66%">Modelle weiterverwenden</th>
    <th width="16.66%">Erweiterungen installieren</th>
    <th width="16.66%">Aktualisieren und wiederherstellen</th>
    <th width="16.66%">Dein System</th>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6"><img src="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6" width="100%" alt="ComfyUI installieren"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9"><img src="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9" width="100%" alt="EZi Launcher"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901"><img src="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901" width="100%" alt="Modelle weiterverwenden"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b"><img src="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b" width="100%" alt="Erweiterungen installieren"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6"><img src="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6" width="100%" alt="Aktualisieren und wiederherstellen"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3"><img src="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3" width="100%" alt="Dein System"></a></td>
  </tr>
</table>

<div align="center">

<a id="support"></a>

## ❤️ Entwicklung unterstützen

Gefällt dir das Projekt? Mit deiner Unterstützung hilfst du bei der Weiterentwicklung.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
