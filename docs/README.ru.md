<a id="ru"></a>

<p align="center">
🌍 
<a href="../README.md#english">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<a href="README.de.md#de">Deutsch</a> |
<a href="README.fr.md#fr">Français</a> |
<strong>Русский</strong> |
<a href="README.tr.md#de">Türkçe</a> |
<a href="README.vi.md#vi">Tiếng Việt</a>
</p>

---

<div align="center">
  <img src="docs/EZi-Logo.svg" width="120" alt="EZi Logo">
  <h1>ComfyUI-Easy-Установка</h1>
  <p align="center">
    <strong>Портативный ComfyUI в один клик с EZi Desktop</strong><br />
    Windows • GPU NVIDIA • Community Edition Pixaroma
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/Tavris1/ComfyUI-Easy-Install/Windows/.github/badges/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

  <p align="center">
    <a href="#%EF%B8%8F-windows-installation">📥 Установка</a> &nbsp;·&nbsp;
    <a href="#-features">✨ Возможности/Компоненты</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-Установка/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#%EF%B8%8F-support-development">❤️ Поддержать разработку</a>
  </p>

---

![ComfyUI Screenshot](docs/ComfyUI-ivo.jpg)

</div>

## ✨ Возможности

****ComfyUI-Easy-Установка** предоставляет портативную среду ComfyUI вместе с **EZi Desktop**.  
Ручная настройка Python или Git не требуется.

Устанавливайте сложные пакеты, такие как Nunchaku, SageAttention, FlashAttention, InsightFace и Trellis 2.0, одним кликом.

Управляйте в одном месте **моделями, пакетами, версиями PyTorch/CUDA, Dynamic VRAM, версиями ComfyUI/frontend, кэшами UV/PIP и конвертацией в GGUF**.

## 📦 Включённые компоненты
<details open>
<summary><b>Основные компоненты</b></summary>

| 🔧 Компонент | 📝 Примечание |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - Последняя версия (установит/обновит при необходимости) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - Встроенная версия |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - Последняя стабильная версия |

</details>

<details>
<summary><b>Ноды, используемые в руководствах Pixaroma</b></summary>

