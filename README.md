# ComfyUI-Easy-Install
> One-click Portable **ComfyUI** for **Windows** 🔹 Nvidia GPUs 🔹 Pixaroma Community Edition 🔹  
> [![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
> [![GitHun Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
> [![Github All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)]()
> [![GitHub Downloads latest)](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=downloads%40latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
>
> Dedicated to the **Pixaroma** team  
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Join%20Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_presence_count&logo=discord&logoColor=white&label=Online&color=blue&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
---

## Included Components:  
- **Git** *(will be installed or updated if needed)*
- **ComfyUI portable**
- **Python 3.12.10** *(Embedded Portable Version)*

### Nodes from Pixaroma tutorials on [YouTube](https://www.youtube.com/@pixaroma)

||||||
|---|---|---|---|---|
ComfyUI Manager | Tiled Diffusion & VAE | LayerStyle | rgthree | GGUF
VideoHelperSuite | Inpaint-CropAndStitch | SCAIL-Pose | KJNodes | iTools
Comfyroll Studio | SeedVR2_VideoUpscaler | ControlNet Aux | Easy-Use | RMBG
WanVideoWrapper | WanAnimatePreprocess | MelBandRoFormer | Easy-Sam3 | QwenVL
Qwen3-TTS

### Optional Add-ons Nodes
||||||
|---|---|---|---|---|
Nunchaku | SageAttention-Multi (v2.2.0 and v3) | FlashAttention | Trellis 2.0 | InsightFace

### Add-ons Tools
||||||
|---|---|---|---|---|
Easy-Models-Linker | Torch-Pack | Easy-model2GGUF | Long-Paths-Enabler | ComfyUI-Version-Switcher

---

## Windows Installation
1. Download the [:arrow_forward:**latest release HERE**◀️](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Extract the ZIP file to a new folder and run **`ComfyUI-Easy-Install.bat`** to start setup
3. After setup, you may optionally install or run the following components from the **Add-ons** folder:
    - **Easy-Models-Linker** - *Uses existing **MODELS** folder via **extra_model_paths.yaml**, no re-download needed*
      - *Some folders like **LLM** and **llm_gguf** cannot be redirected this way*
    - **Nunchaku** - *Installs Nunchaku. Start `Nunchaku.bat` again if issues occur later*
    - **SageAttention-Multi** - *Installs both SageAttention v2.2.0 and v3 (v3 effective only on NVIDIA 50-series GPUs)*
    - **FlashAttention** - *Installs FlashAttention v2.8.3*
    - **InsightFace** - *Installs InsightFace (Pretrained models for non-commercial research only)*
    - **Trellis2** - *Installs Trellis 2.0 and the model (requires `Torch 2.8.0+cu128` from the `Add-ons/Torch-Pack`)*
    - **Torch-Pack** - *Quick switching between:*
      - ***Torch 2.7.1+cu128***
      - ***Torch 2.8.0+cu128***
      - ***Torch 2.9.1+cu130** (default, requires NVIDIA driver v580+)*
    - **Easy-model2GGUF** *(**Add-Ons/Tools**)*
      - *Converts models (`.safetensors`, `.pth`, `.pt`) to **GGUF** format (FP16 or BF16) within a few minutes*
      - *Quantizes models with options from **Q2_K** to **Q8_0** and applies **5D tensor fixes** if available*
    - **Long-Paths-Enabler** *(`Add-Ons/Tools`)* - *Enables **Long Paths** in Windows 10/11*. Essential for Python/ComfyUI
    - **ComfyUI-Version-Switcher** *(`Add-Ons/Tools`)* - ***Reversible** rollback to a **previous** ComfyUI version on issues*
    - **Update Easy-Install.bat** *(main folder)* - *Updates **Add-ons** and other folders. Creates desktop shortcuts*
> [!IMPORTANT]
> - Do not run the installer as **Administrator**.
> - Avoid system folders (`Program Files`, `Windows`, `C:\` root).
> - Avoid spaces and special characters in folder names.
> - Make sure your NVIDIA drivers are up to date.

> [!TIP]
> - Multiple ComfyUI installs allowed without conflicts.
> - You can rename/move `ComfyUI-Easy-Install` folder after installation.
> - For macOS / Linux click [here](https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux)

---

<!-- <img width="1193" height="643" alt="model2GGUF" src="https://github.com/user-attachments/assets/9704bd60-08ee-42aa-b0a3-8cab2fcbcef5" /> -->
<img width="1038" height="240" alt="123321" src="https://github.com/user-attachments/assets/6d0655ef-8724-4cb1-bce2-a29fc9004173" />

---

If you enjoy my projects, please consider sponsoring me. Any support is greatly appreciated!

<!-- [![Sponsor me on GitHub](https://img.shields.io/github/sponsors/Tavris1?label=Sponsor&logo=GitHub)](https://github.com/sponsors/Tavris1) -->
💜 PayPal: https://paypal.me/tavris1  
☕ Buy Me a Coffee: https://buymeacoffee.com/tavris1  
❤️ GitHub Sponsors: https://github.com/sponsors/Tavris1  













