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
    <strong>Cài đặt ComfyUI bản di động chỉ với một lần nhấp, rồi quản lý và tùy chỉnh trong EZi Desktop.</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

<p align="center">
  <a href="#install">📥 <strong>Cài đặt</strong></a> &nbsp;·&nbsp;
  <a href="#features">✨ Tính năng</a> &nbsp;·&nbsp;
  <a href="#requirements">💻 Yêu cầu hệ thống</a> &nbsp;·&nbsp;
  <a href="#help">🩺 Trợ giúp</a> &nbsp;·&nbsp;
  <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
  <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
  <a href="#support">❤️ Ủng hộ</a>
</p>

<br>

![ComfyUI Screenshot](ComfyUI-ivo.png)

**Mới dùng EZi?** [Làm quen với EZi qua truyện tranh](#comic)

</div>

<a id="features"></a>

## ✨ Tính năng

**ComfyUI-Easy-Install** cài ComfyUI bản di động với môi trường Python riêng, các nút sẵn dùng và **EZi Desktop**.

- **Một lần nhấp** - Tự động cấu hình Git, Python, PyTorch, ComfyUI và các nút
- **Không cần thiết lập thủ công** - Python, ComfyUI và mô hình nằm trong một thư mục
- **Cài tiện ích bằng một lần nhấp** - Nunchaku, SageAttention, FlashAttention, InsightFace và nhiều tiện ích khác
- **EZi Desktop** - Cửa sổ riêng với bảng điều khiển thông minh và menu
  - Phiên bản PyTorch/CUDA (Torch-Pack)
  - Phiên bản ComfyUI và giao diện
  - Thư mục mô hình và thư mục Input/Output/User
  - Tham số khởi động và VRAM động
  - Cấu hình ComfyUI-Manager và cố định phiên bản gói
  - Bộ nhớ đệm UV/PIP và chuyển đổi GGUF
- **EZi Launcher** - Khởi chạy, cập nhật, mở thư mục, lưu và khôi phục bản chụp trạng thái

<details>
<summary><b>EZi Desktop có thể làm gì?</b></summary>

- Chạy ComfyUI trong cửa sổ riêng, trong trình duyệt hoặc cả hai
- Thông báo khi có phiên bản ComfyUI và EZi mới
- Lưu mô hình tải từ ComfyUI vào đúng thư mục
- **Bảng điều khiển**
  - Tìm kiếm (Ctrl+F) và lưu nhật ký dạng .txt (Ctrl+S)
  - Tách bảng điều khiển thành cửa sổ riêng
  - Sao chép hoặc lưu văn bản đã chọn, tìm trên Google hoặc hỏi Claude hay ChatGPT
- **Ghi hình** - Chụp hoặc quay màn hình
- **Thư mục mô hình** - Liên kết nhiều thư mục mô hình có sẵn
- **Tùy chỉnh thư mục Input, Output và User**
- **Tham số khởi động** - Trình chỉnh sửa liệt kê mọi tùy chọn
- **ComfyUI-Manager** - Giao diện mới hoặc cũ, mức bảo mật, cài qua pip hoặc URL Git
- **Quản lý phiên bản gói** - Cố định phiên bản, ví dụ `numpy==1.26.4`
- **Bộ nhớ đệm của gói** - Giữ hoặc xóa bộ nhớ đệm UV/PIP
- **Thông tin hệ thống** - GPU, RAM, Python, Torch, ComfyUI, đường dẫn dài
- Chủ đề, cỡ chữ, chú giải và nền bảng điều khiển
- Liên kết đến quy trình và khóa học ComfyUI của Pixaroma

</details>

---

<a id="requirements"></a>

## 💻 Yêu cầu hệ thống

| | |
|---|---|
| **Hệ điều hành** | Windows 10 / 11, 64 bit |
| **GPU** | NVIDIA RTX dòng 20 trở lên |
| **Trình điều khiển** | NVIDIA 580 trở lên (khuyến nghị) |
| **RAM** | Tối thiểu 8 GB, khuyến nghị từ 16 GB |
| **Ổ đĩa** | Trống ít nhất 15 GB cộng thêm dung lượng cho mô hình (khuyến nghị SSD) |
| **Internet** | Cần trong quá trình cài đặt |

> [!NOTE]
> Với trình điều khiển thấp hơn **580**, trình cài đặt dùng **CUDA 12.8** và **Torch 2.8.0**. Cập nhật trình điều khiển để dùng **CUDA 13.0** và **Torch 2.11.0**.

---

<a id="install"></a>

## 🖥️ Cài đặt trên Windows

> [!IMPORTANT]
> - Dùng đường dẫn ngắn chỉ chứa ký tự tiếng Anh, ví dụ `D:\AI\`.

1. [**📥 Tải phiên bản mới nhất**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Giải nén tệp ZIP vào một thư mục mới
3. Chạy **`ComfyUI-Easy-Install.bat`**
4. Chờ trình cài đặt hoàn tất
5. Nhấp **Start ComfyUI** hoặc mở lối tắt **ComfyUI-EZi Launcher** trên màn hình nền

<details>
<summary><b>Các thành phần được cài đặt</b></summary>

| Thành phần | Phiên bản |
|---|---|
| [Git](https://git-scm.com/) | Bản mới nhất, chỉ cài nếu thiếu Git |
| [Python](https://www.python.org/downloads/release/python-31210/) | 3.12.10 Bản nhúng, đã xác minh mã kiểm tra |
| PyTorch | 2.11.0 + CUDA 13.0 hoặc 2.8.0 + CUDA 12.8 |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | Phiên bản mới nhất |
| ComfyUI-Manager, Triton, ONNX Runtime GPU, llama-cpp-python | |
| [Các nút đi kèm](#nodes) | Các nút dùng trong bài hướng dẫn Pixaroma |
| Quy trình nhập môn | Juggernaut Reborn, Z-Image Turbo |
| Tệp đa phương tiện mẫu | Trong thư mục `ComfyUI\input` |
| ComfyUI-EZi Launcher | Lối tắt trên màn hình nền |

</details>

---

<a id="start"></a>

## ▶️ Khởi chạy ComfyUI

Mở **ComfyUI-EZi Launcher** và chọn chế độ.

- **Desktop** - Trong cửa sổ EZi Desktop
- **Browser** - Trong trình duyệt với bảng điều khiển cổ điển
- **Hybrid** - Trong trình duyệt với bảng điều khiển EZi

Khởi chạy với **KitchenAttention**, **SageAttention** hoặc **FlashAttention**. Với Sage và Flash, hãy cài tiện ích tương ứng trước.

---

<a id="addons"></a>

## 🧩 Tiện ích bổ sung

Các tiện ích nằm trong thư mục **Add-ons**. Hầu hết cũng có trong **EZi Desktop > Menu**.

| Tiện ích | Chức năng |
|---|---|
| **Easy-Models-Linker** | Dùng lại thư mục **models** hiện có.<br>Không áp dụng cho **LLM** và **llm_gguf**. |
| **Easy-System-Checker** | Hiển thị thông tin phần cứng và phần mềm |
| **Nunchaku** | Cài đặt [Nunchaku](https://github.com/nunchaku-ai/nunchaku) |
| **SageAttention-Multi** | Cài đặt [SageAttention](https://github.com/woct0rdho/SageAttention) v2.2.0 và v3 (v3 chỉ dùng trên RTX 50) |
| **FlashAttention** | Cài đặt [FlashAttention](https://github.com/Dao-AILab/flash-attention) v2.8.3 |
| **InsightFace** | Cài đặt [InsightFace](https://github.com/deepinsight/insightface) |
| **Trellis2 + Pixal3D** | Cài đặt [Trellis 2.0 + Pixal3D @visualbruno](https://github.com/visualbruno/ComfyUI-Trellis2) cùng mô hình |
| **Torch-Pack** | Chuyển phiên bản PyTorch và CUDA |
| **Easy-model2GGUF** | Chuyển mô hình sang GGUF (Q2_K đến Q8_0) |
| **Long-Paths-Enabler** | Bật hỗ trợ đường dẫn dài trong Windows |
| **Toggle-DynamicVRAM** | Bật hoặc tắt `--disable-dynamic-vram` |

<details>
<summary><b>Phiên bản Torch-Pack và khả năng hỗ trợ tiện ích</b></summary>

| Torch | CUDA | Nunchaku | Sage v2 | Sage v3 | Flash | Trellis2 |
|---|---|:---:|:---:|:---:|:---:|:---:|
| 2.7.1 | 12.8 | ✅ | ✅ | ✅ | ✅ | |
| 2.8.0 | 12.8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2.9.1 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.10.0 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| **2.11.0** (mặc định) | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.12.1 | 13.0 | | ✅ | | ✅ | |
| 2.13.0 | 13.0 | | ✅ | | ✅ | |
| 2.14.1 | 13.0 | | ✅ | | ✅ | |

</details>

---

<a id="updates"></a>

## 🔄 Cập nhật

Cập nhật ComfyUI, các nút và EZi từ trình khởi chạy. Lưu bản chụp trạng thái trước khi thay đổi lớn để có thể khôi phục bằng một lần nhấp.

---

<a id="help"></a>

## 🩺 Khắc phục sự cố

<details>
<summary><b>Trình cài đặt dừng hoặc báo lỗi</b></summary>

- Nếu quá trình cài đặt dừng, mở **Show log** rồi dùng **Copy details** để chia sẻ chi tiết trên [Discord của Pixaroma](https://discord.gg/gggpkVgBf3).
- Nhật ký đầy đủ nằm trong `ComfyUI-Easy-Install.log`.
- Xóa thư mục `ComfyUI-Easy-Install` cài dở trước khi thử lại.

</details>

<details>
<summary><b>Windows 11: "Bad Image" (0xc0e90002)</b></summary>

- Với lỗi “Bad Image” (0xc0e90002) trên Windows 11, tắt Smart App Control rồi khởi động lại ComfyUI.
- Việc này làm giảm khả năng bảo vệ trước ứng dụng không đáng tin cậy.
- Đọc cảnh báo của Windows trước khi xác nhận.

</details>

<details>
<summary><b>Tệp bị thiếu hoặc bị chặn</b></summary>

- Nếu thiếu tệp, kiểm tra lịch sử bảo vệ trong Windows Security xem phần mềm diệt virus có chặn tệp Python hay không.
- Cho phép các tệp đó, xóa thư mục rồi cài lại.

</details>

<details>
<summary><b>Không phát hiện trình điều khiển NVIDIA</b></summary>

- Nếu không phát hiện trình điều khiển, cài bản mới nhất từ [nvidia.com/drivers](https://www.nvidia.com/drivers) và kiểm tra `nvidia-smi` trong cửa sổ dòng lệnh.

</details>

<details>
<summary><b>Đường dẫn hoặc tên người dùng chứa ký tự ngoài bảng chữ cái tiếng Anh</b></summary>

- Chuyển trình cài đặt đến đường dẫn như `D:\AI\`.
- Tên người dùng Windows chứa ký tự ngoài bảng chữ cái tiếng Anh vẫn có thể gây lỗi.

</details>

<details>
<summary><b>"ComfyUI is already running"</b></summary>

- “ComfyUI is already running” cho biết cổng (mặc định 8188) đang được dùng.
- Đóng cửa sổ ComfyUI còn lại rồi thử lại.

</details>

<details>
<summary><b>Lỗi đường dẫn tệp dài</b></summary>

- Khi gặp lỗi đường dẫn dài, chạy **Long-Paths-Enabler** trong **Add-ons\Tools**.

</details>

---

<a id="uninstall"></a>

## 🧹 Gỡ cài đặt

Xóa thư mục `ComfyUI-Easy-Install` và lối tắt **ComfyUI-EZi Launcher** trên màn hình nền.

---

<a id="nodes"></a>

## 📦 Các nút đi kèm

<details>
<summary><b>Các nút dùng trong bài hướng dẫn Pixaroma</b></summary>

| 🖼️ Hình ảnh | 🎬 Video | 🎵 Âm thanh | 🧩 Tiện ích và quy trình | 🤖 Mô hình |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [WanVideoWrapper](https://github.com/kijai/ComfyUI-WanVideoWrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | | [KJNodes](https://github.com/kijai/ComfyUI-KJNodes) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | [SeedVR2 VideoUpscaler](https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler) | | [iTools](https://github.com/MohammadAboulEla/ComfyUI-iTools) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI Nodes](https://github.com/gseth/ControlAltAI-Nodes) | |
| [Krea2Edit](https://github.com/lbouaraba/comfyui-krea2edit) | | | ✨ [Pixaroma](https://gitlab.com/pixaroma/ComfyUI-Pixaroma) | |

</details>

---

<a id="comic"></a>

## 🎭 Làm quen với EZi qua truyện tranh

Mới dùng EZi? Nhấp vào bất kỳ hình nào trong truyện để xem ở kích thước đầy đủ.

<table width="100%">
  <tr>
    <th width="16.66%">Cài ComfyUI</th>
    <th width="16.66%">Trình khởi chạy EZi</th>
    <th width="16.66%">Dùng lại mô hình</th>
    <th width="16.66%">Cài tiện ích</th>
    <th width="16.66%">Cập nhật và khôi phục</th>
    <th width="16.66%">Hệ thống của bạn</th>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6"><img src="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6" width="100%" alt="Cài ComfyUI"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9"><img src="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9" width="100%" alt="Trình khởi chạy EZi"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901"><img src="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901" width="100%" alt="Dùng lại mô hình"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b"><img src="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b" width="100%" alt="Cài tiện ích"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6"><img src="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6" width="100%" alt="Cập nhật và khôi phục"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3"><img src="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3" width="100%" alt="Hệ thống của bạn"></a></td>
  </tr>
</table>

<div align="center">

<a id="support"></a>

## ❤️ Ủng hộ phát triển

Nếu bạn yêu thích dự án, sự ủng hộ của bạn sẽ giúp duy trì việc phát triển.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
