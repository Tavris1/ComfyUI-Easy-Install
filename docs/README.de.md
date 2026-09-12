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
    <strong>ComfyUI mit einem Klick als portable Version mit EZi Desktop: ein vollständiges Dashboard für Pakete, Umgebungen und Konfiguration</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)


<!--[![GitHub All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)-->
<!--[![GitHub Downloads Latest](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=⬇+latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)-->

  <p align="center">
    <a href="#%EF%B8%8F-windows-installation">📥 Installieren</a> &nbsp;·&nbsp;
    <a href="#-funktionen">✨ Funktionen/Komponenten</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#%EF%B8%8F-entwicklung-unterstützen">❤️ Entwicklung unterstützen</a>
  </p>

<!-- Gewidmet der **Pixaroma**-Community  
[![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
-->

---

![ComfyUI Screenshot](ComfyUI-ivo.jpg)

</div>

## ✨ Funktionen

**ComfyUI-Easy-Install** bietet eine portable ComfyUI-Umgebung mit **EZi Desktop**.  
Keine manuelle Einrichtung von Python oder Git erforderlich.

Installieren Sie komplexe Pakete wie Nunchaku, SageAttention, FlashAttention, InsightFace und Trellis 2.0 mit einem Klick.

Verwalten Sie **Modelle, Pakete, PyTorch/CUDA-Versionen, Dynamic VRAM,  
ComfyUI-/Frontend-Versionen, UV/PIP-Caches und GGUF-Konvertierung** an einem Ort.

## 📦 Enthaltene Komponenten
<details open>
<summary><b>Kernkomponenten</b></summary>

| 🔧 Komponente | 📝 Hinweis |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) – Neueste Version (wird bei Bedarf installiert/aktualisiert) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) – Eingebettete Version |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) – Neueste stabile Version |

</details>

<details>
<summary><b>In Pixaroma-Tutorials verwendete Nodes</b></summary>

| 🖼️ Bild | 🎬 Video | 🎵 Audio | 🧩 Utility / WF | 🤖 Modelle |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [WanVideoWrapper](https://github.com/kijai/ComfyUI-WanVideoWrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | [FishAudioS2](https://github.com/Saganaki22/ComfyUI-FishAudioS2) | [KJNodes](https://github.com/kijai/ComfyUI-KJNodes) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SeedVR2 VideoUpscaler](https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | | | [iTools](https://github.com/MohammadAboulEla/ComfyUI-iTools) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI Nodes](https://github.com/gseth/ControlAltAI-Nodes) | |
| [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | | ✨[Pixaroma](https://github.com/pixaroma/ComfyUI-Pixaroma) | |
| | | | [Krea2T-Enhancer](https://github.com/capitan01R/ComfyUI-Krea2T-Enhancer) | |
| | | | [Krea2Edit](https://github.com/lbouaraba/comfyui-krea2edit) | |

</details>

<details>
<summary><b>Optionale Add-ons & Tools</b></summary>

| 🧩 Nodes | 🛠️ Tools |
|---|---|
| [Nunchaku](https://github.com/nunchaku-ai/nunchaku) | Easy-Models-Linker |
| [SageAttention (v2.2.0 and v3)](https://github.com/woct0rdho/SageAttention) | Easy-System-Checker |
| [FlashAttention](https://github.com/Dao-AILab/flash-attention) | ComfyUI-Version-Switcher |
| [InsightFace](https://github.com/deepinsight/insightface) | Easy-model2GGUF |
| [Trellis 2.0](https://github.com/visualbruno/ComfyUI-Trellis2) | Long-Paths-Enabler |
| | Torch-Pack |
| | Toggle-DynamicVRAM |
| | Update Easy-Install |

</details>

---

## 🖥️ Windows-Installation

> [!IMPORTANT]
> - Führen Sie den Installer nicht als **Administrator** aus.
> - Vermeiden Sie Systemordner (`Program Files`, `Windows`, `C:\` root).
> - Vermeiden Sie Leerzeichen und Sonderzeichen in Ordnernamen.
> - Stellen Sie sicher, dass Ihre NVIDIA-Treiber aktuell sind.

1. [**📥 NEUESTE VERSION HERUNTERLADEN**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Entpacken Sie die ZIP-Datei in einen neuen Ordner und führen Sie **`ComfyUI-Easy-Install.bat`** aus
3. Optional können Sie nach der Einrichtung Komponenten aus dem Ordner **Add-ons** oder dem **EZi Desktop Menu** installieren oder ausführen:
    - **Easy-Models-Linker** – *Verwendet den vorhandenen **MODELS**-Ordner über **extra_model_paths.yaml**, kein erneuter Download erforderlich*
      - *Einige Ordner wie **LLM** und **llm_gguf** können auf diese Weise nicht umgeleitet werden*
    - **Easy-System-Checker** – *Liefert Informationen über wichtige Hardware- und Softwarekomponenten*
    - **Nunchaku** – *Installiert Nunchaku*
    - **SageAttention-Multi** – *Installiert sowohl SageAttention v2.2.0 als auch v3 (v3 ist nur auf NVIDIA GPUs der 50er-Serie wirksam)*
    - **FlashAttention** – *Installiert FlashAttention v2.8.3*
    - **InsightFace** – *Installiert InsightFace (Pretrained models for non-commercial research only)*
    - **Trellis2** – *Installiert Trellis 2.0 und das Modell (erfordert `Torch 2.8.0+cu128` aus dem `Add-ons/Torch-Pack`)*
    - **Torch-Pack** – *Schneller Wechsel zwischen:`Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`,  
      `Torch 2.9.1+cu130`, `Torch 2.10+cu130`, `Torch 2.11+cu130`, `Torch 2.12.1+cu130` & `Torch 2.13.0+cu130`*
    - **Easy-model2GGUF** – *Modelle in GGUF (Q2_K–Q8_0) konvertieren und quantisieren, mit 5D-Tensor-Fixes, falls verfügbar*
    - **Long-Paths-Enabler** – *Aktiviert **Long Paths** in Windows 10/11. Wichtig für Python/ComfyUI*
    - **ComfyUI-Version-Switcher** – ***Reversibler** Rollback auf eine **frühere** ComfyUI-Version, falls Probleme auftreten*
    - **Toggle-DynamicVRAM** – *Schaltet die Option **--disable-dynamic-vram** in den ComfyUI-Startdateien ein bzw. aus*
    - **Update Easy-Install** – *Aktualisiert **Add-ons** und andere Ordner. Erstellt Desktop-Verknüpfungen*
    - **EZi Desktop Themes** – *über EZi Desktop > Menu > Advanced*
    - **Custom Input, Output & User folders** – *über EZi Desktop > Menu > Advanced*
    - **ComfyUI & Frontend Version Changer** – *über EZi Desktop > Menu > Advanced*
    - **UV & PIP cache cleaner** – *über EZi Desktop > Menu*
    - **ComfyUI-Manager Security-Level Config** – *Einfache Konfiguration von security_level über EZi Desktop > Menu*
    - **Pinned-Packages-Manager** – *Friert Paketversionen wie NumPy==1.26.4 über EZi Desktop > Menu ein*

<div align="center">

---

## ❤️ Entwicklung unterstützen

Gefällt Ihnen das Projekt?  
Wenn es Ihnen Zeit spart, hilft Ihre Unterstützung dabei, die Entwicklung und Wartung fortzuführen.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
