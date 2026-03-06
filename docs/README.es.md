<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<strong>Español</strong> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<a href="README.ru.md#ru">Русский</a> |
<a href="README.de.md#de">Deutsch</a> |
<a href="README.fr.md#fr">Français</a> |
<a href="README.vi.md#vi">Tiếng Việt</a>
</p>

---

# ComfyUI-Easy-Install
> **ComfyUI** portátil con un solo clic para **Windows** 🔹 GPUs Nvidia 🔹 Edición Comunidad Pixaroma 🔹  
> [![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
> [![GitHun Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
> [![Github All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)]()
> [![GitHub Downloads latest)](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=downloads%40latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
>
> Dedicado al equipo de **Pixaroma**  
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Join%20Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_presence_count&logo=discord&logoColor=white&label=Online&color=blue&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)

---

## Componentes incluidos:  
- **Git** *(se instalará o actualizará si es necesario)*  
- **ComfyUI portátil**  
- **Python 3.12.10** *(versión portátil integrada)*  

### Nodos de los tutoriales de Pixaroma en [YouTube](https://www.youtube.com/@pixaroma)

|||||||
|---|---|---|---|---|---|
ComfyUI Manager | Tiled Diffusion & VAE | SCAIL-Pose | KJNodes | rgthree | iTools
MelBandRoFormer | Inpaint-CropAndStitch | Qwen3-TTS | Easy-Use | QwenVL | GGUF
VideoHelperSuite | SeedVR2_VideoUpscaler | ControlNet Aux | LayerStyle | Easy-Sam3 | RMBG
WanVideoWrapper | WanAnimatePreprocess | Comfyroll Studio

### Nodos adicionales opcionales
||||||
|---|---|---|---|---|
Nunchaku | SageAttention-Multi (v2.2.0 and v3) | FlashAttention | Trellis 2.0 | InsightFace

### Herramientas adicionales
||||||
|---|---|---|---|---|
Easy-Models-Linker | Torch-Pack | Easy-model2GGUF | Long-Paths-Enabler | ComfyUI-Version-Switcher

---

## Instalación en Windows
1. Descarga la [:arrow_forward:**última versión AQUÍ**◀️](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Extrae el archivo ZIP en una nueva carpeta y ejecuta **`ComfyUI-Easy-Install.bat`** para iniciar la instalación
3. Después de la instalación, puedes instalar o ejecutar opcionalmente los siguientes componentes desde la carpeta **Add-ons**:
    - **Easy-Models-Linker** - *Usa la carpeta **MODELS** existente mediante **extra_model_paths.yaml**, no requiere nueva descarga*
      - *Algunas carpetas como **LLM** y **llm_gguf** no pueden redirigirse de esta manera*
    - **Nunchaku** - *Instala Nunchaku. Ejecuta `Nunchaku.bat` nuevamente si aparecen problemas más adelante*
    - **SageAttention-Multi** - *Instala SageAttention v2.2.0 y v3 (v3 efectivo solo en GPUs NVIDIA serie 50)*
    - **FlashAttention** - *Instala FlashAttention v2.8.3*
    - **InsightFace** - *Instala InsightFace (modelos preentrenados solo para investigación no comercial)*
    - **Trellis2** - *Instala Trellis 2.0 y el modelo (requiere `Torch 2.8.0+cu128` desde `Add-ons/Torch-Pack`)*
    - **Torch-Pack** - *Cambio rápido entre:*
      - ***Torch 2.7.1+cu128***
      - ***Torch 2.8.0+cu128***
      - ***Torch 2.9.1+cu130** (predeterminado, requiere controlador NVIDIA v580+)*  
    - **Easy-model2GGUF** *(**Add-Ons/Tools**)*  
      - *Convierte modelos (`.safetensors`, `.pth`, `.pt`) al formato **GGUF** (FP16 o BF16) en pocos minutos*  
      - *Cuantiza modelos con opciones desde **Q2_K** hasta **Q8_0** y aplica **correcciones de tensor 5D** si están disponibles*  
    - **Long-Paths-Enabler** *(`Add-Ons/Tools`)* - *Habilita **Long Paths** en Windows 10/11. Esencial para Python/ComfyUI*  
    - **ComfyUI-Version-Switcher** *(`Add-Ons/Tools`)* - ***Reversión** a una versión **anterior** de ComfyUI en caso de problemas*  
    - **Toggle-DynamicVRAM** *(`Add-Ons/Tools`)* - *Activa o desactiva la opción **--disable-dynamic-vram** en los archivos de inicio de ComfyUI*  
    - **Update Easy-Install.bat** *(carpeta principal)* - *Actualiza **Add-ons** y otras carpetas. Crea accesos directos en el escritorio*  

> [!IMPORTANT]
> - No ejecutes el instalador como **Administrador**.
> - Evita carpetas del sistema (`Program Files`, `Windows`, raíz `C:\`).
> - Evita espacios y caracteres especiales en los nombres de carpetas.
> - Asegúrate de que tus controladores NVIDIA estén actualizados.

> [!TIP]
> - Se permiten múltiples instalaciones de ComfyUI sin conflictos.
> - Puedes renombrar o mover la carpeta `ComfyUI-Easy-Install` después de la instalación.
> - Para macOS / Linux haz clic [here](https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux)

---

<img width="1038" height="240" alt="123321" src="https://github.com/user-attachments/assets/6d0655ef-8724-4cb1-bce2-a29fc9004173" />

---

Si disfrutas mis proyectos, considera apoyarme. ¡Cualquier apoyo es muy apreciado!

💜 PayPal: https://paypal.me/tavris1  
☕ Buy Me a Coffee: https://buymeacoffee.com/tavris1  
❤️ GitHub Sponsors: https://github.com/sponsors/Tavris1  
