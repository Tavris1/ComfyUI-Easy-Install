<a id="ko"></a>

<p align="center">
🌍 
<a href="../README.md#english">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<strong>한국어</strong> |
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
  <h1>ComfyUI-Easy-설치</h1>
  <p align="center">
    <strong>EZi Desktop으로 원클릭 포터블 ComfyUI</strong><br />
    Windows • NVIDIA GPU • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/Tavris1/ComfyUI-Easy-Install/Windows/.github/badges/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

  <p align="center">
    <a href="#%EF%B8%8F-windows-installation">📥 설치</a> &nbsp;·&nbsp;
    <a href="#-features">✨ 기능/구성 요소</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-설치/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#%EF%B8%8F-support-development">❤️ 개발 지원</a>
  </p>

---

![ComfyUI Screenshot](docs/ComfyUI-ivo.jpg)

</div>

## ✨ 기능

****ComfyUI-Easy-설치**은 **EZi Desktop**과 함께 포터블 ComfyUI 환경을 제공합니다.  
Python 또는 Git을 수동으로 설정할 필요가 없습니다.

Nunchaku, SageAttention, FlashAttention, InsightFace, Trellis 2.0 같은 복잡한 패키지를 한 번의 클릭으로 설치할 수 있습니다.

**모델, 패키지, PyTorch/CUDA 버전, Dynamic VRAM, ComfyUI/프런트엔드 버전, UV/PIP 캐시, GGUF 변환**을 한 곳에서 관리할 수 있습니다.

## 📦 포함된 구성 요소
<details open>
<summary><b>핵심 구성 요소</b></summary>

| 🔧 구성 요소 | 📝 설명 |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - 최신 버전 (필요하면 설치/업데이트) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - 내장 버전 |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - 최신 안정 버전 |

</details>

<details>
<summary><b>Pixaroma 튜토리얼에서 사용하는 노드</b></summary>

