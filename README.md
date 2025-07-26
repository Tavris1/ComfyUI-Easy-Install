# ComfyUI-Easy-Install  
> Portable **ComfyUI** for **Windows**, **macOS** and **Linux**  🔹 Pixaroma Community Edition 🔹  
> [![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
> [![GitHun Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
> [![Github All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)]()
> [![GitHub Downloads latest)](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=downloads%40latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
>
> Dedicated to the **Pixaroma** team  
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Join%20Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)  
---

## What will be installed  
- [**Git**](https://git-scm.com/) will be installed/updated if required  
- [**ComfyUI portable**](https://github.com/comfyanonymous/ComfyUI)  
- [**Python 3.11.9 Embedded**](https://www.python.org/downloads/release/python-3119/)

## Nodes from Pixaroma tutorials [:arrow_forward:YouTube](https://www.youtube.com/@pixaroma)  
- [ComfyUI-Manager](https://github.com/Comfy-Org/ComfyUI-Manager)  
- [was-node-suite](https://github.com/WASasquatch/was-node-suite-comfyui)  
- [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use)  
- [controlnet_aux](https://github.com/Fannovel16/comfyui_controlnet_aux)  
- [Comfyroll Studio](https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes)  
- [Crystools](https://github.com/crystian/ComfyUI-Crystools)  
- [rgthree](https://github.com/rgthree/rgthree-comfy)  
- [GGUF](https://github.com/city96/ComfyUI-GGUF)  
- [Florence2](https://github.com/kijai/ComfyUI-Florence2)  
- [Searge_LLM](https://github.com/SeargeDP/ComfyUI_Searge_LLM)  
- [ControlAltAI-Nodes](https://github.com/gseth/ControlAltAI-Nodes)  
- [Ollama](https://github.com/stavsap/comfyui-ollama)  
- [iTools](https://github.com/MohammadAboulEla/ComfyUI-iTools)  
- [seamless-tiling](https://github.com/spinagon/ComfyUI-seamless-tiling)  
- [Inpaint-CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch)  
- [canvas_tab](https://github.com/Lerc/canvas_tab)  
- [OmniGen](https://github.com/1038lab/ComfyUI-OmniGen)  
- [Inspyrenet-Rembg](https://github.com/john-mnz/ComfyUI-Inspyrenet-Rembg)  
- [AdvancedReduxControl](https://github.com/kaibioinfo/ComfyUI_AdvancedRefluxControl)  
- [VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite)  
- [AdvancedLivePortrait](https://github.com/PowerHouseMan/ComfyUI-AdvancedLivePortrait)  
- [ComfyUI-ToSVG](https://github.com/Yanick112/ComfyUI-ToSVG)  
- [Kokoro](https://github.com/stavsap/comfyui-kokoro)  
- [Janus-Pro](https://github.com/CY-CHENYUE/ComfyUI-Janus-Pro)  
- [Sonic](https://github.com/smthemex/ComfyUI_Sonic)  
- [TeaCache](https://github.com/welltop-cn/ComfyUI-TeaCache)  
- [KayTool](https://github.com/kk8bit/KayTool)  
- [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion)  
- [LTXVideo](https://github.com/Lightricks/ComfyUI-LTXVideo)  
- [KJNodes](https://github.com/kijai/ComfyUI-KJNodes)

## Optional modules (**Add-ons** subfolder)  
- [Nunchaku](https://github.com/mit-han-lab/ComfyUI-nunchaku)
- [SageAttention 2.2.0](https://github.com/thu-ml/SageAttention)

---
## Windows Installation in 3 Steps
1. Download the latest release [:arrow_forward:HERE](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)  
2. Extract the ZIP file into a new folder  
3. Double-click **`ComfyUI-Easy-Install.bat`** to start the setup
- After installation, run the desired **`.bat`** file in the **`Add-ons`** folder to install optional modules  

> [!IMPORTANT]
>> - Do **not** extract to system-protected folders such as **`Program Files`**, **`Windows`**, or directly to **`C:\`**
>> - Do **not** use **`Run as Аdministrator`** when launching the installer

> [!NOTE]
>> - This installation won't affect existing ComfyUI installs. Multiple ComfyUIs are supported.  
>> - After installation, you can rename or move **`ComfyUI-Easy-Install`** folder if needed.  

> [!TIP]
>> - To keep settings from other ComfyUIs, place these files in the installer folder  
> They will be copied automatically to the appropriate folders:  
>       - `run_nvidia_gpu.bat`  
>       - `extra_model_paths.yaml` (refer to [**Extra Model Paths Maker**](https://github.com/Tavris1/ComfyUI-Easy-Install/tree/main#extra-model-paths-maker-open_file_folder) :open_file_folder:)  
>       - `comfy.settings.json` (user/default)  
>       - `was_suite_config.json` (custom_nodes/was-node-suite-comfyui)  
>       - `rgthree_config.json` (custom_nodes/rgthree-comfy)  

---

### Extra Model Paths Maker :open_file_folder:  

1. Place **Extra_Model_Paths_Maker.bat** in your existing **models** folder and run it.  
This generates an organized `extra_model_paths.yaml` listing all subfolders in the directory.  
2. Move `extra_model_paths.yaml` to your new **ComfyUI** folder.  
This allows ComfyUI to use your existing model files without additional downloads.  

> [!NOTE]
>> - Some folders like **LLM** and **llm_gguf** cannot be redirected this way.  

---

## macOS / Linux - click [:arrow_forward:HERE](https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux)

---

## Screenshot  
![End](https://github.com/user-attachments/assets/da090bd5-0e13-41e1-8a81-bf2d24a8632c)  

---
Thank you for using **ComfyUI-Easy-Install**!  
Questions or feedback? Reach out on [Pixaroma Discord](https://discord.com/invite/gggpkVgBf3)

### [Support me on PayPal](https://paypal.me/tavris1)
[![Support me on-Paypal-blue](https://github.com/user-attachments/assets/c1a767b0-f3d9-48c7-877b-12653d2f9ac7)](https://paypal.me/tavris1)  