| 🖼️ Изображение | 🎬 Видео | 🎵 Аудио | 🧩 Утилиты / WF | 🤖 Модели |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [ВидеоHelperSuite](https://github.com/Kosinkadink/ComfyUI-ВидеоHelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [WanВидеоWrapper](https://github.com/kijai/ComfyUI-WanВидеоWrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | [FishАудиоS2](https://github.com/Saganaki22/ComfyUI-FishАудиоS2) | [KJНоды](https://github.com/kijai/ComfyUI-KJНоды) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SeedVR2 ВидеоUpscaler](https://github.com/numz/ComfyUI-SeedVR2_ВидеоUpscaler) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | | | [iИнструменты](https://github.com/MohammadAboulEla/ComfyUI-iИнструменты) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI Ноды](https://github.com/gseth/ControlAltAI-Ноды) | |
| [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | | ✨[Pixaroma](https://github.com/pixaroma/ComfyUI-Pixaroma) | |
| | | | [Krea2T-Enhancer](https://github.com/capitan01R/ComfyUI-Krea2T-Enhancer) | |
| | | | [Krea2Edit](https://github.com/lbouaraba/comfyui-krea2edit) | |

</details>

<details>
<summary><b>Дополнительные компоненты и инструменты</b></summary>

| 🧩 Ноды | 🛠️ Инструменты |
|---|---|
| [Nunchaku](https://github.com/nunchaku-ai/nunchaku) | Easy-Модели-Linker |
| [SageAttention (v2.2.0 and v3)](https://github.com/woct0rdho/SageAttention) | Easy-System-Checker |
| [FlashAttention](https://github.com/Dao-AILab/flash-attention) | ComfyUI-Version-Switcher |
| [InsightFace](https://github.com/deepinsight/insightface) | Easy-model2GGUF |
| [Trellis 2.0](https://github.com/visualbruno/ComfyUI-Trellis2) | Long-Paths-Enabler |
| | Torch-Pack |
| | Toggle-DynamicVRAM |
| | Update Easy-Установка |

</details>

---

## 🖥️ Установка Windows

> [!IMPORTANT]
> - Не запускайте установщик от имени **Администратора**.
> - Избегайте системных папок (`Program Files`, `Windows`, корень `C:\`).
> - Избегайте пробелов и специальных символов в именах папок.
> - Убедитесь, что драйверы NVIDIA обновлены.

1. [**📥 СКАЧАТЬ ПОСЛЕДНЮЮ ВЕРСИЮ**](https://github.com/Tavris1/ComfyUI-Easy-Установка/releases/latest/download/ComfyUI-Easy-Установка.zip)
2. Распакуйте ZIP-файл в новую папку и запустите **`ComfyUI-Easy-Установка.bat`**
3. После установки при необходимости устанавливайте или запускайте компоненты из папки **Add-ons** или **EZi Desktop Menu**:
    - **Easy-Модели-Linker** - *Использует существующую папку **MODELS** через **extra_model_paths.yaml**, повторная загрузка не требуется*
      - *Некоторые папки, например **LLM** и **llm_gguf**, нельзя перенаправить таким способом*
    - **Easy-System-Checker** - *Предоставляет информацию об основных аппаратных и программных компонентах*
    - **Nunchaku** - *Устанавливает Nunchaku. (При возникновении проблем позже снова запустите `Nunchaku.bat`)*
    - **SageAttention-Multi** - *Устанавливает SageAttention v2.2.0 и v3 (v3 работает только на GPU NVIDIA 50-й серии)*
    - **FlashAttention** - *Устанавливает FlashAttention v2.8.3*
    - **InsightFace** - *Устанавливает InsightFace (предобученные модели только для некоммерческих исследований)*
    - **Trellis2** - *Устанавливает Trellis 2.0 и модель (требуется `Torch 2.8.0+cu128` из `Add-ons/Torch-Pack`)*
    - **Torch-Pack** - *Быстрое переключение между:*  
      - *`Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`, `Torch 2.9.1+cu130`, `Torch 2.10+cu130` & `Torch 2.11+cu130`*
    - **Easy-model2GGUF** - *Конвертирует и квантует модели в GGUF (Q2_K–Q8_0), исправляя 5D-тензоры, если это возможно*
    - **Long-Paths-Enabler** - *Включает **длинные пути** в Windows 10/11. Необходимо для Python/ComfyUI*
    - **ComfyUI-Version-Switcher** - *Позволяет **обратимо** откатиться к **предыдущей** версии ComfyUI при возникновении проблем*
    - **Toggle-DynamicVRAM** - *Переключает опцию **--disable-dynamic-vram** в файлах запуска ComfyUI*
    - **Update Easy-Установка** - *Обновляет **Add-ons** и другие папки. Создаёт ярлыки на рабочем столе*
    - **EZi Desktop Themes** - *через EZi Desktop > Menu > Advanced*
    - **Пользовательские папки Input, Output и User** - *через EZi Desktop > Menu > Advanced*
    - **Переключатель версий ComfyUI и frontend** - *через EZi Desktop > Menu > Advanced*
    - **Очистка кэша UV и PIP** - *через EZi Desktop > Menu*
    - **ComfyUI-Manager Security-Level Config** - *Простая настройка security_level через EZi Desktop > Menu*
    - **Pinned-Packages-Manager** - *Фиксация версий пакетов, например NumPy==1.26.4, через EZi Desktop > Menu*

<div align="center">

---

## ❤️ Поддержать разработку

Вам нравится проект?  
Если проект экономит ваше время, ваша поддержка помогает продолжать разработку и обслуживание.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/Tavris1?style=for-the-badge&logo=github)](https://github.com/sponsors/Tavris1)

</div>
