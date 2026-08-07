<p align="center">
🌍 
<strong>English</strong> |
<a href="docs/README.zh-CN.md#zh-cn">简体中文</a> |
<a href="docs/README.ja.md#ja">日本語</a> |
<a href="docs/README.ko.md#ko">한국어</a> |
<a href="docs/README.es.md#es">Español</a> |
<a href="docs/README.pt-BR.md#pt-br">Português</a> |
<a href="docs/README.de.md#de">Deutsch</a> |
<a href="docs/README.fr.md#fr">Français</a> |
<a href="docs/README.ru.md#ru">Русский</a> |
<a href="docs/README.tr.md#tr">Türkçe</a> |
<a href="docs/README.vi.md#vi">Tiếng Việt</a>
</p>

---

<div align="center">
  <img src="docs/EZi-Logo.svg" width="120" alt="EZi Logo">
  <h1>ComfyUI-Easy-Install</h1>
  <p align="center">
    <strong>One-click Portable ComfyUI with EZi Desktop</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/Tavris1/ComfyUI-Easy-Install/data/.github/badges/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)


<!--[![GitHub All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)-->
<!--[![GitHub Downloads Latest](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=⬇+latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)-->

  <p align="center">
    <a href="#%EF%B8%8F-windows-installation">📥 Install</a> &nbsp;·&nbsp;
    <a href="#-features">✨ Features/Components</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#%EF%B8%8F-support-development">❤️ Support Development</a>
  </p>

<!-- Dedicated to the **Pixaroma** community  
[![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
-->

---

![ComfyUI Screenshot](docs/ComfyUI-ivo.jpg)

</div>

## ✨ Features

**ComfyUI-Easy-Install** provides a portable ComfyUI environment with **EZi Desktop**.  
No manual Python or Git setup required.

Install complex packages such as Nunchaku, SageAttention, FlashAttention, InsightFace, and Trellis 2.0 with one click.

Manage **models, packages, PyTorch/CUDA versions, Dynamic VRAM,  
ComfyUI/frontend versions, UV/PIP caches, and GGUF conversion** from one place.

## 📦 Included Components
<details open>
<summary><b>Core Components</b></summary>

| 🔧 Component | 📝 Note |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - Latest (will install/update if needed) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - Embedded version |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - Latest stable version |

</details>

<details>
<summary><b>Nodes Used in Pixaroma Tutorials</b></summary>

| 🖼️ Image | 🎬 Video | 🎵 Audio | 🧩 Utility / WF | 🤖 Models |
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
<summary><b>Optional Add-ons & Tools</b></summary>

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

## 🖥️ Windows Installation

> [!IMPORTANT]
> - Do not run the installer as **Administrator**.
> - Avoid system folders (`Program Files`, `Windows`, `C:\` root).
> - Avoid spaces and special characters in folder names.
> - Make sure your NVIDIA drivers are up to date.

1. [**📥 DOWNLOAD LATEST VERSION**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Extract the ZIP file to a new folder and run **`ComfyUI-Easy-Install.bat`**
3. Optionally, after the setup, install or run components from the **Add-ons** folder or **EZi Desktop Menu**:
    - **Easy-Models-Linker** - *Uses existing **MODELS** folder via **extra_model_paths.yaml**, no re-download needed*
      - *Some folders like **LLM** and **llm_gguf** cannot be redirected this way*
    - **Easy-System-Checker** - *Provides information about key hardware and software components*
    - **Nunchaku** - *Installs Nunchaku. (Start `Nunchaku.bat` again if issues occur later)*
    - **SageAttention-Multi** - *Installs both SageAttention v2.2.0 and v3 (v3 effective only on NVIDIA 50-series GPUs)*
    - **FlashAttention** - *Installs FlashAttention v2.8.3*
    - **InsightFace** - *Installs InsightFace (Pretrained models for non-commercial research only)*
    - **Trellis2** - *Installs Trellis 2.0 and the model (requires `Torch 2.8.0+cu128` from the `Add-ons/Torch-Pack`)*
    - **Torch-Pack** - *Quick switch between:*  
      - *`Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`, `Torch 2.9.1+cu130`, `Torch 2.10+cu130` & `Torch 2.11+cu130`*
    - **Easy-model2GGUF** - *Convert & quantize models to GGUF (Q2_K–Q8_0) with 5D tensor fixes if available*
    - **Long-Paths-Enabler** - *Enables **Long Paths** in Windows 10/11. Essential for Python/ComfyUI*
    - **ComfyUI-Version-Switcher** - ***Reversible** rollback to a **previous** ComfyUI version if issues occur*
    - **Toggle-DynamicVRAM** - *Toggles **--disable-dynamic-vram** option in ComfyUI startup files*
    - **Update Easy-Install** - *Updates **Add-ons** and other folders. Creates desktop shortcuts*
    - **EZi Desktop Themes** - *via EZi Desktop > Menu > Advanced*
    - **Custom Input, Output & User folders** - *via EZi Desktop > Menu > Advanced*
    - **ComfyUI & Frontend Version Changer** - *via EZi Desktop > Menu > Advanced*
    - **UV & PIP cache cleaner** - *via EZi Desktop > Menu*
    - **ComfyUI-Manager Security-Level Config** - *Easy configuration of security_level via EZi Desktop > Menu*
    - **Pinned-Packages-Manager** - *Freeze package versions such as NumPy==1.26.4 via EZi Desktop > Menu*

<div align="center">

---

## ❤️ Support Development

Enjoy the project?  
If it saves you time, your support helps keep development and maintenance going.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