| 🖼️ 이미지 | 🎬 비디오 | 🎵 오디오 | 🧩 유틸리티 / WF | 🤖 모델 |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [비디오HelperSuite](https://github.com/Kosinkadink/ComfyUI-비디오HelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [Wan비디오Wrapper](https://github.com/kijai/ComfyUI-Wan비디오Wrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | [Fish오디오S2](https://github.com/Saganaki22/ComfyUI-Fish오디오S2) | [KJ노드](https://github.com/kijai/ComfyUI-KJ노드) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SeedVR2 비디오Upscaler](https://github.com/numz/ComfyUI-SeedVR2_비디오Upscaler) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | | | [i도구](https://github.com/MohammadAboulEla/ComfyUI-i도구) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI 노드](https://github.com/gseth/ControlAltAI-노드) | |
| [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | | ✨[Pixaroma](https://github.com/pixaroma/ComfyUI-Pixaroma) | |
| | | | [Krea2T-Enhancer](https://github.com/capitan01R/ComfyUI-Krea2T-Enhancer) | |
| | | | [Krea2Edit](https://github.com/lbouaraba/comfyui-krea2edit) | |

</details>

<details>
<summary><b>선택적 애드온 및 도구</b></summary>

| 🧩 노드 | 🛠️ 도구 |
|---|---|
| [Nunchaku](https://github.com/nunchaku-ai/nunchaku) | Easy-모델-Linker |
| [SageAttention (v2.2.0 and v3)](https://github.com/woct0rdho/SageAttention) | Easy-System-Checker |
| [FlashAttention](https://github.com/Dao-AILab/flash-attention) | ComfyUI-Version-Switcher |
| [InsightFace](https://github.com/deepinsight/insightface) | Easy-model2GGUF |
| [Trellis 2.0](https://github.com/visualbruno/ComfyUI-Trellis2) | Long-Paths-Enabler |
| | Torch-Pack |
| | Toggle-DynamicVRAM |
| | Update Easy-설치 |

</details>

---

## 🖥️ Windows 설치

> [!IMPORTANT]
> - 설치 프로그램을 **관리자** 권한으로 실행하지 마세요.
> - 시스템 폴더(`Program Files`, `Windows`, `C:\` 루트)는 피하세요.
> - 폴더 이름에 공백과 특수 문자를 사용하지 마세요.
> - NVIDIA 드라이버가 최신인지 확인하세요.

1. [**📥 최신 버전 다운로드**](https://github.com/Tavris1/ComfyUI-Easy-설치/releases/latest/download/ComfyUI-Easy-설치.zip)
2. ZIP 파일을 새 폴더에 압축 해제한 다음 **`ComfyUI-Easy-설치.bat`**을 실행하세요.
3. 설정 후 필요에 따라 **Add-ons** 폴더 또는 **EZi Desktop Menu**에서 구성 요소를 설치하거나 실행할 수 있습니다:
    - **Easy-모델-Linker** - ***extra_model_paths.yaml**을 통해 기존 **MODELS** 폴더를 사용하므로 다시 다운로드할 필요가 없습니다*
      - ***LLM**, **llm_gguf** 같은 일부 폴더는 이 방법으로 경로를 변경할 수 없습니다*
    - **Easy-System-Checker** - *주요 하드웨어 및 소프트웨어 구성 요소 정보를 제공합니다*
    - **Nunchaku** - *Nunchaku를 설치합니다. (나중에 문제가 발생하면 `Nunchaku.bat`을 다시 실행하세요)*
    - **SageAttention-Multi** - *SageAttention v2.2.0과 v3를 모두 설치합니다 (v3는 NVIDIA 50 시리즈 GPU에서만 적용)*
    - **FlashAttention** - *FlashAttention v2.8.3을 설치합니다*
    - **InsightFace** - *InsightFace를 설치합니다 (사전 학습 모델은 비상업적 연구 용도로만 사용 가능)*
    - **Trellis2** - *Trellis 2.0과 모델을 설치합니다 (`Add-ons/Torch-Pack`의 `Torch 2.8.0+cu128` 필요)*
    - **Torch-Pack** - *다음 버전 간 빠른 전환:*  
      - *`Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`, `Torch 2.9.1+cu130`, `Torch 2.10+cu130` & `Torch 2.11+cu130`*
    - **Easy-model2GGUF** - *모델을 GGUF(Q2_K–Q8_0)로 변환 및 양자화하고, 가능한 경우 5D 텐서를 수정합니다*
    - **Long-Paths-Enabler** - *Windows 10/11에서 **Long Paths**를 활성화합니다. Python/ComfyUI에 필수입니다*
    - **ComfyUI-Version-Switcher** - *문제가 발생하면 **이전** ComfyUI 버전으로 **되돌릴 수 있습니다***
    - **Toggle-DynamicVRAM** - *ComfyUI 시작 파일의 **--disable-dynamic-vram** 옵션을 전환합니다*
    - **Update Easy-설치** - ***Add-ons** 및 기타 폴더를 업데이트하고 바탕 화면 바로가기를 생성합니다*
    - **EZi Desktop Themes** - *EZi Desktop > Menu > Advanced에서*
    - **사용자 지정 Input, Output 및 User 폴더** - *EZi Desktop > Menu > Advanced에서*
    - **ComfyUI 및 프런트엔드 버전 변경** - *EZi Desktop > Menu > Advanced에서*
    - **UV 및 PIP 캐시 정리** - *EZi Desktop > Menu에서*
    - **ComfyUI-Manager Security-Level Config** - *EZi Desktop > Menu에서 security_level을 쉽게 설정*
    - **Pinned-Packages-Manager** - *EZi Desktop > Menu에서 NumPy==1.26.4 같은 패키지 버전을 고정*

<div align="center">

---

## ❤️ 개발 지원

프로젝트가 마음에 드셨나요?  
시간을 절약해 드렸다면, 여러분의 후원은 개발과 유지 관리에 큰 도움이 됩니다.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/Tavris1?style=for-the-badge&logo=github)](https://github.com/sponsors/Tavris1)

</div>
