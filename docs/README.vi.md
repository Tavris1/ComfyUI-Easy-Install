<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<a href="README.ru.md#ru">Русский</a> |
<a href="README.de.md#de">Deutsch</a> |
<a href="README.fr.md#fr">Français</a> |
<strong>Tiếng Việt</strong>
</p>

---

# ComfyUI-Easy-Install
> **ComfyUI** portable chỉ với một cú nhấp cho **Windows** 🔹 GPU Nvidia 🔹 Phiên bản Cộng đồng Pixaroma 🔹  
> [![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
> [![GitHun Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
> [![Github All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)]()
> [![GitHub Downloads latest)](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=downloads%40latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
>
> Dành tặng đội ngũ **Pixaroma**  
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Join%20Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_presence_count&logo=discord&logoColor=white&label=Online&color=blue&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)

---

## Thành phần bao gồm:  
- **Git** *(sẽ được cài đặt hoặc cập nhật nếu cần)*  
- **ComfyUI portable**  
- **Python 3.12.10** *(phiên bản portable tích hợp)*  

### Các node từ tutorial Pixaroma trên [YouTube](https://www.youtube.com/@pixaroma)

|||||||
|---|---|---|---|---|---|
ComfyUI Manager | Tiled Diffusion & VAE | SCAIL-Pose | KJNodes | rgthree | iTools
MelBandRoFormer | Inpaint-CropAndStitch | Qwen3-TTS | Easy-Use | QwenVL | GGUF
VideoHelperSuite | SeedVR2_VideoUpscaler | ControlNet Aux | LayerStyle | Easy-Sam3 | RMBG
WanVideoWrapper | WanAnimatePreprocess | Comfyroll Studio

### Node bổ sung tùy chọn
||||||
|---|---|---|---|---|
Nunchaku | SageAttention-Multi (v2.2.0 and v3) | FlashAttention | Trellis 2.0 | InsightFace

### Công cụ bổ sung
||||||
|---|---|---|---|---|
Easy-Models-Linker | Torch-Pack | Easy-model2GGUF | Long-Paths-Enabler | ComfyUI-Version-Switcher

---

## Cài đặt trên Windows
1. Tải [:arrow_forward:**phiên bản mới nhất TẠI ĐÂY**◀️](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Giải nén file ZIP vào một thư mục mới và chạy **`ComfyUI-Easy-Install.bat`** để bắt đầu cài đặt
3. Sau khi cài đặt xong, bạn có thể tùy chọn cài đặt hoặc chạy các thành phần sau từ thư mục **Add-ons**:
    - **Easy-Models-Linker** - *Sử dụng thư mục **MODELS** hiện có thông qua **extra_model_paths.yaml**, không cần tải lại*
      - *Một số thư mục như **LLM** và **llm_gguf** không thể chuyển hướng theo cách này*
    - **Nunchaku** - *Cài đặt Nunchaku. Chạy lại `Nunchaku.bat` nếu gặp sự cố sau này*
    - **SageAttention-Multi** - *Cài đặt SageAttention v2.2.0 và v3 (v3 chỉ hoạt động trên GPU NVIDIA dòng 50)*
    - **FlashAttention** - *Cài đặt FlashAttention v2.8.3*
    - **InsightFace** - *Cài đặt InsightFace (mô hình huấn luyện sẵn chỉ dành cho nghiên cứu phi thương mại)*
    - **Trellis2** - *Cài đặt Trellis 2.0 và mô hình (yêu cầu `Torch 2.8.0+cu128` từ `Add-ons/Torch-Pack`)*
    - **Torch-Pack** - *Chuyển đổi nhanh giữa:*
      - ***Torch 2.7.1+cu128***
      - ***Torch 2.8.0+cu128***
      - ***Torch 2.9.1+cu130** (mặc định, yêu cầu driver NVIDIA v580+)*  
    - **Easy-model2GGUF** *(**Add-Ons/Tools**)*  
      - *Chuyển đổi mô hình (`.safetensors`, `.pth`, `.pt`) sang định dạng **GGUF** (FP16 hoặc BF16) trong vài phút*  
      - *Lượng tử hóa mô hình từ **Q2_K** đến **Q8_0** và áp dụng **5D tensor fixes** nếu có*  
    - **Long-Paths-Enabler** *(`Add-Ons/Tools`)* - *Kích hoạt **Long Paths** trên Windows 10/11. Rất cần thiết cho Python/ComfyUI*  
    - **ComfyUI-Version-Switcher** *(`Add-Ons/Tools`)* - ***Hoàn tác có thể đảo ngược** về phiên bản **cũ hơn** của ComfyUI nếu gặp sự cố*  
    - **Toggle-DynamicVRAM** *(`Add-Ons/Tools`)* - *Bật hoặc tắt tùy chọn **--disable-dynamic-vram** trong các tệp khởi động của ComfyUI*  
    - **Update Easy-Install.bat** *(thư mục chính)* - *Cập nhật **Add-ons** và các thư mục khác. Tạo shortcut trên Desktop*  

> [!IMPORTANT]
> - Không chạy trình cài đặt dưới quyền **Administrator**.
> - Tránh các thư mục hệ thống (`Program Files`, `Windows`, thư mục gốc `C:\`).
> - Tránh dấu cách và ký tự đặc biệt trong tên thư mục.
> - Đảm bảo driver NVIDIA của bạn được cập nhật.

> [!TIP]
> - Có thể cài đặt nhiều bản ComfyUI mà không xung đột.
> - Bạn có thể đổi tên hoặc di chuyển thư mục `ComfyUI-Easy-Install` sau khi cài đặt.
> - Đối với macOS / Linux nhấn [here](https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux)

---

<img width="1038" height="240" alt="123321" src="https://github.com/user-attachments/assets/6d0655ef-8724-4cb1-bce2-a29fc9004173" />

---

Nếu bạn thích các dự án của tôi, vui lòng cân nhắc ủng hộ. Mọi sự hỗ trợ đều rất đáng trân trọng!

💜 PayPal: https://paypal.me/tavris1  
☕ Buy Me a Coffee: https://buymeacoffee.com/tavris1  
❤️ GitHub Sponsors: https://github.com/sponsors/Tavris1  