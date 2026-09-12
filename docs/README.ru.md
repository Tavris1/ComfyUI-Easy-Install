<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<a href="README.de.md#de">Deutsch</a> |
<a href="README.fr.md#fr">Français</a> |
<strong>Русский</strong> |
<a href="README.tr.md#tr">Türkçe</a> |
<a href="README.vi.md#vi">Tiếng Việt</a>
</p>

---

<div align="center">
  <img src="EZi-Logo.svg" width="120" alt="EZi Logo">
  <h1>ComfyUI-Easy-Install</h1>
  <p align="center">
    <strong>Портативный ComfyUI в один клик с EZi Desktop: полноценная панель управления пакетами, окружениями и конфигурацией</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)


<!--[![GitHub All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)-->
<!--[![GitHub Downloads Latest](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=⬇+latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)-->

  <p align="center">
    <a href="#%EF%B8%8F-установка-windows">📥 Установка</a> &nbsp;·&nbsp;
    <a href="#-возможности">✨ Возможности/Компоненты</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#%EF%B8%8F-поддержать-разработку">❤️ Поддержать разработку</a>
  </p>

<!-- Посвящается сообществу **Pixaroma**  
[![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
-->

---

![ComfyUI Screenshot](ComfyUI-ivo.jpg)

</div>

## ✨ Возможности

**ComfyUI-Easy-Install** предоставляет портативную среду ComfyUI с **EZi Desktop**.  
Ручная настройка Python или Git не требуется.

Устанавливайте сложные пакеты, такие как Nunchaku, SageAttention, FlashAttention, InsightFace и Trellis 2.0, одним кликом.

Управляйте **моделями, пакетами, версиями PyTorch/CUDA, Dynamic VRAM,  
версиями ComfyUI/frontend, кэшами UV/PIP и конвертацией GGUF** из одного места.

## 📦 Включённые компоненты
<details open>
<summary><b>Основные компоненты</b></summary>

| 🔧 Компонент | 📝 Примечание |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - Последняя версия (при необходимости будет установлена/обновлена) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - Встроенная версия |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - Последняя стабильная версия |

</details>

<details>
<summary><b>Nodes, используемые в руководствах Pixaroma</b></summary>

| 🖼️ Изображение | 🎬 Видео | 🎵 Аудио | 🧩 Utility / WF | 🤖 Модели |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [WanVideoWrapper](https://github.com/kijai/ComfyUI-WanVideoWrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | [FishAudioS2](https://github.com/Saganaki22/ComfyUI-FishAudioS2) | [KJNodes](https://github.com/kijai/ComfyUI-KJNodes) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SeedVR2 VideoUpscaler](https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | | | [iTools](https://github.com/MohammadAboulEla/ComfyUI-iTools) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI Nodes](https://github.com/gseth/ControlAltAI-Nodes) | |
| [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | | ✨[Pixaroma](https://github.com/pixaroma/ComfyUI-Pixaroma) | |
| | | | [Krea2T-Enhancer](https://github.com/capitan01R/ComfyUI-Krea2T-Enhancer) | |
| | | | [Krea2Edit](https://github.com/lbouaraba/comfyui-krea2edit) | |

</details>

<details>
<summary><b>Дополнительные Add-ons & Tools</b></summary>

| 🧩 Nodes | 🛠️ Tools |
|---|---|
| [Nunchaku](https://github.com/nunchaku-ai/nunchaku) | Easy-Models-Linker |
| [SageAttention (v2.2.0 and v3)](https://github.com/woct0rdho/SageAttention) | Easy-System-Checker |
| [FlashAttention](https://github.com/Dao-AILab/flash-attention) | ComfyUI-Version-Switcher |
| [InsightFace](https://github.com/deepinsight/insightface) | Easy-model2GGUF |
| [Trellis 2.0](https://github.com/visualbruno/ComfyUI-Trellis2) | Long-Paths-Enabler |
| | Torch-Pack |
| | Toggle-DynamicVRAM |
| | Update Easy-Install |

</details>

---

## 🖥️ Установка Windows

> [!IMPORTANT]
> - Не запускайте установщик от имени **Administrator**.
> - Избегайте системных папок (`Program Files`, `Windows`, `C:\` root).
> - Избегайте пробелов и специальных символов в именах папок.
> - Убедитесь, что ваши драйверы NVIDIA обновлены.

1. [**📥 СКАЧАТЬ ПОСЛЕДНЮЮ ВЕРСИЮ**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Распакуйте ZIP-файл в новую папку и запустите **`ComfyUI-Easy-Install.bat`**
3. После установки при необходимости установите или запустите компоненты из папки **Add-ons** или **EZi Desktop Menu**:
    - **Easy-Models-Linker** - *Использует существующую папку **MODELS** через **extra_model_paths.yaml**, повторная загрузка не требуется*
      - *Некоторые папки, такие как **LLM** и **llm_gguf**, невозможно перенаправить таким способом*
    - **Easy-System-Checker** - *Предоставляет информацию об основных аппаратных и программных компонентах*
    - **Nunchaku** - *Устанавливает Nunchaku*
    - **SageAttention-Multi** - *Устанавливает SageAttention v2.2.0 и v3 (v3 эффективен только на NVIDIA 50-series GPUs)*
    - **FlashAttention** - *Устанавливает FlashAttention v2.8.3*
    - **InsightFace** - *Устанавливает InsightFace (Pretrained models for non-commercial research only)*
    - **Trellis2** - *Устанавливает Trellis 2.0 и модель (требуется `Torch 2.8.0+cu128` из `Add-ons/Torch-Pack`)*
    - **Torch-Pack** - *Быстрое переключение между:`Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`,  
      `Torch 2.9.1+cu130`, `Torch 2.10+cu130`, `Torch 2.11+cu130`, `Torch 2.12.1+cu130` & `Torch 2.13.0+cu130`*
    - **Easy-model2GGUF** - *Конвертирует и квантизирует модели в GGUF (Q2_K–Q8_0) с исправлениями для 5D-тензоров, если они доступны*
    - **Long-Paths-Enabler** - *Включает **Long Paths** в Windows 10/11. Необходимо для Python/ComfyUI*
    - **ComfyUI-Version-Switcher** - ***Обратимый** откат к **предыдущей** версии ComfyUI в случае возникновения проблем*
    - **Toggle-DynamicVRAM** - *Включает/выключает параметр **--disable-dynamic-vram** в файлах запуска ComfyUI*
    - **Update Easy-Install** - *Обновляет **Add-ons** и другие папки. Создаёт ярлыки на рабочем столе*
    - **EZi Desktop Themes** - *через EZi Desktop > Menu > Advanced*
    - **Custom Input, Output & User folders** - *через EZi Desktop > Menu > Advanced*
    - **ComfyUI & Frontend Version Changer** - *через EZi Desktop > Menu > Advanced*
    - **UV & PIP cache cleaner** - *через EZi Desktop > Menu*
    - **ComfyUI-Manager Security-Level Config** - *Простая настройка security_level через EZi Desktop > Menu*
    - **Pinned-Packages-Manager** - *Фиксирует версии пакетов, например NumPy==1.26.4, через EZi Desktop > Menu*

<div align="center">

---

## ❤️ Поддержать разработку

Нравится проект?  
Если он экономит ваше время, ваша поддержка помогает продолжать разработку и обслуживание.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
