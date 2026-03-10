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

# ComfyUI-Easy-Install
원클릭 포터블 **ComfyUI** 설치기, **Windows**용 🔹 Nvidia GPU 지원  
[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![GitHub All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![GitHub Downloads Latest](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=⬇+latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)

**Pixaroma** 팀에 헌정  
[![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Join%20Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)

![ComfyUI Screenshot](ComfyUI-ivo.jpg)

ComfyUI-Easy-Install은 완전히 구성된 **원클릭 포터블 ComfyUI**입니다. Python 설치나 수동 의존성 설정이 필요하지 않습니다.

</div>

## 📦 포함된 구성요소
<details>
<summary><b>핵심 구성요소</b></summary>

| 🔧 구성요소 | 📝 설명 |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - 최신 (필요시 설치/업데이트) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - 내장 버전 |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - 최신 버전 |

</details>

<details>
<summary><b>Pixaroma 튜토리얼 노드</b></summary>

| 🖼️ 이미지 | 🎬 비디오 | 🎵 오디오 | 🧩 유틸리티 / WF | 🤖 모델 |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [WanVideoWrapper](https://github.com/kijai/ComfyUI-WanVideoWrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | | [KJNodes](https://github.com/kijai/ComfyUI-KJNodes) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SeedVR2 VideoUpscaler](https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | | | [iTools](https://github.com/MohammadAboulEla/ComfyUI-iTools) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI Nodes](https://github.com/gseth/ControlAltAI-Nodes) | |
| [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | | | |

</details>

<details>
<summary><b>선택적 추가 노드 및 도구</b></summary>

| 🧩 노드 | 🛠️ 도구 |
|---|---|
| [Nunchaku](https://github.com/nunchaku-ai/nunchaku) | Easy-Models-Linker |
| [SageAttention (v2.2.0 및 v3)](https://github.com/woct0rdho/SageAttention) | ComfyUI-Version-Switcher |
| [FlashAttention](https://github.com/Dao-AILab/flash-attention) | Easy-model2GGUF |
| [InsightFace](https://github.com/deepinsight/insightface) | Long-Paths-Enabler |
| [Trellis 2.0](https://github.com/visualbruno/ComfyUI-Trellis2) | Torch-Pack |
| | Toggle-DynamicVRAM |
| | Update Easy-Install |

</details>

---

## 🖥️ Windows 설치
1. [**ComfyUI-Easy-Install 다운로드**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. ZIP 파일을 새 폴더에 압축 해제 후 **`ComfyUI-Easy-Install.bat`** 실행
3. 설치 후 **Add-ons** 폴더에서 다음 구성요소 설치/실행 가능:
    - **Easy-Models-Linker** - *기존 **MODELS** 폴더를 **extra_model_paths.yaml** 통해 사용, 재다운로드 불필요*
      - ***LLM** 및 **llm_gguf** 폴더는 이 방법으로 리디렉션 불가*
    - **Nunchaku** - *Nunchaku 설치 (문제가 발생하면 `Nunchaku.bat` 재실행)*
    - **SageAttention-Multi** - *SageAttention v2.2.0과 v3 설치 (v3은 NVIDIA 50 시리즈 GPU에서만 적용)*
    - **FlashAttention** - *FlashAttention v2.8.3 설치*
    - **InsightFace** - *InsightFace 설치 (비상업 연구용 사전 학습 모델만)*
    - **Trellis2** - *Trellis 2.0 및 모델 설치 (`Add-ons/Torch-Pack` 의 `Torch 2.8.0+cu128` 필요)*
    - **Torch-Pack** - *`Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`, `Torch 2.9.1+cu130` 간 빠른 전환*
    - **Easy-model2GGUF** - *모델을 GGUF로 변환 및 양자화 (Q2_K–Q8_0), 가능 시 5D 텐서 수정 적용*
    - **Long-Paths-Enabler** - *Windows 10/11에서 **Long Paths** 활성화, Python/ComfyUI 필수*
    - **ComfyUI-Version-Switcher** - ***이전 버전**으로 롤백 가능*
    - **Toggle-DynamicVRAM** - *ComfyUI 시작 파일의 **--disable-dynamic-vram** 옵션 전환*
    - **Update Easy-Install** - *Add-ons 및 다른 폴더 업데이트, 바탕화면 바로가기 생성*
> [!IMPORTANT]
> - 설치 프로그램을 **관리자 권한으로 실행 금지**.
> - 시스템 폴더 (`Program Files`, `Windows`, `C:\` 루트) 피하기.
> - 폴더 이름에 공백 또는 특수문자 사용 금지.
> - NVIDIA 드라이버 최신 버전 확인.

> [!TIP]
> - 다중 ComfyUI 설치 가능, 충돌 없음.
> - 설치 후 `ComfyUI-Easy-Install` 폴더 이름 변경/이동 가능.
> - [**macOS / Linux 사용자는 여기 클릭**](https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux)


<div align="center">

## ❤️ 지원

프로젝트가 마음에 드신다면, 후원해주시면 감사드립니다!

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)


</div>
