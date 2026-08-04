<a id="fr"></a>

<p align="center">
🌍 
<a href="../README.md#english">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<a href="README.de.md#de">Deutsch</a> |
<strong>Français</strong> |
<a href="README.ru.md#ru">Русский</a> |
<a href="README.tr.md#de">Türkçe</a> |
<a href="README.vi.md#vi">Tiếng Việt</a>
</p>

---

<div align="center">
  <img src="docs/EZi-Logo.svg" width="120" alt="EZi Logo">
  <h1>ComfyUI-Easy-Installer</h1>
  <p align="center">
    <strong>ComfyUI portable en un clic avec EZi Desktop</strong><br />
    Windows • GPU NVIDIA • Édition communautaire Pixaroma
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Installer)](https://github.com/Tavris1/ComfyUI-Easy-Installer/releases/latest/download/ComfyUI-Easy-Installer.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Installer?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Installer/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/Tavris1/ComfyUI-Easy-Installer/Windows/.github/badges/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Installer/releases)

  <p align="center">
    <a href="#%EF%B8%8F-windows-installation">📥 Installer</a> &nbsp;·&nbsp;
    <a href="#-features">✨ Fonctionnalités/Composants</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-Installer/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#%EF%B8%8F-support-development">❤️ Soutenir le développement</a>
  </p>

---

![ComfyUI Screenshot](docs/ComfyUI-ivo.jpg)

</div>

## ✨ Fonctionnalités

****ComfyUI-Easy-Installer** fournit un environnement ComfyUI portable avec **EZi Desktop**.  
Aucune configuration manuelle de Python ou Git n'est nécessaire.

Installerez en un clic des paquets complexes tels que Nunchaku, SageAttention, FlashAttention, InsightFace et Trellis 2.0.

Gérez au même endroit **les modèles, paquets, versions PyTorch/CUDA, Dynamic VRAM, versions de ComfyUI/frontend, caches UV/PIP et conversion GGUF**.

## 📦 Composants inclus
<details open>
<summary><b>Composants principaux</b></summary>

| 🔧 Composant | 📝 Note |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - Dernière version (installation/mise à jour si nécessaire) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - Version intégrée |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - Dernière version stable |

</details>

<details>
<summary><b>Nodes utilisés dans les tutoriels Pixaroma</b></summary>

| 🖼️ Image | 🎬 Vidéo | 🎵 Audio | 🧩 Utilitaire / WF | 🤖 Modèles |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [VidéoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VidéoHelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [WanVidéoWrapper](https://github.com/kijai/ComfyUI-WanVidéoWrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | [FishAudioS2](https://github.com/Saganaki22/ComfyUI-FishAudioS2) | [KJNodes](https://github.com/kijai/ComfyUI-KJNodes) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SeedVR2 VidéoUpscaler](https://github.com/numz/ComfyUI-SeedVR2_VidéoUpscaler) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | | | [iOutils](https://github.com/MohammadAboulEla/ComfyUI-iOutils) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI Nodes](https://github.com/gseth/ControlAltAI-Nodes) | |
| [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | | ✨[Pixaroma](https://github.com/pixaroma/ComfyUI-Pixaroma) | |
| | | | [Krea2T-Enhancer](https://github.com/capitan01R/ComfyUI-Krea2T-Enhancer) | |
| | | | [Krea2Edit](https://github.com/lbouaraba/comfyui-krea2edit) | |

</details>

<details>
<summary><b>Extensions et outils optionnels</b></summary>

| 🧩 Nodes | 🛠️ Outils |
|---|---|
| [Nunchaku](https://github.com/nunchaku-ai/nunchaku) | Easy-Modèles-Linker |
| [SageAttention (v2.2.0 and v3)](https://github.com/woct0rdho/SageAttention) | Easy-System-Checker |
| [FlashAttention](https://github.com/Dao-AILab/flash-attention) | ComfyUI-Version-Switcher |
| [InsightFace](https://github.com/deepinsight/insightface) | Easy-model2GGUF |
| [Trellis 2.0](https://github.com/visualbruno/ComfyUI-Trellis2) | Long-Paths-Enabler |
| | Torch-Pack |
| | Toggle-DynamicVRAM |
| | Update Easy-Installer |

</details>

---

## 🖥️ Installeration Windows

> [!IMPORTANT]
> - N'exécutez pas l'installateur en tant qu'**Administrateur**.
> - Évitez les dossiers système (`Program Files`, `Windows`, racine de `C:\`).
> - Évitez les espaces et caractères spéciaux dans les noms de dossiers.
> - Assurez-vous que vos pilotes NVIDIA sont à jour.

1. [**📥 TÉLÉCHARGER LA DERNIÈRE VERSION**](https://github.com/Tavris1/ComfyUI-Easy-Installer/releases/latest/download/ComfyUI-Easy-Installer.zip)
2. Extrayez le ZIP dans un nouveau dossier et exécutez **`ComfyUI-Easy-Installer.bat`**
3. Après la configuration, vous pouvez installer ou exécuter des composants depuis le dossier **Add-ons** ou le **EZi Desktop Menu** :
    - **Easy-Modèles-Linker** - *Utilise le dossier **MODELS** existant via **extra_model_paths.yaml**, sans nouveau téléchargement*
      - *Certains dossiers comme **LLM** et **llm_gguf** ne peuvent pas être redirigés de cette manière*
    - **Easy-System-Checker** - *Fournit des informations sur les principaux composants matériels et logiciels*
    - **Nunchaku** - *Installere Nunchaku. (Relancez `Nunchaku.bat` en cas de problème ultérieur)*
    - **SageAttention-Multi** - *Installere SageAttention v2.2.0 et v3 (v3 est actif uniquement sur les GPU NVIDIA série 50)*
    - **FlashAttention** - *Installere FlashAttention v2.8.3*
    - **InsightFace** - *Installere InsightFace (modèles préentraînés réservés à la recherche non commerciale)*
    - **Trellis2** - *Installere Trellis 2.0 et le modèle (nécessite `Torch 2.8.0+cu128` depuis `Add-ons/Torch-Pack`)*
    - **Torch-Pack** - *Changement rapide entre :*  
      - *`Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`, `Torch 2.9.1+cu130`, `Torch 2.10+cu130` & `Torch 2.11+cu130`*
    - **Easy-model2GGUF** - *Convertit et quantifie les modèles en GGUF (Q2_K–Q8_0), avec correction des tenseurs 5D si disponible*
    - **Long-Paths-Enabler** - *Active **Long Paths** dans Windows 10/11. Indispensable pour Python/ComfyUI*
    - **ComfyUI-Version-Switcher** - *Permet un retour **réversible** à une version **précédente** de ComfyUI en cas de problème*
    - **Toggle-DynamicVRAM** - *Active/désactive l'option **--disable-dynamic-vram** dans les fichiers de démarrage de ComfyUI*
    - **Update Easy-Installer** - *Met à jour **Add-ons** et d'autres dossiers. Crée des raccourcis sur le bureau*
    - **EZi Desktop Themes** - *via EZi Desktop > Menu > Advanced*
    - **Dossiers Input, Output et User personnalisés** - *via EZi Desktop > Menu > Advanced*
    - **Changeur de versions ComfyUI et frontend** - *via EZi Desktop > Menu > Advanced*
    - **Nettoyeur de cache UV et PIP** - *via EZi Desktop > Menu*
    - **ComfyUI-Manager Security-Level Config** - *Configuration facile de security_level via EZi Desktop > Menu*
    - **Pinned-Packages-Manager** - *Figez les versions de paquets comme NumPy==1.26.4 via EZi Desktop > Menu*

<div align="center">

---

## ❤️ Soutenir le développement

Vous aimez le projet ?  
S'il vous fait gagner du temps, votre soutien aide à poursuivre le développement et la maintenance.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/Tavris1?style=for-the-badge&logo=github)](https://github.com/sponsors/Tavris1)

</div>
