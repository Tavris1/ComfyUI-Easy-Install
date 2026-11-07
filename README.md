<p align="center">
🌍 
<strong>English</strong> |
<a href="docs/README.zh-CN.md#zh-cn">简体中文</a> |
<a href="docs/README.ja.md#ja">日本語</a> |
<a href="docs/README.ko.md#ko">한국어</a> |
<a href="docs/README.es.md#es">Español</a> |
<a href="docs/README.pt-BR.md#pt-br">Português</a> |
<a href="docs/README.de.md#de">Deutsch</a> |
<a href="docs/README.fr.md#fr">Français</a> |
<a href="docs/README.ru.md#ru">Русский</a> |
<a href="docs/README.tr.md#tr">Türkçe</a> |
<a href="docs/README.vi.md#vi">Tiếng Việt</a>
</p>

---

<div align="center">
  <img src="docs/EZi-Logo.svg" width="120" alt="EZi Logo">
  <h1>ComfyUI-Easy-Install</h1>
  <p align="center">
    <strong>One-click Portable ComfyUI with EZi Desktop - install, manage and customize ComfyUI in one place.</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

<p align="center">
  <a href="#%EF%B8%8F-windows-installation">📥 <strong>INSTALL</strong></a> &nbsp;·&nbsp;
  <a href="#-features">✨ Features</a> &nbsp;·&nbsp;
  <a href="#-requirements">💻 Requirements</a> &nbsp;·&nbsp;
  <a href="#-troubleshooting">🩺 Help</a> &nbsp;·&nbsp;
  <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
  <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
  <a href="#%EF%B8%8F-support-development">❤️ Support</a>
</p>

<br>

![ComfyUI Screenshot](docs/ComfyUI-ivo.png)

