<a id="vi"></a>

<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<a href="README.de.md#de">Deutsch</a> |
<a href="README.fr.md#fr">Français</a> |
<a href="README.ru.md#ru">Русский</a> |
<a href="README.tr.md#tr">Türkçe</a> |
<strong>Tiếng Việt</strong>
</p>

---

<div align="center">
  <img src="EZi-Logo.svg" width="120" alt="EZi Logo">
  <h1>ComfyUI-Easy-Install</h1>
  <p align="center">
    <strong>ComfyUI Portable một cú nhấp với EZi Desktop</strong><br />
    Windows • GPU NVIDIA • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/Tavris1/ComfyUI-Easy-Install/Windows/.github/badges/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

  <p align="center">
    <a href="#windows-installation">📥 Cài đặt</a> &nbsp;·&nbsp;
    <a href="#features">✨ Tính năng/Thành phần</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#support-development">❤️ Ủng hộ phát triển</a>
  </p>

<!-- Dedicated to the **Pixaroma** community  
[![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
-->

<!--[![GitHub All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)-->
<!--[![GitHub Downloads Latest](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=⬇+latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)-->

---

![ComfyUI Screenshot](ComfyUI-ivo.jpg)

</div>

<a id="features"></a>

## ✨ Tính năng

****ComfyUI-Easy-Install** cung cấp môi trường ComfyUI portable cùng **EZi Desktop**.  
Không cần thiết lập Python hoặc Git thủ công.

Cài đặt các gói phức tạp như Nunchaku, SageAttention, FlashAttention, InsightFace và Trellis 2.0 chỉ bằng một cú nhấp.

Quản lý **model, package, phiên bản PyTorch/CUDA, Dynamic VRAM, phiên bản ComfyUI/frontend, bộ nhớ đệm UV/PIP và chuyển đổi GGUF** tại một nơi.

## 📦 Thành phần đi kèm
<details open>
<summary><b>Thành phần cốt lõi</b></summary>

| 🔧 Thành phần | 📝 Ghi chú |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - Mới nhất (sẽ cài/cập nhật khi cần) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - Phiên bản tích hợp |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - Phiên bản ổn định mới nhất |

</details>

<details>
<summary><b>Node được sử dụng trong hướng dẫn Pixaroma</b></summary>

| 🖼️ Hình ảnh | 🎬 Video | 🎵 Âm thanh | 🧩 Tiện ích / WF | 🤖 Model |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [WanVideoWrapper](https://github.com/kijai/ComfyUI-WanVideoWrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | [FishÂm thanhS2](https://github.com/Saganaki22/ComfyUI-FishÂm thanhS2) | [KJNode](https://github.com/kijai/ComfyUI-KJNode) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SeedVR2 VideoUpscaler](https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | | | [iCông cụ](https://github.com/MohammadAboulEla/ComfyUI-iCông cụ) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI Node](https://github.com/gseth/ControlAltAI-Node) | |
| [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | | ✨[Pixaroma](https://github.com/pixaroma/ComfyUI-Pixaroma) | |
| | | | [Krea2T-Enhancer](https://github.com/capitan01R/ComfyUI-Krea2T-Enhancer) | |
| | | | [Krea2Edit](https://github.com/lbouaraba/comfyui-krea2edit) | |

</details>

<details>
<summary><b>Add-on & công cụ tùy chọn</b></summary>

| 🧩 Node | 🛠️ Công cụ |
|---|---|
| [Nunchaku](https://github.com/nunchaku-ai/nunchaku) | Easy-Model-Linker |
| [SageAttention (v2.2.0 and v3)](https://github.com/woct0rdho/SageAttention) | Easy-System-Checker |
| [FlashAttention](https://github.com/Dao-AILab/flash-attention) | ComfyUI-Version-Switcher |
| [InsightFace](https://github.com/deepinsight/insightface) | Easy-model2GGUF |
| [Trellis 2.0](https://github.com/visualbruno/ComfyUI-Trellis2) | Long-Paths-Enabler |
| | Torch-Pack |
| | Toggle-DynamicVRAM |
| | Update Easy-Cài đặt |

</details>

---

<a id="windows-installation"></a>

## 🖥️ Cài đặt Windows

> [!IMPORTANT]
> - Không chạy trình cài đặt với quyền **Administrator**.
> - Tránh các thư mục hệ thống (`Program Files`, `Windows`, thư mục gốc `C:\`).
> - Tránh khoảng trắng và ký tự đặc biệt trong tên thư mục.
> - Đảm bảo driver NVIDIA đã được cập nhật.

1. [**📥 TẢI PHIÊN BẢN MỚI NHẤT**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Giải nén ZIP vào một thư mục mới và chạy **`ComfyUI-Easy-Install.bat`**
3. Sau khi thiết lập, bạn có thể cài đặt hoặc chạy các thành phần từ thư mục **Add-ons** hoặc **EZi Desktop Menu**:
    - **Easy-Model-Linker** - *Sử dụng thư mục **MODELS** hiện có thông qua **extra_model_paths.yaml**, không cần tải lại*
      - *Một số thư mục như **LLM** và **llm_gguf** không thể chuyển hướng theo cách này*
    - **Easy-System-Checker** - *Cung cấp thông tin về các thành phần phần cứng và phần mềm chính*
    - **Nunchaku** - *Cài đặt Nunchaku. (Chạy lại `Nunchaku.bat` nếu sau này gặp lỗi)*
    - **SageAttention-Multi** - *Cài đặt cả SageAttention v2.2.0 và v3 (v3 chỉ hoạt động trên GPU NVIDIA dòng 50)*
    - **FlashAttention** - *Cài đặt FlashAttention v2.8.3*
    - **InsightFace** - *Cài đặt InsightFace (model được huấn luyện sẵn chỉ dành cho nghiên cứu phi thương mại)*
    - **Trellis2** - *Cài đặt Trellis 2.0 và model (yêu cầu `Torch 2.8.0+cu128` từ `Add-ons/Torch-Pack`)*
    - **Torch-Pack** - *Chuyển nhanh giữa:*  
      - *`Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`, `Torch 2.9.1+cu130`, `Torch 2.10+cu130` & `Torch 2.11+cu130`*
    - **Easy-model2GGUF** - *Chuyển đổi và lượng tử hóa model sang GGUF (Q2_K–Q8_0), sửa tensor 5D nếu có thể*
    - **Long-Paths-Enabler** - *Bật **Long Paths** trên Windows 10/11. Cần thiết cho Python/ComfyUI*
    - **ComfyUI-Version-Switcher** - *Cho phép quay lại **phiên bản ComfyUI trước đó** theo cách **có thể hoàn tác** khi gặp sự cố*
    - **Toggle-DynamicVRAM** - *Bật/tắt tùy chọn **--disable-dynamic-vram** trong file khởi động ComfyUI*
    - **Update Easy-Cài đặt** - *Cập nhật **Add-ons** và các thư mục khác. Tạo shortcut trên desktop*
    - **EZi Desktop Themes** - *thông qua EZi Desktop > Menu > Advanced*
    - **Thư mục Input, Output & User tùy chỉnh** - *thông qua EZi Desktop > Menu > Advanced*
    - **Trình đổi phiên bản ComfyUI & frontend** - *thông qua EZi Desktop > Menu > Advanced*
    - **Trình dọn cache UV & PIP** - *thông qua EZi Desktop > Menu*
    - **ComfyUI-Manager Security-Level Config** - *Dễ dàng cấu hình security_level qua EZi Desktop > Menu*
    - **Pinned-Packages-Manager** - *Cố định phiên bản package như NumPy==1.26.4 qua EZi Desktop > Menu*

<div align="center">

---

<a id="support-development"></a>

## ❤️ Ủng hộ phát triển

Bạn thích dự án này?  
Nếu dự án giúp bạn tiết kiệm thời gian, sự ủng hộ của bạn giúp duy trì việc phát triển và bảo trì.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
