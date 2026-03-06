<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<strong>Русский</strong> |
<a href="README.de.md#de">Deutsch</a> |
<a href="README.fr.md#fr">Français</a> |
<a href="README.vi.md#vi">Tiếng Việt</a>
</p>

---

# ComfyUI-Easy-Install
> Портативный **ComfyUI** в один клик для **Windows** 🔹 Nvidia GPU 🔹 Редакция сообщества Pixaroma 🔹  
> [![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
> [![GitHun Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
> [![Github All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)]()
> [![GitHub Downloads latest)](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=downloads%40latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
>
> Посвящается команде **Pixaroma**  
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Join%20Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_presence_count&logo=discord&logoColor=white&label=Online&color=blue&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)

---

## Включённые компоненты:  
- **Git** *(будет установлен или обновлён при необходимости)*  
- **ComfyUI portable**  
- **Python 3.12.10** *(встроенная портативная версия)*  

### Ноды из туториалов Pixaroma на [YouTube](https://www.youtube.com/@pixaroma)

|||||||
|---|---|---|---|---|---|
ComfyUI Manager | Tiled Diffusion & VAE | SCAIL-Pose | KJNodes | rgthree | iTools
MelBandRoFormer | Inpaint-CropAndStitch | Qwen3-TTS | Easy-Use | QwenVL | GGUF
VideoHelperSuite | SeedVR2_VideoUpscaler | ControlNet Aux | LayerStyle | Easy-Sam3 | RMBG
WanVideoWrapper | WanAnimatePreprocess | Comfyroll Studio

### Дополнительные опциональные ноды
||||||
|---|---|---|---|---|
Nunchaku | SageAttention-Multi (v2.2.0 and v3) | FlashAttention | Trellis 2.0 | InsightFace

### Дополнительные инструменты
||||||
|---|---|---|---|---|
Easy-Models-Linker | Torch-Pack | Easy-model2GGUF | Long-Paths-Enabler | ComfyUI-Version-Switcher

---

## Установка в Windows
1. Скачайте [:arrow_forward:**последнюю версию ЗДЕСЬ**◀️](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Распакуйте ZIP-файл в новую папку и запустите **`ComfyUI-Easy-Install.bat`** для начала установки
3. После установки вы можете при необходимости установить или запустить следующие компоненты из папки **Add-ons**:
    - **Easy-Models-Linker** - *Использует существующую папку **MODELS** через **extra_model_paths.yaml**, повторная загрузка не требуется*
      - *Некоторые папки, такие как **LLM** и **llm_gguf**, нельзя перенаправить этим способом*
    - **Nunchaku** - *Устанавливает Nunchaku. При возникновении проблем позже запустите `Nunchaku.bat` снова*
    - **SageAttention-Multi** - *Устанавливает SageAttention v2.2.0 и v3 (v3 работает только на GPU NVIDIA серии 50)*
    - **FlashAttention** - *Устанавливает FlashAttention v2.8.3*
    - **InsightFace** - *Устанавливает InsightFace (предобученные модели только для некоммерческих исследований)*
    - **Trellis2** - *Устанавливает Trellis 2.0 и модель (требуется `Torch 2.8.0+cu128` из `Add-ons/Torch-Pack`)*
    - **Torch-Pack** - *Быстрое переключение между:*
      - ***Torch 2.7.1+cu128***
      - ***Torch 2.8.0+cu128***
      - ***Torch 2.9.1+cu130** (по умолчанию, требуется драйвер NVIDIA v580+)*  
    - **Easy-model2GGUF** *(**Add-Ons/Tools**)*  
      - *Преобразует модели (`.safetensors`, `.pth`, `.pt`) в формат **GGUF** (FP16 или BF16) за несколько минут*  
      - *Выполняет квантование моделей от **Q2_K** до **Q8_0** и применяет исправления **5D tensor**, если доступны*  
    - **Long-Paths-Enabler** *(`Add-Ons/Tools`)* - *Включает **Long Paths** в Windows 10/11. Важно для Python/ComfyUI*  
    - **ComfyUI-Version-Switcher** *(`Add-Ons/Tools`)* - ***Обратимый** откат к **предыдущей** версии ComfyUI при возникновении проблем*  
    - **Toggle-DynamicVRAM** *(`Add-Ons/Tools`)* - *Переключает параметр **--disable-dynamic-vram** в файлах запуска ComfyUI*  
    - **Update Easy-Install.bat** *(основная папка)* - *Обновляет **Add-ons** и другие папки. Создаёт ярлыки на рабочем столе*  

> [!IMPORTANT]
> - Не запускайте установщик от имени **Администратора**.
> - Избегайте системных папок (`Program Files`, `Windows`, корень `C:\`).
> - Избегайте пробелов и специальных символов в названиях папок.
> - Убедитесь, что драйверы NVIDIA обновлены.

> [!TIP]
> - Разрешены несколько установок ComfyUI без конфликтов.
> - После установки можно переименовать или переместить папку `ComfyUI-Easy-Install`.
> - Для macOS / Linux нажмите [here](https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux)

---

<img width="1038" height="240" alt="123321" src="https://github.com/user-attachments/assets/6d0655ef-8724-4cb1-bce2-a29fc9004173" />

---

Если вам нравятся мои проекты, пожалуйста, поддержите меня. Любая поддержка очень ценится!

💜 PayPal: https://paypal.me/tavris1  
☕ Buy Me a Coffee: https://buymeacoffee.com/tavris1  
❤️ GitHub Sponsors: https://github.com/sponsors/Tavris1  
