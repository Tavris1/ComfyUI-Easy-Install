<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<strong>한국어</strong> |
<a href="README.es.md#es">Español</a> |
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
    <strong>EZi Desktop을 포함한 원클릭 포터블 ComfyUI: 패키지, 환경 및 구성을 위한 완전한 대시보드</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)


<!--[![GitHub All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)-->
<!--[![GitHub Downloads Latest](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=⬇+latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)-->

  <p align="center">
    <a href="#%EF%B8%8F-windows-설치">📥 설치</a> &nbsp;·&nbsp;
    <a href="#-기능">✨ 기능/구성 요소</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#%EF%B8%8F-개발-지원">❤️ 개발 지원</a>
  </p>

<!-- Dedicated to the **Pixaroma** community  
[![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
-->

---

![ComfyUI Screenshot](ComfyUI-ivo.jpg)

</div>

## ✨ 기능

**ComfyUI-Easy-Install**은 **EZi Desktop**이 포함된 포터블 ComfyUI 환경을 제공합니다.  
Python이나 Git을 수동으로 설정할 필요가 없습니다.

Nunchaku, SageAttention, FlashAttention, InsightFace 및 Trellis 2.0과 같은 복잡한 패키지를 한 번의 클릭으로 설치할 수 있습니다.

한 곳에서 **모델, 패키지, PyTorch/CUDA 버전, Dynamic VRAM,  
ComfyUI/frontend 버전, UV/PIP 캐시 및 GGUF 변환**을 관리할 수 있습니다.

## 📦 포함된 구성 요소
<details open>
<summary><b>핵심 구성 요소</b></summary>

| 🔧 구성 요소 | 📝 설명 |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - 최신 버전(필요한 경우 설치/업데이트) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - Embedded 버전 |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - 최신 안정 버전 |

</details>

<details>
<summary><b>Pixaroma 튜토리얼에서 사용되는 Nodes</b></summary>

| 🖼️ 이미지 | 🎬 비디오 | 🎵 오디오 | 🧩 유틸리티 / WF | 🤖 모델 |
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
<summary><b>선택적 Add-ons 및 Tools</b></summary>

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

## 🖥️ Windows 설치

> [!IMPORTANT]
> - 설치 프로그램을 **Administrator**로 실행하지 마세요.
> - 시스템 폴더(`Program Files`, `Windows`, `C:\` 루트)를 피하세요.
> - 폴더 이름에 공백과 특수 문자를 사용하지 마세요.
> - NVIDIA 드라이버가 최신 상태인지 확인하세요.

1. [**📥 DOWNLOAD LATEST VERSION**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. ZIP 파일을 새 폴더에 압축 해제하고 **`ComfyUI-Easy-Install.bat`**을 실행하세요.
3. 설정 후 선택적으로 **Add-ons** 폴더 또는 **EZi Desktop Menu**에서 구성 요소를 설치하거나 실행할 수 있습니다:
    - **Easy-Models-Linker** - ***extra_model_paths.yaml**을 통해 기존 **MODELS** 폴더를 사용하므로 다시 다운로드할 필요가 없음*
      - ***LLM** 및 **llm_gguf**와 같은 일부 폴더는 이 방법으로 리디렉션할 수 없음*
    - **Easy-System-Checker** - *주요 하드웨어 및 소프트웨어 구성 요소에 대한 정보를 제공*
    - **Nunchaku** - *Nunchaku 설치*
    - **SageAttention-Multi** - *SageAttention v2.2.0 및 v3 모두 설치(v3는 NVIDIA 50-series GPUs에서만 효과적)*
    - **FlashAttention** - *FlashAttention v2.8.3 설치*
    - **InsightFace** - *InsightFace 설치(사전 학습된 모델은 비상업적 연구용으로만 사용 가능)*
    - **Trellis2** - *Trellis 2.0 및 모델 설치(`Add-ons/Torch-Pack`의 `Torch 2.8.0+cu128` 필요)*
    - **Torch-Pack** - *다음 버전을 빠르게 전환: `Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`,  
      `Torch 2.9.1+cu130`, `Torch 2.10+cu130`, `Torch 2.11+cu130`, `Torch 2.12.1+cu130` & `Torch 2.13.0+cu130`*
    - **Easy-model2GGUF** - *모델을 GGUF(Q2_K–Q8_0)로 변환 및 양자화하고, 가능한 경우 5D tensor 수정 적용*
    - **Long-Paths-Enabler** - *Windows 10/11에서 **Long Paths**를 활성화. Python/ComfyUI에 필수적*
    - **ComfyUI-Version-Switcher** - *문제가 발생할 경우 **이전** ComfyUI 버전으로 **되돌릴 수 있는** 롤백*
    - **Toggle-DynamicVRAM** - *ComfyUI 시작 파일에서 **--disable-dynamic-vram** 옵션 전환*
    - **Update Easy-Install** - ***Add-ons** 및 기타 폴더 업데이트. 바탕 화면 바로 가기 생성*
    - **EZi Desktop Themes** - *EZi Desktop > Menu > Advanced를 통해*
    - **Custom Input, Output & User folders** - *EZi Desktop > Menu > Advanced를 통해*
    - **ComfyUI & Frontend Version Changer** - *EZi Desktop > Menu > Advanced를 통해*
    - **UV & PIP cache cleaner** - *EZi Desktop > Menu를 통해*
    - **ComfyUI-Manager Security-Level Config** - *EZi Desktop > Menu를 통해 security_level을 쉽게 구성*
    - **Pinned-Packages-Manager** - *EZi Desktop > Menu를 통해 NumPy==1.26.4와 같은 패키지 버전 고정*

<div align="center">

---

## ❤️ 개발 지원

프로젝트가 마음에 드시나요?  
이 프로젝트가 시간을 절약해 주었다면, 여러분의 지원은 개발과 유지 관리를 계속하는 데 도움이 됩니다.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
