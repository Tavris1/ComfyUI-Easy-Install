<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<strong>한국어</strong> |
<a href="README.es.md#es">Español</a> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<a href="README.ru.md#ru">Русский</a> |
<a href="README.de.md#de">Deutsch</a> |
<a href="README.fr.md#fr">Français</a> |
<a href="README.vi.md#vi">Tiếng Việt</a>
</p>

---

# ComfyUI-Easy-Install
> **ComfyUI** 원클릭 포터블 버전 **Windows**용 🔹 Nvidia GPU 🔹 Pixaroma 커뮤니티 에디션 🔹  
> [![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
> [![GitHun Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
> [![Github All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)]()
> [![GitHub Downloads latest)](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=downloads%40latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
>
> **Pixaroma** 팀에 헌정  
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Join%20Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_presence_count&logo=discord&logoColor=white&label=Online&color=blue&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)

---

## 포함된 구성 요소:  
- **Git** *(필요한 경우 자동으로 설치 또는 업데이트됩니다)*  
- **ComfyUI portable**  
- **Python 3.12.10** *(내장 포터블 버전)*  

### Pixaroma 튜토리얼에서 사용되는 노드 [YouTube](https://www.youtube.com/@pixaroma)

||||||
|---|---|---|---|---|
ComfyUI Manager | Tiled Diffusion & VAE | LayerStyle | rgthree | GGUF
VideoHelperSuite | Inpaint-CropAndStitch | SCAIL-Pose | KJNodes | iTools
Comfyroll Studio | SeedVR2_VideoUpscaler | ControlNet Aux | Easy-Use | RMBG
WanVideoWrapper | WanAnimatePreprocess | MelBandRoFormer | Easy-Sam3 | QwenVL
Qwen3-TTS

### 선택적 추가 노드
||||||
|---|---|---|---|---|
Nunchaku | SageAttention-Multi (v2.2.0 and v3) | FlashAttention | Trellis 2.0 | InsightFace

### 추가 도구
||||||
|---|---|---|---|---|
Easy-Models-Linker | Torch-Pack | Easy-model2GGUF | Long-Paths-Enabler | ComfyUI-Version-Switcher

---

## Windows 설치
1. [:arrow_forward:**최신 버전 다운로드 HERE**◀️](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. ZIP 파일을 새 폴더에 압축 해제하고 **`ComfyUI-Easy-Install.bat`** 을 실행하여 설치를 시작합니다
3. 설치 후 **Add-ons** 폴더에서 다음 구성 요소를 선택적으로 설치하거나 실행할 수 있습니다:
    - **Easy-Models-Linker** - ***extra_model_paths.yaml** 을 사용하여 기존 **MODELS** 폴더를 활용하며 재다운로드가 필요하지 않습니다*
      - *일부 폴더 (**LLM** 및 **llm_gguf**) 는 이 방법으로 리디렉션할 수 없습니다*
    - **Nunchaku** - *Nunchaku를 설치합니다. 이후 문제가 발생하면 `Nunchaku.bat` 을 다시 실행하십시오*
    - **SageAttention-Multi** - *SageAttention v2.2.0 및 v3를 설치합니다 (v3는 NVIDIA 50 시리즈 GPU에서만 적용됨)*
    - **FlashAttention** - *FlashAttention v2.8.3을 설치합니다*
    - **InsightFace** - *InsightFace를 설치합니다 (사전 학습 모델은 비상업적 연구 목적에 한함)*
    - **Trellis2** - *Trellis 2.0 및 모델을 설치합니다 (`Add-ons/Torch-Pack` 의 `Torch 2.8.0+cu128` 필요)*
    - **Torch-Pack** - *다음 버전 간 빠른 전환:*
      - ***Torch 2.7.1+cu128***
      - ***Torch 2.8.0+cu128***
      - ***Torch 2.9.1+cu130** (기본값, NVIDIA 드라이버 v580+ 필요)*  
    - **Easy-model2GGUF** *(**Add-Ons/Tools**)*  
      - *모델 (`.safetensors`, `.pth`, `.pt`) 을 몇 분 안에 **GGUF** 형식 (FP16 또는 BF16) 으로 변환합니다*  
      - ***Q2_K** 부터 **Q8_0** 까지 양자화 옵션을 지원하며 가능한 경우 **5D tensor 수정** 을 적용합니다*  
    - **Long-Paths-Enabler** *(`Add-Ons/Tools`)* - *Windows 10/11에서 **Long Paths** 를 활성화합니다. Python/ComfyUI에 필수적입니다*  
    - **ComfyUI-Version-Switcher** *(`Add-Ons/Tools`)* - ***이전** ComfyUI 버전으로 **되돌리기 가능** 합니다*  
    - **Update Easy-Install.bat** *(메인 폴더)* - ***Add-ons** 및 기타 폴더를 업데이트하고 바탕화면 바로가기를 생성합니다*  

> [!IMPORTANT]
> - 설치 프로그램을 **관리자 권한으로** 실행하지 마십시오.
> - 시스템 폴더 (`Program Files`, `Windows`, `C:\` 루트) 를 피하십시오.
> - 폴더 이름에 공백이나 특수 문자를 사용하지 마십시오.
> - NVIDIA 드라이버가 최신 버전인지 확인하십시오.

> [!TIP]
> - 여러 개의 ComfyUI 설치가 충돌 없이 가능합니다.
> - 설치 후 `ComfyUI-Easy-Install` 폴더의 이름 변경이나 이동이 가능합니다.
> - macOS / Linux 의 경우 [here](https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux) 를 클릭하십시오.

---

<img width="1038" height="240" alt="123321" src="https://github.com/user-attachments/assets/6d0655ef-8724-4cb1-bce2-a29fc9004173" />

---

제 프로젝트가 마음에 드셨다면 후원을 고려해 주세요. 어떤 지원이든 진심으로 감사드립니다.

💜 PayPal: https://paypal.me/tavris1  
☕ Buy Me a Coffee: https://buymeacoffee.com/tavris1  
❤️ GitHub Sponsors: https://github.com/sponsors/Tavris1  