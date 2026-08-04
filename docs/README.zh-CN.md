<a id="zh-cn"></a>

<p align="center">
🌍 
<a href="../README.md#english">English</a> |
<strong>简体中文</strong> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
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
  <h1>ComfyUI-Easy-安装</h1>
  <p align="center">
    <strong>使用 EZi Desktop 一键安装便携版 ComfyUI</strong><br />
    Windows • NVIDIA GPU • Pixaroma 社区版
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/Tavris1/ComfyUI-Easy-Install/Windows/.github/badges/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

  <p align="center">
    <a href="#%EF%B8%8F-windows-installation">📥 安装</a> &nbsp;·&nbsp;
    <a href="#-features">✨ 功能/组件</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-安装/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#%EF%B8%8F-support-development">❤️ 支持开发</a>
  </p>

---

![ComfyUI Screenshot](docs/ComfyUI-ivo.jpg)

</div>

## ✨ 功能

****ComfyUI-Easy-安装** 通过 **EZi Desktop** 提供便携式 ComfyUI 环境。  
无需手动配置 Python 或 Git。

一键安装 Nunchaku、SageAttention、FlashAttention、InsightFace 和 Trellis 2.0 等复杂软件包。

在一个地方管理**模型、软件包、PyTorch/CUDA 版本、Dynamic VRAM、ComfyUI/前端版本、UV/PIP 缓存以及 GGUF 转换**。

## 📦 包含的组件
<details open>
<summary><b>核心组件</b></summary>

| 🔧 组件 | 📝 说明 |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - 最新版本（需要时会自动安装/更新） |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - 内置版本 |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - 最新稳定版本 |

</details>

<details>
<summary><b>Pixaroma 教程中使用的节点</b></summary>

| 🖼️ 图像 | 🎬 视频 | 🎵 音频 | 🧩 工具 / 工作流 | 🤖 模型 |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [视频HelperSuite](https://github.com/Kosinkadink/ComfyUI-视频HelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [Wan视频Wrapper](https://github.com/kijai/ComfyUI-Wan视频Wrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | [Fish音频S2](https://github.com/Saganaki22/ComfyUI-Fish音频S2) | [KJ节点](https://github.com/kijai/ComfyUI-KJ节点) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SeedVR2 视频Upscaler](https://github.com/numz/ComfyUI-SeedVR2_视频Upscaler) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | | | [i工具](https://github.com/MohammadAboulEla/ComfyUI-i工具) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI 节点](https://github.com/gseth/ControlAltAI-节点) | |
| [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | | ✨[Pixaroma](https://github.com/pixaroma/ComfyUI-Pixaroma) | |
| | | | [Krea2T-Enhancer](https://github.com/capitan01R/ComfyUI-Krea2T-Enhancer) | |
| | | | [Krea2Edit](https://github.com/lbouaraba/comfyui-krea2edit) | |

</details>

<details>
<summary><b>可选插件和工具</b></summary>

| 🧩 节点 | 🛠️ 工具 |
|---|---|
| [Nunchaku](https://github.com/nunchaku-ai/nunchaku) | Easy-模型-Linker |
| [SageAttention (v2.2.0 and v3)](https://github.com/woct0rdho/SageAttention) | Easy-System-Checker |
| [FlashAttention](https://github.com/Dao-AILab/flash-attention) | ComfyUI-Version-Switcher |
| [InsightFace](https://github.com/deepinsight/insightface) | Easy-model2GGUF |
| [Trellis 2.0](https://github.com/visualbruno/ComfyUI-Trellis2) | Long-Paths-Enabler |
| | Torch-Pack |
| | Toggle-DynamicVRAM |
| | Update Easy-安装 |

</details>

---

## 🖥️ Windows 安装

> [!IMPORTANT]
> - 请勿以**管理员身份**运行安装程序。
> - 避免使用系统文件夹（`Program Files`、`Windows`、`C:\` 根目录）。
> - 避免在文件夹名称中使用空格和特殊字符。
> - 请确保 NVIDIA 驱动程序已更新到最新版本。

1. [**📥 下载最新版本**](https://github.com/Tavris1/ComfyUI-Easy-安装/releases/latest/download/ComfyUI-Easy-安装.zip)
2. 将 ZIP 文件解压到新文件夹，然后运行 **`ComfyUI-Easy-安装.bat`**
3. 安装完成后，可选择从 **Add-ons** 文件夹或 **EZi Desktop Menu** 安装/运行组件：
    - **Easy-模型-Linker** - *通过 **extra_model_paths.yaml** 使用现有的 **MODELS** 文件夹，无需重新下载*
      - ***LLM** 和 **llm_gguf** 等部分文件夹无法通过此方式重定向*
    - **Easy-System-Checker** - *提供关键硬件和软件组件的信息*
    - **Nunchaku** - *安装 Nunchaku。（之后如果出现问题，请再次运行 `Nunchaku.bat`）*
    - **SageAttention-Multi** - *同时安装 SageAttention v2.2.0 和 v3（v3 仅在 NVIDIA 50 系列 GPU 上生效）*
    - **FlashAttention** - *安装 FlashAttention v2.8.3*
    - **InsightFace** - *安装 InsightFace（预训练模型仅限非商业研究使用）*
    - **Trellis2** - *安装 Trellis 2.0 及其模型（需要 `Add-ons/Torch-Pack` 中的 `Torch 2.8.0+cu128`）*
    - **Torch-Pack** - *快速切换以下版本：*  
      - *`Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`, `Torch 2.9.1+cu130`, `Torch 2.10+cu130` & `Torch 2.11+cu130`*
    - **Easy-model2GGUF** - *将模型转换并量化为 GGUF（Q2_K–Q8_0），并在可用时修复 5D 张量问题*
    - **Long-Paths-Enabler** - *在 Windows 10/11 中启用**长路径**。Python/ComfyUI 必需*
    - **ComfyUI-Version-Switcher** - *出现问题时可**可逆地**回滚到**之前的** ComfyUI 版本*
    - **Toggle-DynamicVRAM** - *切换 ComfyUI 启动文件中的 **--disable-dynamic-vram** 选项*
    - **Update Easy-安装** - *更新 **Add-ons** 和其他文件夹，并创建桌面快捷方式*
    - **EZi Desktop Themes** - *通过 EZi Desktop > Menu > Advanced*
    - **自定义 Input、Output 和 User 文件夹** - *通过 EZi Desktop > Menu > Advanced*
    - **ComfyUI 和前端版本切换器** - *通过 EZi Desktop > Menu > Advanced*
    - **UV 和 PIP 缓存清理器** - *通过 EZi Desktop > Menu*
    - **ComfyUI-Manager Security-Level Config** - *通过 EZi Desktop > Menu 轻松配置 security_level*
    - **Pinned-Packages-Manager** - *通过 EZi Desktop > Menu 固定软件包版本，例如 NumPy==1.26.4*

<div align="center">

---

## ❤️ 支持开发

喜欢这个项目吗？  
如果它为你节省了时间，你的支持将帮助项目持续开发和维护。

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/Tavris1?style=for-the-badge&logo=github)](https://github.com/sponsors/Tavris1)

</div>
