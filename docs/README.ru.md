<a id="ru"></a>

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
    <strong>Установите портативную версию ComfyUI одним щелчком и управляйте её настройками в EZi Desktop.</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

<p align="center">
  <a href="#install">📥 <strong>Установить</strong></a> &nbsp;·&nbsp;
  <a href="#features">✨ Возможности</a> &nbsp;·&nbsp;
  <a href="#requirements">💻 Системные требования</a> &nbsp;·&nbsp;
  <a href="#help">🩺 Помощь</a> &nbsp;·&nbsp;
  <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
  <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
  <a href="#support">❤️ Поддержать</a>
</p>

<br>

![ComfyUI Screenshot](ComfyUI-ivo.png)

**Впервые пользуетесь EZi?** [Знакомство с EZi в комиксах](#comic)

</div>

<a id="features"></a>

## ✨ Возможности

**ComfyUI-Easy-Install** устанавливает портативную версию ComfyUI со встроенным Python, готовыми узлами и **EZi Desktop**.

- **Один щелчок** - Автоматическая настройка Git, Python, PyTorch, ComfyUI и узлов
- **Без ручной настройки** - Python, ComfyUI и модели в одной папке
- **Дополнения в один щелчок** - Nunchaku, SageAttention, FlashAttention, InsightFace и другие
- **EZi Desktop** - Отдельное окно с умной консолью и меню
  - Версии PyTorch/CUDA (Torch-Pack)
  - Версии ComfyUI и интерфейса
  - Папки моделей и папки Input/Output/User
  - Аргументы запуска и Dynamic VRAM
  - Настройки ComfyUI-Manager и закреплённые версии пакетов
  - Кеш UV/PIP и преобразование в GGUF
- **EZi Launcher** - Запуск, обновление, открытие папок, сохранение и восстановление снимков состояния

<details>
<summary><b>Что умеет EZi Desktop</b></summary>

- Запускает ComfyUI в отдельном окне, в браузере или сразу в обоих
- Уведомляет о новых версиях ComfyUI и EZi
- Сохраняет загруженные модели в нужную папку
- **Консоль**
  - Поиск (Ctrl+F) и сохранение журнала в .txt (Ctrl+S)
  - Вынос консоли в отдельное окно
  - Выделенный текст можно скопировать, сохранить, найти в Google или отправить с вопросом в Claude или ChatGPT
- **Захват экрана** - Снимки и видеозапись экрана
- **Папки моделей** - Подключение нескольких существующих папок
- **Выбор папок Input, Output и User**
- **Аргументы запуска** - Редактор со списком всех параметров
- **ComfyUI-Manager** - Новый или классический интерфейс, уровень безопасности, установка через pip и по URL Git
- **Управление версиями пакетов** - Закрепление версий, например `numpy==1.26.4`
- **Кеш пакетов** - Сохранение или очистка кеша UV/PIP
- **Сведения о системе** - GPU, RAM, Python, Torch, ComfyUI, длинные пути
- Темы, размер текста, подсказки и фон консоли
- Ссылки на схемы Pixaroma и курс по ComfyUI

</details>

---

<a id="requirements"></a>

## 💻 Системные требования

| | |
|---|---|
| **ОС** | Windows 10 / 11, 64-разрядная |
| **GPU** | NVIDIA RTX серии 20 или новее |
| **Драйвер** | NVIDIA 580 или новее (рекомендуется) |
| **RAM** | Минимум 8 ГБ, рекомендуется от 16 ГБ |
| **Диск** | Не менее 15 ГБ свободно плюс место для моделей (рекомендуется SSD) |
| **Internet** | Требуется во время установки |

> [!NOTE]
> Для драйверов старше по дате выпуска, чем версия **580**, установщик использует **CUDA 12.8** и **Torch 2.8.0**. Обновите драйвер для работы с **CUDA 13.0** и **Torch 2.11.0**.

---

<a id="install"></a>

## 🖥️ Установка в Windows

> [!IMPORTANT]
> - Используйте короткий путь с английскими буквами, например `D:\AI\`.

1. [**📥 Скачать последнюю версию**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Распакуйте ZIP в новую папку
3. Запустите **`ComfyUI-Easy-Install.bat`**
4. Дождитесь завершения установки
5. Нажмите **Start ComfyUI** или откройте ярлык **ComfyUI-EZi Launcher** на рабочем столе

<details>
<summary><b>Что будет установлено</b></summary>

| Компонент | Версия |
|---|---|
| [Git](https://git-scm.com/) | Последняя версия, только если Git отсутствует |
| [Python](https://www.python.org/downloads/release/python-31210/) | 3.12.10 Встроенная версия с проверкой контрольной суммы |
| PyTorch | 2.11.0 + CUDA 13.0 или 2.8.0 + CUDA 12.8 |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | Последняя версия |
| ComfyUI-Manager, Triton, ONNX Runtime GPU, llama-cpp-python | |
| [Встроенные узлы](#nodes) | Узлы из уроков Pixaroma |
| Схемы для знакомства с программой | Juggernaut Reborn, Z-Image Turbo |
| Примеры медиафайлов | В папке `ComfyUI\input` |
| ComfyUI-EZi Launcher | Ярлык на рабочем столе |

</details>

---

<a id="start"></a>

## ▶️ Запуск ComfyUI

Откройте **ComfyUI-EZi Launcher** и выберите режим.

- **Desktop** - В окне EZi Desktop
- **Browser** - В браузере с классической консолью
- **Hybrid** - В браузере с консолью EZi

Возможен запуск с **KitchenAttention**, **SageAttention** или **FlashAttention**. Для Sage и Flash сначала установите дополнение.

---

<a id="addons"></a>

## 🧩 Дополнения

Дополнения находятся в **Add-ons**. Большинство также доступно через **EZi Desktop > Menu**.

| Дополнение | Назначение |
|---|---|
| **Easy-Models-Linker** | Подключает существующую папку **models**.<br>Не поддерживает **LLM** и **llm_gguf**. |
| **Easy-System-Checker** | Показывает сведения об оборудовании и ПО |
| **Nunchaku** | Устанавливает [Nunchaku](https://github.com/nunchaku-ai/nunchaku) |
| **SageAttention-Multi** | Устанавливает [SageAttention](https://github.com/woct0rdho/SageAttention) v2.2.0 и v3 (v3 только для RTX 50) |
| **FlashAttention** | Устанавливает [FlashAttention](https://github.com/Dao-AILab/flash-attention) v2.8.3 |
| **InsightFace** | Устанавливает [InsightFace](https://github.com/deepinsight/insightface) |
| **Trellis2 + Pixal3D** | Устанавливает [Trellis 2.0 + Pixal3D @visualbruno](https://github.com/visualbruno/ComfyUI-Trellis2) и модель |
| **Torch-Pack** | Переключает версии PyTorch и CUDA |
| **Easy-model2GGUF** | Преобразует модели в GGUF (от Q2_K до Q8_0) |
| **Long-Paths-Enabler** | Включает поддержку длинных путей в Windows |
| **Toggle-DynamicVRAM** | Переключает параметр `--disable-dynamic-vram` |

<details>
<summary><b>Версии Torch-Pack и совместимость дополнений</b></summary>

| Torch | CUDA | Nunchaku | Sage v2 | Sage v3 | Flash | Trellis2 |
|---|---|:---:|:---:|:---:|:---:|:---:|
| 2.7.1 | 12.8 | ✅ | ✅ | ✅ | ✅ | |
| 2.8.0 | 12.8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2.9.1 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.10.0 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| **2.11.0** (по умолчанию) | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.12.1 | 13.0 | | ✅ | | ✅ | |
| 2.13.0 | 13.0 | | ✅ | | ✅ | |
| 2.14.1 | 13.0 | | ✅ | | ✅ | |

</details>

---

<a id="updates"></a>

## 🔄 Обновления

Обновляйте ComfyUI, узлы и EZi через лаунчер. Перед крупными изменениями сохраните снимок состояния, чтобы восстановить его одним щелчком.

---

<a id="help"></a>

## 🩺 Решение проблем

<details>
<summary><b>Установщик остановился или сообщает об ошибках</b></summary>

- Если установка прервалась, откройте **Show log** и скопируйте сведения через **Copy details** для отправки в [Discord Pixaroma](https://discord.gg/gggpkVgBf3).
- Полный журнал — `ComfyUI-Easy-Install.log`.
- Перед повторной попыткой удалите незавершённую папку `ComfyUI-Easy-Install`.

</details>

<details>
<summary><b>Windows 11: "Bad Image" (0xc0e90002)</b></summary>

- При ошибке Windows 11 «Bad Image» (0xc0e90002) отключите Smart App Control и перезапустите ComfyUI.
- Это ослабляет защиту от ненадёжных приложений.
- Прочитайте предупреждение Windows перед подтверждением.

</details>

<details>
<summary><b>Файлы отсутствуют или заблокированы</b></summary>

- Если пропали файлы, проверьте журнал защиты в разделе «Безопасность Windows».
- Разрешите заблокированные файлы Python, удалите папку и повторите установку.

</details>

<details>
<summary><b>Драйвер NVIDIA не обнаружен</b></summary>

- Если драйвер не обнаружен, установите свежую версию с [nvidia.com/drivers](https://www.nvidia.com/drivers) и проверьте команду `nvidia-smi` в терминале.

</details>

<details>
<summary><b>Неанглийские символы в пути или имени пользователя</b></summary>

- Переместите установщик в каталог вроде `D:\AI\`.
- Неанглийские символы в имени пользователя Windows всё равно могут вызывать проблемы.

</details>

<details>
<summary><b>"ComfyUI is already running"</b></summary>

- Сообщение «ComfyUI is already running» означает, что порт (по умолчанию 8188) занят.
- Закройте другое окно ComfyUI и попробуйте ещё раз.

</details>

<details>
<summary><b>Ошибки из-за длинных путей</b></summary>

- При ошибках из-за длинных путей запустите **Long-Paths-Enabler** из **Add-ons\Tools**.

</details>

---

<a id="uninstall"></a>

## 🧹 Удаление

Удалите папку `ComfyUI-Easy-Install` и ярлык **ComfyUI-EZi Launcher** с рабочего стола.

---

<a id="nodes"></a>

## 📦 Встроенные узлы

<details>
<summary><b>Узлы из уроков Pixaroma</b></summary>

| 🖼️ Изображения | 🎬 Видео | 🎵 Аудио | 🧩 Утилиты и схемы | 🤖 Модели |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [WanVideoWrapper](https://github.com/kijai/ComfyUI-WanVideoWrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | | [KJNodes](https://github.com/kijai/ComfyUI-KJNodes) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | [SeedVR2 VideoUpscaler](https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler) | | [iTools](https://github.com/MohammadAboulEla/ComfyUI-iTools) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI Nodes](https://github.com/gseth/ControlAltAI-Nodes) | |
| [Krea2Edit](https://github.com/lbouaraba/comfyui-krea2edit) | | | ✨[Pixaroma](https://gitlab.com/pixaroma/ComfyUI-Pixaroma) | |

</details>

---

<a id="comic"></a>

## 🎭 Знакомство с EZi в комиксах

Впервые пользуетесь EZi? Нажмите на любую картинку комикса, чтобы открыть её в полном размере.

<table width="100%">
  <tr>
    <th width="16.66%">Установка ComfyUI</th>
    <th width="16.66%">Лаунчер EZi</th>
    <th width="16.66%">Подключение моделей</th>
    <th width="16.66%">Установка дополнений</th>
    <th width="16.66%">Обновление и восстановление</th>
    <th width="16.66%">Ваша система</th>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6"><img src="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6" width="100%" alt="Установка ComfyUI"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9"><img src="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9" width="100%" alt="Лаунчер EZi"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901"><img src="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901" width="100%" alt="Подключение моделей"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b"><img src="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b" width="100%" alt="Установка дополнений"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6"><img src="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6" width="100%" alt="Обновление и восстановление"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3"><img src="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3" width="100%" alt="Ваша система"></a></td>
  </tr>
</table>

<div align="center">

<a id="support"></a>

## ❤️ Поддержать разработку

Если проект вам нравится, ваша поддержка поможет продолжить разработку.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