**New to EZi?** [Meet EZi - The Comic Guide](#-meet-ezi---the-comic-guide)

</div>

## ✨ Features

**ComfyUI-Easy-Install** installs a portable ComfyUI  
with its own Python, ready-to-use nodes and **EZi Desktop**.

- **One click** - Git, Python, PyTorch, ComfyUI and nodes are set up for you
- **No manual setup** - Python, ComfyUI and models live in one folder
- **One-click add-ons** - Nunchaku, SageAttention, FlashAttention, InsightFace and more
- **EZi Desktop** - ComfyUI in its own window with a smart console and a menu for:
  - PyTorch/CUDA versions (Torch-Pack)
  - ComfyUI and frontend versions
  - Models folders, Input/Output/User folders
  - Startup arguments and Dynamic VRAM
  - ComfyUI-Manager settings and pinned packages
  - UV/PIP cache and GGUF conversion
- **EZi Launcher** - start, update, open folders and save/restore snapshots

<details>
<summary><b>What EZi Desktop can do</b></summary>

- Runs ComfyUI in its own window, in the browser, or both
- Notifies you about new ComfyUI and EZi versions
- Model downloads from ComfyUI go straight to the right folder
- **Console**
  - Search (Ctrl+F) and save the log as .txt (Ctrl+S)
  - Detach it to a separate window
  - Selected text: Copy, Save, Google, Ask Claude, Ask ChatGPT
- **Capture** - screenshot or screen recording
- **Models Folders** - link several existing models folders
- **Custom Input, Output & User folders**
- **Startup arguments** editor with a list of all options
- **ComfyUI-Manager** - New/Legacy UI, security level, pip and Git URL installs
- **Pinned Packages Manager** - freeze versions such as `numpy==1.26.4`
- **Package Cache** - keep or clean UV/PIP cache
- **System Info** - GPU, RAM, Python, Torch, ComfyUI, Long Paths
- Themes, text size, tooltips and console background
- Links to Pixaroma workflows and the ComfyUI course

</details>

---

## 💻 Requirements

| | |
|---|---|
| **OS** | Windows 10 / 11, 64-bit |
| **GPU** | NVIDIA RTX 20 series or newer |
| **Driver** | NVIDIA 580 or newer (recommended) |
| **RAM** | 8 GB minimum, 16 GB or more recommended |
| **Disk** | at least 15 GB free, plus space for models (SSD recommended) |
| **Internet** | needed during installation |

> [!NOTE]
> With a driver below **580**, the installer uses **CUDA 12.8** and **Torch 2.8.0**.  
> Update the driver to get **CUDA 13.0** and **Torch 2.11.0**.

---

## 🖥️ Windows Installation

> [!IMPORTANT]
> - Use a short, English-only path, for example `D:\AI\`

1. [**📥 DOWNLOAD LATEST VERSION**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Extract the ZIP file to a new folder
3. Run **`ComfyUI-Easy-Install.bat`**
4. Wait for the installer window to finish
5. Click **Start ComfyUI**, or use the **ComfyUI-EZi Launcher** shortcut on your Desktop

<details>
<summary><b>What gets installed</b></summary>

| Component | Version |
|---|---|
| [Git](https://git-scm.com/) | Latest, only if missing |
| [Python](https://www.python.org/downloads/release/python-31210/) | 3.12.10 embedded, checksum verified |
| PyTorch | 2.11.0 + CUDA 13.0, or 2.8.0 + CUDA 12.8 |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | Latest version |
| ComfyUI-Manager, Triton, ONNX Runtime GPU, llama-cpp-python | |
| [Included nodes](#-included-nodes) | Nodes used in Pixaroma tutorials |
| Getting Started workflows | Juggernaut Reborn, Z-Image Turbo |
| Example media | In the `ComfyUI\input` folder |
| ComfyUI-EZi Launcher | Shortcut on the Desktop |

</details>

---

## ▶️ Starting ComfyUI

Open **ComfyUI-EZi Launcher** and choose a mode:

- **Desktop** - in the EZi Desktop window
- **Browser** - in your browser, with the classic console
- **Hybrid** - in your browser, with the EZi console

Start with **KitchenAttention**, **SageAttention** or **FlashAttention**  
(Sage and Flash after installing the add-on).

---

## 🧩 Add-ons

In the **Add-ons** folder. Most are also in **EZi Desktop > Menu**.

| Add-on | What it does |
|---|---|
| **Easy-Models-Linker** | Uses your existing **models** folder.<br>Not for **LLM** and **llm_gguf** |
| **Easy-System-Checker** | Shows key hardware and software info |
| **Nunchaku** | Installs [Nunchaku](https://github.com/nunchaku-ai/nunchaku) |
| **SageAttention-Multi** | Installs [SageAttention](https://github.com/woct0rdho/SageAttention) v2.2.0 and v3 (v3 only on RTX 50) |
| **FlashAttention** | Installs [FlashAttention](https://github.com/Dao-AILab/flash-attention) v2.8.3 |
| **InsightFace** | Installs [InsightFace](https://github.com/deepinsight/insightface) |
| **Trellis2 + Pixal3D** | Installs [Trellis 2.0 + Pixal3D @visualbruno](https://github.com/visualbruno/ComfyUI-Trellis2) and the model |
| **Torch-Pack** | Switches PyTorch and CUDA versions |
| **Easy-model2GGUF** | Converts models to GGUF (Q2_K to Q8_0) |
| **Long-Paths-Enabler** | Enables Long Paths in Windows |
| **Toggle-DynamicVRAM** | Toggles `--disable-dynamic-vram` |

<details>
<summary><b>Torch-Pack versions and add-on support</b></summary>

| Torch | CUDA | Nunchaku | Sage v2 | Sage v3 | Flash | Trellis2 |
|---|---|:---:|:---:|:---:|:---:|:---:|
| 2.7.1 | 12.8 | ✅ | ✅ | ✅ | ✅ | |
| 2.8.0 | 12.8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2.9.1 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.10.0 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| **2.11.0** (default) | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.12.1 | 13.0 | | ✅ | | ✅ | |
| 2.13.0 | 13.0 | | ✅ | | ✅ | |
| 2.14.1 | 13.0 | | ✅ | | ✅ | |

</details>

---

## 🔄 Updates

Update ComfyUI, nodes and EZi from **ComfyUI-EZi Launcher**.  
Save a **snapshot** before big changes and restore it with one click.

---

## 🩺 Troubleshooting

<details>
<summary><b>The installer stopped or shows errors</b></summary>

- Click **Show log** to see what happened
- Click **Copy details** and paste it in the [Pixaroma Discord](https://discord.gg/gggpkVgBf3)
- The full log is in `ComfyUI-Easy-Install.log`
- Delete the unfinished `ComfyUI-Easy-Install` folder before trying again

</details>

<details>
<summary><b>Windows 11: "Bad Image" (0xc0e90002)</b></summary>

- Turn off **Smart App Control** and restart ComfyUI
- This reduces protection against untrusted apps.  
  Read the Windows warning before confirming.

</details>

<details>
<summary><b>Files are missing or blocked</b></summary>

- Your antivirus may have blocked Python files
- Check **Windows Security > Protection history**
- Allow the files, delete the folder and install again

</details>

<details>
<summary><b>NVIDIA driver not detected</b></summary>

- Install the latest driver from [nvidia.com/drivers](https://www.nvidia.com/drivers)
- Check that `nvidia-smi` works in a terminal

</details>

<details>
<summary><b>Path or user name with non-English characters</b></summary>

- Move the installer to a path like `D:\AI\`
- If your Windows user name is not in English, problems are still possible

</details>

<details>
<summary><b>"ComfyUI is already running"</b></summary>

- ComfyUI is already open on the same port (8188 by default)
- Close the other ComfyUI window and try again

</details>

<details>
<summary><b>Errors with long file paths</b></summary>

- Run **Long-Paths-Enabler** from **Add-ons\Tools**

</details>

---

## 🧹 Uninstall

Delete the `ComfyUI-Easy-Install` folder  
and the **ComfyUI-EZi Launcher** shortcut from the Desktop.

---

## 📦 Included Nodes

<details>
<summary><b>Nodes Used in Pixaroma Tutorials</b></summary>

| 🖼️ Image | 🎬 Video | 🎵 Audio | 🧩 Utility / WF | 🤖 Models |
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

## 🎭 Meet EZi - The Comic Guide

New to EZi? Explore this illustrated guide.  
Click any image to view it full-size.

<table width="100%">
  <tr>
    <th width="16.66%">Install ComfyUI</th>
    <th width="16.66%">EZi Launcher</th>
    <th width="16.66%">Reuse Models</th>
    <th width="16.66%">Install Add-ons</th>
    <th width="16.66%">Update/Restore</th>
    <th width="16.66%">Your System</th>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6"><img src="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6" width="100%" alt="Install ComfyUI"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9"><img src="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9" width="100%" alt="EZi Launcher"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901"><img src="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901" width="100%" alt="Reuse Models"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b"><img src="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b" width="100%" alt="Install Add-ons"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6"><img src="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6" width="100%" alt="Update/Restore"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3"><img src="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3" width="100%" alt="Your System"></a></td>
  </tr>
</table>

<div align="center">

## ❤️ Support Development

Enjoy the project? Your support helps keep it going.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
