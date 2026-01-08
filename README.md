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

## Installation List:  
- [🔗](https://git-scm.com/) **Git** _(will be installed or updated if needed)_  
- [🔗](https://github.com/comfyanonymous/ComfyUI) **ComfyUI portable**  
- [🔗](https://www.python.org/downloads/release/python-31210/) **Python 3.12.10 Embedded**

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
[🔗](https://github.com/nunchaku-tech/ComfyUI-nunchaku) Nunchaku | [🔗](https://github.com/thu-ml/SageAttention) SageAttention 2.2.0 | [🔗](https://github.com/Dao-AILab/flash-attention) FlashAttention | [🔗](https://github.com/visualbruno/ComfyUI-Trellis2) Trellis 2.0 | [🔗](https://github.com/deepinsight/insightface) InsightFace

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
- :small_orange_diamond: **Easy-Models-Linker :sparkles:**  
  - _Creates **`extra_model_paths.yaml`** so you can use your existing **`MODELS`** folder without re-downloading_
  - _Some folders like **LLM** and **llm_gguf** cannot be redirected this way_
- :small_orange_diamond: **Nunchaku :sparkles:** _Installs **Nunchaku**, the latest **transformers** (Nunchaku downgraded it) and **numpy 1.26.4**_  
  - _If you encounter problems with Nunchaku later, simply start **Nunchaku.bat** again_
- :small_orange_diamond: **SageAttention :sparkles:** _Installs **Triton** and **SageAttention** v2.2.0 and creates **`Start ComfyUI SageAttention.bat`**_
- :small_orange_diamond: **FlashAttention :sparkles:** _Installs **Triton** and **FlashAttention** and creates **`Start ComfyUI FlashAttention.bat`**_
- :small_orange_diamond: **InsightFace :sparkles:** _Installs **InsightFace** with all modules (Pretrained models for non-commercial research only)_
- :small_orange_diamond: **Trellis2 :sparkles:** _Installs **Trellis 2.0** and the model (requires **`Torch 2.8.0+cu128`** from the **Add-ons/Torch-Pack**)_
- :small_orange_diamond: **Torch-Pack :sparkles:** _Quick switching between the following Torch versions:_
    - _**Torch 2.7.1+cu128**_
    - _**Torch 2.8.0+cu128**_
    - _**Torch 2.9.1+cu130** (default, requires NVIDIA driver v580 or higher)_
- :small_orange_diamond: **Easy-model2GGUF :sparkles:** _(located in **Add-Ons\Tools**)_
  - _Converts models (`.safetensors`, `.pth`, `.pt`) to **GGUF** format (FP16 or BF16)_
  - _Quantizes models with options from **Q8_0** (highest quality) to **Q2_K** (smaller size), default is **Q4_K_M**_
  - _Applies **5D tensor fixes** if available_  
  - _For example, **flux1-dev.safetensors** (23 GB) [🔗](https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors?download=true) can be converted to **flux1-dev-Q4_K_M.gguf** (6.5 GB) in **5 min.**_  
- :small_orange_diamond: **Long-Paths-Enabler :sparkles:** _(located in **Add-Ons\Tools**)_
  - _Enables **Long Paths** in Windows 10/11 (from 260 to 32,767 characters)_
  - _Prevents issues with models, custom nodes, and Python dependencies in ComfyUI_
  - _Checks current state, requests **admin rights only if needed**, and notifies about a restart_
- :small_orange_diamond: **Update Easy-Install.bat :sparkles:** _(located in **ComfyUI-Easy-Install** main folder)_
  - _Renames batch files to more user-friendly names **(one-time operation, ComfyUI-Easy-Install v1.x only)**_
  - _Adds all new features to **Add-ons**, **input folder**, **nodes folder**, and more_
  - _Fixes errors if necessary (mainly in the nodes folder)_
  - _Creates desktop shortcuts (custom icons by Ioan/Pixaroma)_
- :small_orange_diamond: **ComfyUI-Version-Switcher :sparkles:** _(located in **Add-Ons\Tools**)_
  - _Quick, **reversible** rollback to the **previous** ComfyUI version when the **latest** one causes issues_
<br>

> [!IMPORTANT]
> - Do **not** run the installer as **Administrator**.
> - Avoid system folders (**Program Files**, **Windows**, **C:\\** root).
> - Make sure your NVIDIA drivers are up to date.

> [!TIP]
> - This installation won't affect existing ComfyUI installs. Multiple ComfyUIs are supported.  
> - After installation, you can rename or move **`ComfyUI-Easy-Install`** folder if needed.  

---

### [macOS / Linux Installation](https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux)

---

## Screenshots  

<img width="1193" height="643" alt="model2GGUF" src="https://github.com/user-attachments/assets/9704bd60-08ee-42aa-b0a3-8cab2fcbcef5" />
<img width="1264" height="440" alt="CEI" src="https://github.com/user-attachments/assets/bfd4912a-3a77-40a5-9cc2-bb2a45097ec8" />


---
Thank you for using **ComfyUI-Easy-Install**.  

### [Support me on PayPal](https://paypal.me/tavris1)
[![Support me on-Paypal-blue](https://github.com/user-attachments/assets/c1a767b0-f3d9-48c7-877b-12653d2f9ac7)](https://paypal.me/tavris1)


