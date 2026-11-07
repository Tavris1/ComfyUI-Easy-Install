<a id="zh-cn"></a>

<p align="center">
🌍 
<a href="../README.md">English</a> |
<strong>简体中文</strong> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
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
    <strong>使用 EZi Desktop 一键安装便携版 ComfyUI，在同一处管理和自定义环境。</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

<p align="center">
  <a href="#install">📥 <strong>安装</strong></a> &nbsp;·&nbsp;
  <a href="#features">✨ 功能</a> &nbsp;·&nbsp;
  <a href="#requirements">💻 系统要求</a> &nbsp;·&nbsp;
  <a href="#help">🩺 帮助</a> &nbsp;·&nbsp;
  <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
  <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
  <a href="#support">❤️ 支持</a>
</p>

<br>

![ComfyUI Screenshot](ComfyUI-ivo.png)

**初次使用 EZi？** [EZi 漫画指南](#comic)

</div>

<a id="features"></a>

## ✨ 功能

**ComfyUI-Easy-Install** 可安装便携版 ComfyUI，其中包含独立的 Python 环境、开箱即用的节点和 **EZi Desktop**。

- **一键安装** - 自动配置 Git、Python、PyTorch、ComfyUI 和节点
- **无需手动配置** - Python、ComfyUI 和模型都在同一文件夹中
- **一键添加组件** - Nunchaku, SageAttention, FlashAttention, InsightFace 等
- **EZi Desktop** - 独立窗口，配有智能控制台和设置菜单
  - PyTorch/CUDA 版本（Torch-Pack）
  - ComfyUI 和前端版本
  - 模型目录及 Input/Output/User 目录
  - 启动参数和动态显存
  - ComfyUI-Manager 设置和固定版本的软件包
  - UV/PIP 缓存和 GGUF 转换
- **EZi Launcher** - 启动、更新、打开文件夹，以及保存和恢复快照

<details>
<summary><b>EZi Desktop 的功能</b></summary>

- 在独立窗口、浏览器或两者中运行 ComfyUI
- 接收 ComfyUI 和 EZi 新版本通知
- 将 ComfyUI 下载的模型直接保存到相应目录
- **控制台**
  - 搜索（Ctrl+F）并将日志保存为 .txt（Ctrl+S）
  - 将控制台分离到独立窗口
  - 复制或保存选中文本、用 Google 搜索，或向 Claude、ChatGPT 提问
- **屏幕捕获** - 截图或录屏
- **模型目录** - 关联多个已有的模型文件夹
- **自定义 Input、Output 和 User 目录**
- **启动参数** - 编辑器列出所有可用选项
- **ComfyUI-Manager** - 切换新旧界面、设置安全级别、通过 pip 或 Git URL 安装
- **软件包版本管理** - 固定版本，例如 `numpy==1.26.4`
- **软件包缓存** - 保留或清理 UV/PIP 缓存
- **系统信息** - GPU, RAM, Python, Torch, ComfyUI, 长路径支持
- 主题、字号、工具提示和控制台背景
- Pixaroma 工作流和 ComfyUI 课程链接

</details>

---

<a id="requirements"></a>

## 💻 系统要求

| | |
|---|---|
| **操作系统** | Windows 10 / 11, 64 位 |
| **GPU** | NVIDIA RTX 20 系列或更新型号 |
| **驱动程序** | NVIDIA 580 或更高版本（推荐） |
| **RAM** | 至少 8 GB，推荐 16 GB 或以上 |
| **磁盘** | 至少 15 GB 可用空间，另需模型存储空间（推荐 SSD） |
| **Internet** | 安装时需要联网 |

> [!NOTE]
> 驱动低于 **580** 时使用 **CUDA 12.8** 和 **Torch 2.8.0**。更新驱动即可使用 **CUDA 13.0** 和 **Torch 2.11.0**。

---

<a id="install"></a>

## 🖥️ 在 Windows 上安装

> [!IMPORTANT]
> - 请使用简短的纯英文路径，例如 `D:\AI\`。

1. [**📥 下载最新版本**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. 将 ZIP 解压到新文件夹
3. 运行 **`ComfyUI-Easy-Install.bat`**
4. 等待安装完成
5. 点击 **Start ComfyUI**，或打开桌面上的 **ComfyUI-EZi Launcher** 快捷方式

<details>
<summary><b>安装内容</b></summary>

| 组件 | 版本 |
|---|---|
| [Git](https://git-scm.com/) | 仅在未安装时安装最新版 |
| [Python](https://www.python.org/downloads/release/python-31210/) | 3.12.10 嵌入式版本，已验证校验和 |
| PyTorch | 2.11.0 + CUDA 13.0 或 2.8.0 + CUDA 12.8 |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | 最新版 |
| ComfyUI-Manager, Triton, ONNX Runtime GPU, llama-cpp-python | |
| [内置节点](#nodes) | Pixaroma 教程使用的节点 |
| 入门工作流 | Juggernaut Reborn, Z-Image Turbo |
| 示例媒体 | 所在文件夹： `ComfyUI\input` |
| ComfyUI-EZi Launcher | 桌面快捷方式 |

</details>

---

<a id="start"></a>

## ▶️ 启动 ComfyUI

打开 **ComfyUI-EZi Launcher** 并选择模式。

- **Desktop** - 使用 EZi Desktop 窗口
- **Browser** - 使用浏览器和经典控制台
- **Hybrid** - 使用浏览器和 EZi 控制台

可使用 **KitchenAttention**、**SageAttention** 或 **FlashAttention** 启动。使用 Sage 和 Flash 前须安装对应组件。

---

<a id="addons"></a>

## 🧩 附加组件

组件位于 **Add-ons** 文件夹，多数组件也可在 **EZi Desktop > Menu** 中找到。

| 组件 | 功能 |
|---|---|
| **Easy-Models-Linker** | 关联已有的 **models** 文件夹。<br>不适用于 **LLM** 和 **llm_gguf**。 |
| **Easy-System-Checker** | 显示主要硬件和软件信息 |
| **Nunchaku** | 安装 [Nunchaku](https://github.com/nunchaku-ai/nunchaku) |
| **SageAttention-Multi** | 安装 [SageAttention](https://github.com/woct0rdho/SageAttention) v2.2.0 和 v3（v3 仅支持 RTX 50） |
| **FlashAttention** | 安装 [FlashAttention](https://github.com/Dao-AILab/flash-attention) v2.8.3 |
| **InsightFace** | 安装 [InsightFace](https://github.com/deepinsight/insightface) |
| **Trellis2 + Pixal3D** | 安装 [Trellis 2.0 + Pixal3D @visualbruno](https://github.com/visualbruno/ComfyUI-Trellis2) 及其模型 |
| **Torch-Pack** | 切换 PyTorch 和 CUDA 版本 |
| **Easy-model2GGUF** | 将模型转换为 GGUF（Q2_K 至 Q8_0） |
| **Long-Paths-Enabler** | 启用 Windows 长路径支持 |
| **Toggle-DynamicVRAM** | 切换 `--disable-dynamic-vram` |

<details>
<summary><b>Torch-Pack 版本与组件兼容性</b></summary>

| Torch | CUDA | Nunchaku | Sage v2 | Sage v3 | Flash | Trellis2 |
|---|---|:---:|:---:|:---:|:---:|:---:|
| 2.7.1 | 12.8 | ✅ | ✅ | ✅ | ✅ | |
| 2.8.0 | 12.8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2.9.1 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.10.0 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| **2.11.0** (默认) | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.12.1 | 13.0 | | ✅ | | ✅ | |
| 2.13.0 | 13.0 | | ✅ | | ✅ | |
| 2.14.1 | 13.0 | | ✅ | | ✅ | |

</details>

---

<a id="updates"></a>

## 🔄 更新

从启动器更新 ComfyUI、节点和 EZi。重大更改前保存快照，以便一键恢复。

---

<a id="help"></a>

## 🩺 故障排除

<details>
<summary><b>安装程序停止或报错</b></summary>

- 安装中止或出错时点击 **Show log**，通过 **Copy details** 将详情贴到 [Pixaroma Discord](https://discord.gg/gggpkVgBf3)。
- 完整日志位于 `ComfyUI-Easy-Install.log`。
- 重试前删除未安装完成的 `ComfyUI-Easy-Install` 文件夹。

</details>

<details>
<summary><b>Windows 11: "Bad Image" (0xc0e90002)</b></summary>

- Windows 11 出现 “Bad Image” (0xc0e90002) 时，关闭 Smart App Control 并重启 ComfyUI。
- 这会降低对不受信任应用的防护，请先阅读 Windows 警告再确认。

</details>

<details>
<summary><b>文件缺失或被阻止</b></summary>

- 文件缺失或被阻止时，在 Windows 安全中心的“保护历史记录”查看 Python 文件。
- 允许这些文件后删除安装文件夹并重新安装。

</details>

<details>
<summary><b>未检测到 NVIDIA 驱动</b></summary>

- 未检测到驱动时，从 [nvidia.com/drivers](https://www.nvidia.com/drivers) 安装最新驱动，并在终端检查 `nvidia-smi`。

</details>

<details>
<summary><b>路径或用户名含非英文字符</b></summary>

- 将安装程序移至 `D:\AI\` 等路径。
- Windows 用户名含非英文字符时仍可能出现问题。

</details>

<details>
<summary><b>"ComfyUI is already running"</b></summary>

- “ComfyUI is already running” 表示端口（默认 8188）已被占用。
- 关闭另一个 ComfyUI 窗口后重试。

</details>

<details>
<summary><b>文件路径过长</b></summary>

- 路径过长时，运行 **Add-ons\Tools** 下的 **Long-Paths-Enabler**。

</details>

---

<a id="uninstall"></a>

## 🧹 卸载

删除 `ComfyUI-Easy-Install` 文件夹及桌面上的 **ComfyUI-EZi Launcher** 快捷方式。

---

<a id="nodes"></a>

## 📦 内置节点

<details>
<summary><b>Pixaroma 教程使用的节点</b></summary>

| 🖼️ 图像 | 🎬 视频 | 🎵 音频 | 🧩 工具／工作流 | 🤖 模型 |
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

## 🎭 EZi 漫画指南

初次使用 EZi？点击漫画中的任意图片即可查看原图。

<table width="100%">
  <tr>
    <th width="16.66%">安装 ComfyUI</th>
    <th width="16.66%">EZi 启动器</th>
    <th width="16.66%">复用模型</th>
    <th width="16.66%">安装组件</th>
    <th width="16.66%">更新与恢复</th>
    <th width="16.66%">系统信息</th>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6"><img src="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6" width="100%" alt="安装 ComfyUI"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9"><img src="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9" width="100%" alt="EZi 启动器"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901"><img src="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901" width="100%" alt="复用模型"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b"><img src="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b" width="100%" alt="安装组件"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6"><img src="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6" width="100%" alt="更新与恢复"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3"><img src="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3" width="100%" alt="系统信息"></a></td>
  </tr>
</table>

<div align="center">

<a id="support"></a>

## ❤️ 支持开发

如果你喜欢这个项目，欢迎支持后续开发。

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
