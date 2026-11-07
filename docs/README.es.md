<a id="es"></a>

<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<strong>Español</strong> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<a href="README.de.md#de">Deutsch</a> |
<a href="README.fr.md#fr">Français</a> |
<a href="README.ru.md#ru">Русский</a> |
<a href="README.tr.md#tr">Türkçe</a> |
<a href="README.vi.md#vi">Tiếng Việt</a>
</p>

---

<div align="center">
  <img src="EZi-Logo.svg" width="120" alt="EZi Logo">
  <h1>ComfyUI-Easy-Install</h1>
  <p align="center">
    <strong>Instala ComfyUI portátil con un clic y adminístralo y personalízalo desde EZi Desktop.</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

<p align="center">
  <a href="#install">📥 <strong>Instalar</strong></a> &nbsp;·&nbsp;
  <a href="#features">✨ Funciones</a> &nbsp;·&nbsp;
  <a href="#requirements">💻 Requisitos</a> &nbsp;·&nbsp;
  <a href="#help">🩺 Ayuda</a> &nbsp;·&nbsp;
  <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
  <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
  <a href="#support">❤️ Apoyar</a>
</p>

<br>

![ComfyUI Screenshot](ComfyUI-ivo.png)

**¿Es tu primera vez con EZi?** [Guía ilustrada de EZi](#comic)

</div>

<a id="features"></a>

## ✨ Funciones

**ComfyUI-Easy-Install** instala una versión portátil de ComfyUI con su propio Python, nodos listos para usar y **EZi Desktop**.

- **Un clic** - Configuración automática de Git, Python, PyTorch, ComfyUI y los nodos
- **Sin configuración manual** - Python, ComfyUI y los modelos en una carpeta
- **Complementos con un clic** - Nunchaku, SageAttention, FlashAttention, InsightFace y más
- **EZi Desktop** - Ventana propia con consola inteligente y menú
  - Versiones de PyTorch/CUDA (Torch-Pack)
  - Versiones de ComfyUI y de la interfaz
  - Carpetas de modelos y de Input/Output/User
  - Argumentos de inicio y VRAM dinámica
  - Ajustes de ComfyUI-Manager y paquetes con versión fija
  - Caché de UV/PIP y conversión a GGUF
- **EZi Launcher** - Inicia, actualiza, abre carpetas y guarda o restaura instantáneas

<details>
<summary><b>Qué puedes hacer con EZi Desktop</b></summary>

- Ejecutar ComfyUI en su ventana, en el navegador o en ambos
- Recibir avisos de nuevas versiones de ComfyUI y EZi
- Descargar los modelos directamente en la carpeta adecuada
- **Consola**
  - Buscar (Ctrl+F) y guardar el registro como .txt (Ctrl+S)
  - Separarla en otra ventana
  - Copiar o guardar la selección, buscarla en Google o consultar a Claude o ChatGPT
- **Captura** - Capturas de pantalla o grabación de vídeo
- **Carpetas de modelos** - Vincular varias carpetas existentes
- **Carpetas Input, Output y User personalizadas**
- **Argumentos de inicio** - Editor con todas las opciones
- **ComfyUI-Manager** - Interfaz nueva o clásica, nivel de seguridad e instalaciones por pip o URL de Git
- **Gestor de versiones fijas** - Fija versiones como `numpy==1.26.4`
- **Caché de paquetes** - Conserva o vacía la caché de UV/PIP
- **Información del sistema** - GPU, RAM, Python, Torch, ComfyUI, rutas largas
- Temas, tamaño del texto, ayudas y fondo de consola
- Enlaces a los flujos y al curso de ComfyUI de Pixaroma

</details>

---

<a id="requirements"></a>

## 💻 Requisitos

| | |
|---|---|
| **Sistema operativo** | Windows 10 / 11, 64 bits |
| **GPU** | NVIDIA RTX serie 20 o posterior |
| **Controlador** | NVIDIA 580 o posterior (recomendado) |
| **RAM** | Mínimo 8 GB, se recomiendan 16 GB o más |
| **Disco** | Al menos 15 GB libres más espacio para los modelos (SSD recomendado) |
| **Internet** | Necesario durante la instalación |

> [!NOTE]
> Con un controlador anterior a **580** se instalan **CUDA 12.8** y **Torch 2.8.0**. Actualízalo para usar **CUDA 13.0** y **Torch 2.11.0**.

---

<a id="install"></a>

## 🖥️ Instalación en Windows

> [!IMPORTANT]
> - Usa una ruta corta con caracteres ingleses, como `D:\AI\`.

1. [**📥 Descargar la última versión**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Extrae el ZIP en una carpeta nueva
3. Ejecuta **`ComfyUI-Easy-Install.bat`**
4. Espera a que termine el instalador
5. Pulsa **Start ComfyUI** o abre el acceso directo **ComfyUI-EZi Launcher** del escritorio

<details>
<summary><b>Qué se instala</b></summary>

| Componente | Versión |
|---|---|
| [Git](https://git-scm.com/) | Última versión, solo si falta Git |
| [Python](https://www.python.org/downloads/release/python-31210/) | 3.12.10 Integrado, con suma de comprobación verificada |
| PyTorch | 2.11.0 + CUDA 13.0 o 2.8.0 + CUDA 12.8 |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | Última versión |
| ComfyUI-Manager, Triton, ONNX Runtime GPU, llama-cpp-python | |
| [Nodos incluidos](#nodes) | Nodos de los tutoriales de Pixaroma |
| Flujos de iniciación | Juggernaut Reborn, Z-Image Turbo |
| Archivos de ejemplo | En la carpeta `ComfyUI\input` |
| ComfyUI-EZi Launcher | Acceso directo en el escritorio |

</details>

---

<a id="start"></a>

## ▶️ Iniciar ComfyUI

Abre **ComfyUI-EZi Launcher** y elige un modo.

- **Desktop** - En la ventana de EZi Desktop
- **Browser** - En el navegador con la consola clásica
- **Hybrid** - En el navegador con la consola de EZi

Inicia con **KitchenAttention**, **SageAttention** o **FlashAttention**. Para Sage y Flash, instala primero el complemento.

---

<a id="addons"></a>

## 🧩 Complementos

Los complementos están en **Add-ons**. La mayoría también aparece en **EZi Desktop > Menu**.

| Complemento | Función |
|---|---|
| **Easy-Models-Linker** | Reutiliza la carpeta **models**.<br>No admite **LLM** ni **llm_gguf**. |
| **Easy-System-Checker** | Muestra información de hardware y software |
| **Nunchaku** | Instala [Nunchaku](https://github.com/nunchaku-ai/nunchaku) |
| **SageAttention-Multi** | Instala [SageAttention](https://github.com/woct0rdho/SageAttention) v2.2.0 y v3 (v3 solo en RTX 50) |
| **FlashAttention** | Instala [FlashAttention](https://github.com/Dao-AILab/flash-attention) v2.8.3 |
| **InsightFace** | Instala [InsightFace](https://github.com/deepinsight/insightface) |
| **Trellis2 + Pixal3D** | Instala [Trellis 2.0 + Pixal3D @visualbruno](https://github.com/visualbruno/ComfyUI-Trellis2) y su modelo |
| **Torch-Pack** | Cambia las versiones de PyTorch y CUDA |
| **Easy-model2GGUF** | Convierte modelos a GGUF (Q2_K a Q8_0) |
| **Long-Paths-Enabler** | Activa las rutas largas en Windows |
| **Toggle-DynamicVRAM** | Activa o desactiva `--disable-dynamic-vram` |

<details>
<summary><b>Versiones de Torch-Pack y compatibilidad con complementos</b></summary>

| Torch | CUDA | Nunchaku | Sage v2 | Sage v3 | Flash | Trellis2 |
|---|---|:---:|:---:|:---:|:---:|:---:|
| 2.7.1 | 12.8 | ✅ | ✅ | ✅ | ✅ | |
| 2.8.0 | 12.8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2.9.1 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.10.0 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| **2.11.0** (predeterminada) | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.12.1 | 13.0 | | ✅ | | ✅ | |
| 2.13.0 | 13.0 | | ✅ | | ✅ | |
| 2.14.1 | 13.0 | | ✅ | | ✅ | |

</details>

---

<a id="updates"></a>

## 🔄 Actualizaciones

Actualiza ComfyUI, los nodos y EZi desde el lanzador. Antes de hacer cambios importantes, guarda una instantánea para restaurarla con un clic.

---

<a id="help"></a>

## 🩺 Solución de problemas

<details>
<summary><b>El instalador se detiene o muestra errores</b></summary>

- Si falla la instalación, pulsa **Show log** y usa **Copy details** para compartir los detalles en [Pixaroma Discord](https://discord.gg/gggpkVgBf3).
- El registro completo está en `ComfyUI-Easy-Install.log`.
- Borra la carpeta incompleta `ComfyUI-Easy-Install` antes de reintentar.

</details>

<details>
<summary><b>Windows 11: "Bad Image" (0xc0e90002)</b></summary>

- En Windows 11, si aparece “Bad Image” (0xc0e90002), desactiva Smart App Control y reinicia ComfyUI.
- Se reducirá la protección frente a aplicaciones no fiables.
- Lee la advertencia de Windows antes de confirmar.

</details>

<details>
<summary><b>Faltan archivos o están bloqueados</b></summary>

- Si faltan archivos, revisa el historial de protección de Seguridad de Windows por si el antivirus bloqueó archivos de Python.
- Permítelos, elimina la carpeta y vuelve a instalar.

</details>

<details>
<summary><b>No se detecta el controlador NVIDIA</b></summary>

- Si no se detecta el controlador, instala el más reciente desde [nvidia.com/drivers](https://www.nvidia.com/drivers) y prueba `nvidia-smi` en una terminal.

</details>

<details>
<summary><b>Ruta o nombre de usuario con caracteres no ingleses</b></summary>

- Mueve el instalador a una ruta como `D:\AI\`.
- Si el nombre de usuario de Windows contiene caracteres no ingleses, aún pueden surgir problemas.

</details>

<details>
<summary><b>"ComfyUI is already running"</b></summary>

- “ComfyUI is already running” indica que el puerto (8188 por defecto) está ocupado.
- Cierra la otra ventana de ComfyUI y vuelve a intentarlo.

</details>

<details>
<summary><b>Errores con rutas largas</b></summary>

- Si la ruta es demasiado larga, ejecuta **Long-Paths-Enabler** desde **Add-ons\Tools**.

</details>

---

<a id="uninstall"></a>

## 🧹 Desinstalación

Elimina la carpeta `ComfyUI-Easy-Install` y el acceso directo **ComfyUI-EZi Launcher** del escritorio.

---

<a id="nodes"></a>

## 📦 Nodos incluidos

<details>
<summary><b>Nodos de los tutoriales de Pixaroma</b></summary>

| 🖼️ Imagen | 🎬 Vídeo | 🎵 Audio | 🧩 Utilidades y flujos | 🤖 Modelos |
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

## 🎭 Guía ilustrada de EZi

¿Es tu primera vez con EZi? Haz clic en cualquier imagen de la guía para verla a tamaño completo.

<table width="100%">
  <tr>
    <th width="16.66%">Instalar ComfyUI</th>
    <th width="16.66%">Lanzador EZi</th>
    <th width="16.66%">Reutilizar modelos</th>
    <th width="16.66%">Instalar complementos</th>
    <th width="16.66%">Actualizar y restaurar</th>
    <th width="16.66%">Tu sistema</th>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6"><img src="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6" width="100%" alt="Instalar ComfyUI"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9"><img src="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9" width="100%" alt="Lanzador EZi"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901"><img src="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901" width="100%" alt="Reutilizar modelos"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b"><img src="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b" width="100%" alt="Instalar complementos"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6"><img src="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6" width="100%" alt="Actualizar y restaurar"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3"><img src="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3" width="100%" alt="Tu sistema"></a></td>
  </tr>
</table>

<div align="center">

<a id="support"></a>

## ❤️ Apoya el desarrollo

Si te gusta el proyecto, tu apoyo ayuda a mantenerlo en marcha.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
