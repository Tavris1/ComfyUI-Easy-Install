<a id="es"></a>

<p align="center">
🌍 
<a href="../README.md#english">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<strong>Español</strong> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<a href="README.de.md#de">Deutsch</a> |
<a href="README.fr.md#fr">Français</a> |
<a href="README.ru.md#ru">Русский</a> |
<a href="README.tr.md#de">Türkçe</a> |
<a href="README.vi.md#vi">Tiếng Việt</a>
</p>

---

<div align="center">
  <img src="docs/EZi-Logo.svg" width="120" alt="EZi Logo">
  <h1>ComfyUI-Easy-Instalar</h1>
  <p align="center">
    <strong>ComfyUI portátil con un clic mediante EZi Desktop</strong><br />
    Windows • GPU NVIDIA • Edición Comunitaria de Pixaroma
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/Tavris1/ComfyUI-Easy-Install/Windows/.github/badges/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

  <p align="center">
    <a href="#%EF%B8%8F-windows-installation">📥 Instalar</a> &nbsp;·&nbsp;
    <a href="#-features">✨ Funciones/Componentees</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-Instalar/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#%EF%B8%8F-support-development">❤️ Apoyar el desarrollo</a>
  </p>

---

![ComfyUI Screenshot](docs/ComfyUI-ivo.jpg)

</div>

## ✨ Funciones

****ComfyUI-Easy-Instalar** proporciona un entorno portátil de ComfyUI con **EZi Desktop**.  
No requiere configurar Python ni Git manualmente.

Instala con un clic paquetes complejos como Nunchaku, SageAttention, FlashAttention, InsightFace y Trellis 2.0.

Gestiona desde un solo lugar **modelos, paquetes, versiones de PyTorch/CUDA, Dynamic VRAM, versiones de ComfyUI/frontend, cachés de UV/PIP y conversión a GGUF**.

## 📦 Componentees incluidos
<details open>
<summary><b>Componentees principales</b></summary>

| 🔧 Componente | 📝 Nota |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - Última versión (se instalará/actualizará si es necesario) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - Versión integrada |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - Última versión estable |

</details>

<details>
<summary><b>Nodos usados en los tutoriales de Pixaroma</b></summary>

