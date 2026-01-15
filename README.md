# ComfyUI-Easy-Install  
> One-click Portable **ComfyUI** for **Windows** 🔹 Pixaroma Community Edition 🔹  
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
- [🔗](https://git-scm.com/) **Git** _(will be installed or updated if needed)_  
- [🔗](https://github.com/comfyanonymous/ComfyUI) **ComfyUI portable**  
- [🔗](https://www.python.org/downloads/release/python-31210/) **Python 3.12.10** _(Embedded Portable Version)_

## Nodes from Pixaroma tutorials on [YouTube](https://www.youtube.com/@pixaroma)  

|||||
|---|---|---|---|
[🔗](https://github.com/Comfy-Org/ComfyUI-Manager) ComfyUI Manager | [🔗](https://github.com/yolain/ComfyUI-Easy-Use) Easy-Use | [🔗](https://github.com/Fannovel16/comfyui_controlnet_aux) ControlNet Aux | [🔗](https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes) Comfyroll Studio
 [🔗](https://github.com/rgthree/rgthree-comfy) rgthree | [🔗](https://github.com/city96/ComfyUI-GGUF) GGUF | [🔗](https://github.com/MohammadAboulEla/ComfyUI-iTools) iTools | [🔗](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) Inpaint-CropAndStitch
 [🔗](https://github.com/1038lab/ComfyUI-RMBG) RMBG | [🔗](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) VideoHelperSuite | [🔗](https://github.com/welltop-cn/ComfyUI-TeaCache) TeaCache | [🔗](https://github.com/shiimizu/ComfyUI-TiledDiffusion) Tiled Diffusion & VAE
 [🔗](https://github.com/kijai/ComfyUI-KJNodes) KJNodes | [🔗](https://github.com/kijai/ComfyUI-WanVideoWrapper) WanVideoWrapper |  [🔗](https://github.com/1038lab/ComfyUI-QwenVL) QwenVL  

## Optional Add-ons Nodes
||||||
|---|---|---|---|---|
[🔗](https://github.com/nunchaku-tech/ComfyUI-nunchaku) Nunchaku | [🔗](https://github.com/thu-ml/SageAttention) SageAttention 2.2.0 | [🔗](https://github.com/thu-ml/SageAttention) SageAttention 3 | [🔗](https://github.com/Dao-AILab/flash-attention) FlashAttention | [🔗](https://github.com/visualbruno/ComfyUI-Trellis2) Trellis 2.0
[🔗](https://github.com/deepinsight/insightface) InsightFace

## Add-ons Tools
|||||
|---|---|---|---|
Easy-Models-Linker :sparkles: | Torch-Pack :sparkles: | Easy-model2GGUF :sparkles: | Long-Paths-Enabler :sparkles:
ComfyUI-Version-Switcher :sparkles:

---
## Windows Installation
:one: Download the [:arrow_forward:**latest release here**◀️](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)  
:two: Extract the ZIP file to a new folder and run **`ComfyUI-Easy-Install.bat`** to start setup  
:three: After setup, you may optionally install or run the following components from the **Add-ons** folder:  
- :small_orange_diamond: **Easy-Models-Linker** - *Uses existing **MODELS** folder via **extra_model_paths.yaml**, no re-download needed*  
  - *Some folders like **LLM** and **llm_gguf** cannot be redirected this way*  
- :small_orange_diamond: **Nunchaku** - *Installs **Nunchaku**. Start **Nunchaku.bat** again if issues occur later*  
- :small_orange_diamond: **SageAttention** - *Installs **Triton** and **SageAttention** v2.2.0, creates **`Start ComfyUI SageAttention.bat`***  
- :small_orange_diamond: **SageAttention3** - *Installs **Triton** and **SageAttention3**. Only effective on NVIDIA 50‑series GPUs*  
- :small_orange_diamond: **FlashAttention** - *Installs **Triton** and **FlashAttention** and creates **`Start ComfyUI FlashAttention.bat`***  
- :small_orange_diamond: **InsightFace** - *Installs **InsightFace** with all modules (Pretrained models for non-commercial research only)*  
- :small_orange_diamond: **Trellis2** - *Installs **Trellis 2.0** and the model (requires **`Torch 2.8.0+cu128`** from the **Add-ons/Torch-Pack**)*  
- :small_orange_diamond: **Torch-Pack** - *Quick switching between:*  
  - ***Torch 2.7.1+cu128***  
  - ***Torch 2.8.0+cu128***  
  - ***Torch 2.9.1+cu130** (default, requires NVIDIA driver v580+)*  
- :small_orange_diamond: **Easy-model2GGUF** *(**Add-Ons/Tools**)*  
  - *Converts models (`.safetensors`, `.pth`, `.pt`) to **GGUF** format (FP16 or BF16)*  
  - *Quantizes models with options from **Q8_0** (highest quality) to **Q2_K** (smaller size)*  
  - *Applies **5D tensor fixes** if available*  
  - *For example, **flux1-dev.safetensors** (23 GB) converts to **flux1-dev-Q4_K_M.gguf** (6.5 GB) in **5 min.***  
- :small_orange_diamond: **Long-Paths-Enabler** *(**Add-Ons/Tools**)* - *Enables **Long Paths** in Windows 10/11*. Essential for Python/ComfyUI  
- :small_orange_diamond: **ComfyUI-Version-Switcher** *(**Add-Ons/Tools**)* - *Quick, **reversible** rollback to the **previous** ComfyUI version*  
- :small_orange_diamond: **ComfyUI-Version-Switcher** *(**Add-Ons/Tools**)* - ***Reversible** rollback to a **previous** ComfyUI version on issues*  
- :small_orange_diamond: **Update Easy-Install.bat** *(main folder)* - *Updates **Add-ons** and other folders. Creates desktop shortcuts*  

> [!IMPORTANT]
> - **Don't** run the installer as **Administrator**.
> - Avoid system folders (**Program Files**, **Windows**, **C:\\** root).
> - Make sure your NVIDIA drivers are up to date.

> [!TIP]
> - Multiple ComfyUI installs allowed without conflicts.
> - You can rename/move **`ComfyUI-Easy-Install`** folder after installation.

---

### [macOS / Linux Installation](https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux)

---

## Screenshots  

<img width="1193" height="643" alt="model2GGUF" src="https://github.com/user-attachments/assets/9704bd60-08ee-42aa-b0a3-8cab2fcbcef5" />
<img width="1264" height="440" alt="CEI" src="https://github.com/user-attachments/assets/bfd4912a-3a77-40a5-9cc2-bb2a45097ec8" />


---
Thank you for using **ComfyUI-Easy-Install**.  

If you enjoy my projects, please consider sponsoring me. Any support is greatly appreciated!  

<!-- [![Sponsor me on GitHub](https://img.shields.io/github/sponsors/Tavris1?label=Sponsor&logo=GitHub)](https://github.com/sponsors/Tavris1) -->  
❤️ Sponsor on GitHub: https://github.com/sponsors/Tavris1  
💜 Donate on PayPal: https://paypal.me/tavris1 [![Support me on PayPal](https://img.shields.io/badge/PayPal-Support-blue?logo=paypal)](https://paypal.me/tavris1)  
☕ Buy Me a Coffee: https://buymeacoffee.com/tavris1 [![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)  
