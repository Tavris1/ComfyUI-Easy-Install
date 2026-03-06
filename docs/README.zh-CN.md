<p align="center">
🌍 
<a href="../README.md">English</a> |
<strong>简体中文</strong> |
<a href="README.ja.md">日本語</a> |
<a href="README.ko.md">한국어</a> |
<a href="README.es.md">Español</a> |
<a href="README.pt-BR.md">Português</a> |
<a href="README.ru.md">Русский</a> |
<a href="README.de.md">Deutsch</a> |
<a href="README.fr.md">Français</a> |
<a href="README.vi.md">Tiếng Việt</a>
</p>

---

# ComfyUI-Easy-Install
> 一键便携版 **ComfyUI** 适用于 **Windows** 🔹 Nvidia 显卡 🔹 Pixaroma 社区版 🔹  
> [![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
> [![GitHun Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
> [![Github All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)]()
> [![GitHub Downloads latest)](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=downloads%40latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
>
> 致敬 **Pixaroma** 团队  
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Join%20Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_presence_count&logo=discord&logoColor=white&label=Online&color=blue&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)

---

## 包含组件:  
- **Git** *(如有需要将自动安装或更新)*  
- **ComfyUI 便携版**  
- **Python 3.12.10** *(嵌入式便携版本)*  

### 来自 Pixaroma 教程的节点 [YouTube](https://www.youtube.com/@pixaroma)

|||||||
|---|---|---|---|---|---|
ComfyUI Manager | Tiled Diffusion & VAE | SCAIL-Pose | KJNodes | rgthree | iTools
MelBandRoFormer | Inpaint-CropAndStitch | Qwen3-TTS | Easy-Use | QwenVL | GGUF
VideoHelperSuite | SeedVR2_VideoUpscaler | ControlNet Aux | LayerStyle | Easy-Sam3 | RMBG
WanVideoWrapper | WanAnimatePreprocess | Comfyroll Studio

### 可选附加节点
||||||
|---|---|---|---|---|
Nunchaku | SageAttention-Multi (v2.2.0 and v3) | FlashAttention | Trellis 2.0 | InsightFace

### 附加工具
||||||
|---|---|---|---|---|
Easy-Models-Linker | Torch-Pack | Easy-model2GGUF | Long-Paths-Enabler | ComfyUI-Version-Switcher

---

## Windows 安装步骤
1. 下载 [:arrow_forward:**最新版本请点击这里**◀️](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. 将 ZIP 文件解压到新文件夹并运行 **`ComfyUI-Easy-Install.bat`** 开始安装
3. 安装完成后，可在 **Add-ons** 文件夹中选择安装或运行以下组件:
    - **Easy-Models-Linker** - *通过 **extra_model_paths.yaml** 使用现有 **MODELS** 文件夹，无需重新下载*
      - *部分文件夹如 **LLM** 和 **llm_gguf** 无法通过此方式重定向*
    - **Nunchaku** - *安装 Nunchaku，如后续出现问题可再次运行 `Nunchaku.bat`*
    - **SageAttention-Multi** - *安装 SageAttention v2.2.0 和 v3 (v3 仅在 NVIDIA 50 系列显卡有效)*
    - **FlashAttention** - *安装 FlashAttention v2.8.3*
    - **InsightFace** - *安装 InsightFace (仅限非商业研究用途的预训练模型)*
    - **Trellis2** - *安装 Trellis 2.0 及模型 (需要 `Add-ons/Torch-Pack` 中的 `Torch 2.8.0+cu128`)*
    - **Torch-Pack** - *快速切换以下版本:*
      - ***Torch 2.7.1+cu128***
      - ***Torch 2.8.0+cu128***
      - ***Torch 2.9.1+cu130** (默认，需要 NVIDIA 驱动 v580+)*  
    - **Easy-model2GGUF** *(**Add-Ons/Tools**)*  
      - *在几分钟内将模型 (`.safetensors`, `.pth`, `.pt`) 转换为 **GGUF** 格式 (FP16 或 BF16)*  
      - *支持从 **Q2_K** 到 **Q8_0** 的量化选项，并在可用时应用 **5D tensor 修复***  
    - **Long-Paths-Enabler** *(`Add-Ons/Tools`)* - *在 Windows 10/11 中启用 **Long Paths**，对 Python/ComfyUI 至关重要*  
    - **ComfyUI-Version-Switcher** *(`Add-Ons/Tools`)* - ***可逆** 回滚到 **之前** 的 ComfyUI 版本以解决问题*  
    - **Toggle-DynamicVRAM** *(`Add-Ons/Tools`)* - *切换 ComfyUI 启动文件中的 **--disable-dynamic-vram** 选项*  
    - **Update Easy-Install.bat** *(主文件夹)* - *更新 **Add-ons** 及其他文件夹，并创建桌面快捷方式*  

> [!IMPORTANT]
> - 请勿以 **管理员身份** 运行安装程序。
> - 避免使用系统文件夹 (`Program Files`, `Windows`, `C:\` 根目录)。
> - 避免在文件夹名称中使用空格和特殊字符。
> - 请确保您的 NVIDIA 驱动为最新版本。

> [!TIP]
> - 允许多个 ComfyUI 安装实例且不会冲突。
> - 安装完成后可重命名或移动 `ComfyUI-Easy-Install` 文件夹。
> - macOS / Linux 用户请点击 [here](https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux)

---

<img width="1038" height="240" alt="123321" src="https://github.com/user-attachments/assets/6d0655ef-8724-4cb1-bce2-a29fc9004173" />

---

如果您喜欢我的项目，请考虑支持我。任何支持都将不胜感激！

💜 PayPal: https://paypal.me/tavris1  
☕ Buy Me a Coffee: https://buymeacoffee.com/tavris1  
❤️ GitHub Sponsors: https://github.com/sponsors/Tavris1  