| 🖼️ Imagen | 🎬 Vídeo | 🎵 Audio | 🧩 Utilidad / WF | 🤖 Modelos |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [VídeoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VídeoHelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [WanVídeoWrapper](https://github.com/kijai/ComfyUI-WanVídeoWrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | [FishAudioS2](https://github.com/Saganaki22/ComfyUI-FishAudioS2) | [KJNodos](https://github.com/kijai/ComfyUI-KJNodos) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SeedVR2 VídeoUpscaler](https://github.com/numz/ComfyUI-SeedVR2_VídeoUpscaler) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | | | [iHerramientas](https://github.com/MohammadAboulEla/ComfyUI-iHerramientas) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI Nodos](https://github.com/gseth/ControlAltAI-Nodos) | |
| [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | | ✨[Pixaroma](https://github.com/pixaroma/ComfyUI-Pixaroma) | |
| | | | [Krea2T-Enhancer](https://github.com/capitan01R/ComfyUI-Krea2T-Enhancer) | |
| | | | [Krea2Edit](https://github.com/lbouaraba/comfyui-krea2edit) | |

</details>

<details>
<summary><b>Complementos y herramientas opcionales</b></summary>

| 🧩 Nodos | 🛠️ Herramientas |
|---|---|
| [Nunchaku](https://github.com/nunchaku-ai/nunchaku) | Easy-Modelos-Linker |
| [SageAttention (v2.2.0 and v3)](https://github.com/woct0rdho/SageAttention) | Easy-System-Checker |
| [FlashAttention](https://github.com/Dao-AILab/flash-attention) | ComfyUI-Version-Switcher |
| [InsightFace](https://github.com/deepinsight/insightface) | Easy-model2GGUF |
| [Trellis 2.0](https://github.com/visualbruno/ComfyUI-Trellis2) | Long-Paths-Enabler |
| | Torch-Pack |
| | Toggle-DynamicVRAM |
| | Update Easy-Instalar |

</details>

---

## 🖥️ Instalación en Windows

> [!IMPORTANT]
> - No ejecutes el instalador como **Administrador**.
> - Evita las carpetas del sistema (`Program Files`, `Windows`, raíz de `C:\`).
> - Evita espacios y caracteres especiales en los nombres de las carpetas.
> - Asegúrate de que los controladores NVIDIA estén actualizados.

1. [**📥 DESCARGAR ÚLTIMA VERSIÓN**](https://github.com/Tavris1/ComfyUI-Easy-Instalar/releases/latest/download/ComfyUI-Easy-Instalar.zip)
2. Extrae el ZIP en una carpeta nueva y ejecuta **`ComfyUI-Easy-Instalar.bat`**
3. Después de la configuración, puedes instalar o ejecutar componentes desde la carpeta **Add-ons** o el **EZi Desktop Menu**:
    - **Easy-Modelos-Linker** - *Usa la carpeta **MODELS** existente mediante **extra_model_paths.yaml**, sin necesidad de volver a descargarla*
      - *Algunas carpetas, como **LLM** y **llm_gguf**, no pueden redirigirse de esta forma*
    - **Easy-System-Checker** - *Proporciona información sobre los principales componentes de hardware y software*
    - **Nunchaku** - *Instala Nunchaku. (Vuelve a ejecutar `Nunchaku.bat` si aparecen problemas más adelante)*
    - **SageAttention-Multi** - *Instala SageAttention v2.2.0 y v3 (v3 solo funciona en GPU NVIDIA de la serie 50)*
    - **FlashAttention** - *Instala FlashAttention v2.8.3*
    - **InsightFace** - *Instala InsightFace (modelos preentrenados solo para investigación no comercial)*
    - **Trellis2** - *Instala Trellis 2.0 y el modelo (requiere `Torch 2.8.0+cu128` de `Add-ons/Torch-Pack`)*
    - **Torch-Pack** - *Cambio rápido entre:*  
      - *`Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`, `Torch 2.9.1+cu130`, `Torch 2.10+cu130` & `Torch 2.11+cu130`*
    - **Easy-model2GGUF** - *Convierte y cuantiza modelos a GGUF (Q2_K–Q8_0), con correcciones de tensores 5D cuando están disponibles*
    - **Long-Paths-Enabler** - *Activa **Long Paths** en Windows 10/11. Esencial para Python/ComfyUI*
    - **ComfyUI-Version-Switcher** - *Permite volver de forma **reversible** a una versión **anterior** de ComfyUI si aparecen problemas*
    - **Toggle-DynamicVRAM** - *Activa/desactiva la opción **--disable-dynamic-vram** en los archivos de inicio de ComfyUI*
    - **Update Easy-Instalar** - *Actualiza **Add-ons** y otras carpetas. Crea accesos directos en el escritorio*
    - **EZi Desktop Themes** - *desde EZi Desktop > Menu > Advanced*
    - **Carpetas Input, Output y User personalizadas** - *desde EZi Desktop > Menu > Advanced*
    - **Cambiador de versiones de ComfyUI y frontend** - *desde EZi Desktop > Menu > Advanced*
    - **Limpiador de caché de UV y PIP** - *desde EZi Desktop > Menu*
    - **ComfyUI-Manager Security-Level Config** - *Configuración sencilla de security_level desde EZi Desktop > Menu*
    - **Pinned-Packages-Manager** - *Fija versiones de paquetes como NumPy==1.26.4 desde EZi Desktop > Menu*

<div align="center">

---

## ❤️ Apoyar el desarrollo

¿Te gusta el proyecto?  
Si te ahorra tiempo, tu apoyo ayuda a mantener el desarrollo y el mantenimiento.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/Tavris1?style=for-the-badge&logo=github)](https://github.com/sponsors/Tavris1)

</div>
