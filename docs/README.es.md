<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<strong>Español</strong> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<a href="README.de.md#de">Deutsch</a> |
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
    <strong>ComfyUI portátil con un solo clic y EZi Desktop: un panel completo para paquetes, entornos y configuración</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)


<!--[![GitHub All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)-->
<!--[![GitHub Downloads Latest](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=⬇+latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)-->

  <p align="center">
    <a href="#%EF%B8%8F-instalación-en-windows">📥 Instalar</a> &nbsp;·&nbsp;
    <a href="#-características">✨ Características/Componentes</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#%EF%B8%8F-apoyar-el-desarrollo">❤️ Apoyar el desarrollo</a>
  </p>

<!-- Dedicated to the **Pixaroma** community  
[![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
-->

---

![ComfyUI Screenshot](ComfyUI-ivo.jpg)

</div>

## ✨ Características

**ComfyUI-Easy-Install** proporciona un entorno ComfyUI portátil con **EZi Desktop**.  
No se requiere ninguna configuración manual de Python o Git.

Instala con un solo clic paquetes complejos como Nunchaku, SageAttention, FlashAttention, InsightFace y Trellis 2.0.

Gestiona **modelos, paquetes, versiones de PyTorch/CUDA, Dynamic VRAM,  
versiones de ComfyUI/frontend, cachés de UV/PIP y conversión GGUF** desde un solo lugar.

## 📦 Componentes incluidos
<details open>
<summary><b>Componentes principales</b></summary>

| 🔧 Componente | 📝 Nota |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - Última versión (se instalará/actualizará si es necesario) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - Versión Embedded |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - Última versión estable |

</details>

<details>
<summary><b>Nodes utilizados en los tutoriales de Pixaroma</b></summary>

| 🖼️ Imagen | 🎬 Vídeo | 🎵 Audio | 🧩 Utilidad / WF | 🤖 Modelos |
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
<summary><b>Add-ons y Tools opcionales</b></summary>

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

## 🖥️ Instalación en Windows

> [!IMPORTANT]
> - No ejecutes el instalador como **Administrator**.
> - Evita las carpetas del sistema (`Program Files`, `Windows`, raíz de `C:\`).
> - Evita los espacios y caracteres especiales en los nombres de las carpetas.
> - Asegúrate de que tus controladores NVIDIA estén actualizados.

1. [**📥 DOWNLOAD LATEST VERSION**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Extrae el archivo ZIP en una nueva carpeta y ejecuta **`ComfyUI-Easy-Install.bat`**
3. Opcionalmente, después de la configuración, instala o ejecuta componentes desde la carpeta **Add-ons** o **EZi Desktop Menu**:
    - **Easy-Models-Linker** - *Utiliza la carpeta **MODELS** existente mediante **extra_model_paths.yaml**, no es necesario volver a descargar*
      - *Algunas carpetas como **LLM** y **llm_gguf** no se pueden redirigir de esta manera*
    - **Easy-System-Checker** - *Proporciona información sobre los principales componentes de hardware y software*
    - **Nunchaku** - *Instala Nunchaku*
    - **SageAttention-Multi** - *Instala tanto SageAttention v2.2.0 como v3 (v3 solo es efectivo en NVIDIA 50-series GPUs)*
    - **FlashAttention** - *Instala FlashAttention v2.8.3*
    - **InsightFace** - *Instala InsightFace (los modelos preentrenados son solo para investigación no comercial)*
    - **Trellis2** - *Instala Trellis 2.0 y el modelo (requiere `Torch 2.8.0+cu128` de `Add-ons/Torch-Pack`)*
    - **Torch-Pack** - *Cambio rápido entre: `Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`,  
      `Torch 2.9.1+cu130`, `Torch 2.10+cu130`, `Torch 2.11+cu130`, `Torch 2.12.1+cu130` & `Torch 2.13.0+cu130`*
    - **Easy-model2GGUF** - *Convierte y cuantiza modelos a GGUF (Q2_K–Q8_0) con correcciones de tensor 5D si están disponibles*
    - **Long-Paths-Enabler** - *Activa **Long Paths** en Windows 10/11. Esencial para Python/ComfyUI*
    - **ComfyUI-Version-Switcher** - *Retroceso **reversible** a una versión **anterior** de ComfyUI si surgen problemas*
    - **Toggle-DynamicVRAM** - *Activa o desactiva la opción **--disable-dynamic-vram** en los archivos de inicio de ComfyUI*
    - **Update Easy-Install** - *Actualiza **Add-ons** y otras carpetas. Crea accesos directos en el escritorio*
    - **EZi Desktop Themes** - *mediante EZi Desktop > Menu > Advanced*
    - **Custom Input, Output & User folders** - *mediante EZi Desktop > Menu > Advanced*
    - **ComfyUI & Frontend Version Changer** - *mediante EZi Desktop > Menu > Advanced*
    - **UV & PIP cache cleaner** - *mediante EZi Desktop > Menu*
    - **ComfyUI-Manager Security-Level Config** - *Configuración sencilla de security_level mediante EZi Desktop > Menu*
    - **Pinned-Packages-Manager** - *Fija versiones de paquetes como NumPy==1.26.4 mediante EZi Desktop > Menu*

<div align="center">

---

## ❤️ Apoyar el desarrollo

¿Te gusta el proyecto?  
Si te ahorra tiempo, tu apoyo ayuda a mantener el desarrollo y el mantenimiento.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
