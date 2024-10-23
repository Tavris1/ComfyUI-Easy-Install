# ComfyUI-Easy-Install

> Dedicated to the **Pixaroma** team. [Discord Channel](https://discord.com/invite/gggpkVgBf3)

## General Information
ComfyUI-Easy-Install provides a portable Windows version of ComfyUI with basic nodes included.  
It’s ideal for safely testing ComfyUI nodes or quickly setting up a fresh instance.  
Installation typically takes 2-3 minutes, depending on your download speed.

## What ComfyUI-Easy-Install Does
> **Main modules:**
* Installs or updates **7-Zip** (if necessary)
* Installs or updates **Git** (if necessary)
* Installs **ComfyUI portable + Manager**
> **Installs the following Main Nodes:**
* Crystools
* rgthree
* Easy-Use
* was-node-suite
* GGUF
> **Installs additional nodes related to Pixaroma workflows**
* iTools
* controlnet_aux
* ControlAltAI-Nodes
* Florence2
* KJNodes
* tensorops
* Searge_LLM
* Eagleshadow
* Inspyrenet-Rembg
* seamless-tiling

## How to Use
- Download and Extract [ComfyUI-Easy-Install](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip) to the desired folder and run **ComfyUI-Easy-Install.bat**.
  - If you have a previous installation and wish to retain your settings, place these files alongside the installer.\
  They will be automatically copied into the appropriate '**ComfyUI**' folders.
    - **run_nvidia_gpu.bat**
    - **extra_model_paths.yaml**
    - **comfy.settings.json** (user/default)
    - **config.ini** (Manager)
    - **styles.json** (was-node-suite)
    - **was_suite_config.json** (was-node-suite)
    - **rgthree_config.json**
- If another '**ComfyUI_windows_portable**' folder is found, the Installer will **stop** to avoid conflicts.
  - Simply relocate the Installer to a different folder and rerun it.
- After installation, you can **move** or **rename** the '**ComfyUI_windows_portable**' folder.

## Screenshot
![ComfyUI-Easy-Install](https://github.com/user-attachments/assets/5b518a8e-1416-4b24-b03f-55534c615ead)
