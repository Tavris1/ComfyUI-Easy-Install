<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<a href="README.de.md#de">Deutsch</a> |
<strong>Français</strong> |
<a href="README.ru.md#ru">Русский</a> |
<a href="README.tr.md#tr">Türkçe</a> |
<a href="README.vi.md#vi">Tiếng Việt</a>
</p>

---

<div align="center">
  <img src="EZi-Logo.svg" width="120" alt="EZi Logo">
  <h1>ComfyUI-Easy-Install</h1>
  <p align="center">
    <strong>ComfyUI portable en un clic avec EZi Desktop : un tableau de bord complet pour les packages, les environnements et la configuration</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)


<!--[![GitHub All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)-->
<!--[![GitHub Downloads Latest](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=⬇+latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)-->

  <p align="center">
    <a href="#%EF%B8%8F-installation-windows">📥 Installer</a> &nbsp;·&nbsp;
    <a href="#-fonctionnalités">✨ Fonctionnalités/Composants</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#%EF%B8%8F-soutenir-le-développement">❤️ Soutenir le développement</a>
  </p>

<!-- Dédié à la communauté **Pixaroma**  
[![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
-->

---

![ComfyUI Screenshot](ComfyUI-ivo.jpg)

</div>

## ✨ Fonctionnalités

**ComfyUI-Easy-Install** fournit un environnement ComfyUI portable avec **EZi Desktop**.  
Aucune configuration manuelle de Python ou Git n'est requise.

Installez des packages complexes tels que Nunchaku, SageAttention, FlashAttention, InsightFace et Trellis 2.0 en un clic.

Gérez **les modèles, les packages, les versions de PyTorch/CUDA, Dynamic VRAM,  
les versions de ComfyUI/frontend, les caches UV/PIP et la conversion GGUF** depuis un seul endroit.

## 📦 Composants inclus
<details open>
<summary><b>Composants principaux</b></summary>

| 🔧 Composant | 📝 Note |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - Dernière version (sera installé/mis à jour si nécessaire) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - Version intégrée |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - Dernière version stable |

</details>

<details>
<summary><b>Nodes utilisés dans les tutoriels Pixaroma</b></summary>

| 🖼️ Image | 🎬 Vidéo | 🎵 Audio | 🧩 Utility / WF | 🤖 Modèles |
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
<summary><b>Add-ons & Tools optionnels</b></summary>

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

## 🖥️ Installation Windows

> [!IMPORTANT]
> - N'exécutez pas l'installateur en tant qu'**Administrator**.
> - Évitez les dossiers système (`Program Files`, `Windows`, `C:\` root).
> - Évitez les espaces et les caractères spéciaux dans les noms de dossiers.
> - Assurez-vous que vos pilotes NVIDIA sont à jour.

1. [**📥 TÉLÉCHARGER LA DERNIÈRE VERSION**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Extrayez le fichier ZIP dans un nouveau dossier et exécutez **`ComfyUI-Easy-Install.bat`**
3. Après l'installation, vous pouvez éventuellement installer ou exécuter des composants depuis le dossier **Add-ons** ou le **EZi Desktop Menu** :
    - **Easy-Models-Linker** - *Utilise le dossier **MODELS** existant via **extra_model_paths.yaml**, aucun nouveau téléchargement nécessaire*
      - *Certains dossiers comme **LLM** et **llm_gguf** ne peuvent pas être redirigés de cette manière*
    - **Easy-System-Checker** - *Fournit des informations sur les principaux composants matériels et logiciels*
    - **Nunchaku** - *Installe Nunchaku*
    - **SageAttention-Multi** - *Installe SageAttention v2.2.0 et v3 (v3 est efficace uniquement sur les NVIDIA 50-series GPUs)*
    - **FlashAttention** - *Installe FlashAttention v2.8.3*
    - **InsightFace** - *Installe InsightFace (Pretrained models for non-commercial research only)*
    - **Trellis2** - *Installe Trellis 2.0 et le modèle (nécessite `Torch 2.8.0+cu128` depuis `Add-ons/Torch-Pack`)*
    - **Torch-Pack** - *Permet de basculer rapidement entre:`Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`,  
      `Torch 2.9.1+cu130`, `Torch 2.10+cu130`, `Torch 2.11+cu130`, `Torch 2.12.1+cu130` & `Torch 2.13.0+cu130`*
    - **Easy-model2GGUF** - *Convertit et quantifie les modèles en GGUF (Q2_K–Q8_0) avec des corrections des tenseurs 5D si disponibles*
    - **Long-Paths-Enabler** - *Active les **Long Paths** dans Windows 10/11. Essentiel pour Python/ComfyUI*
    - **ComfyUI-Version-Switcher** - ***Rollback réversible** vers une **version précédente** de ComfyUI en cas de problème*
    - **Toggle-DynamicVRAM** - *Active/désactive l'option **--disable-dynamic-vram** dans les fichiers de démarrage de ComfyUI*
    - **Update Easy-Install** - *Met à jour les **Add-ons** et autres dossiers. Crée des raccourcis sur le bureau*
    - **EZi Desktop Themes** - *via EZi Desktop > Menu > Advanced*
    - **Custom Input, Output & User folders** - *via EZi Desktop > Menu > Advanced*
    - **ComfyUI & Frontend Version Changer** - *via EZi Desktop > Menu > Advanced*
    - **UV & PIP cache cleaner** - *via EZi Desktop > Menu*
    - **ComfyUI-Manager Security-Level Config** - *Configuration facile de security_level via EZi Desktop > Menu*
    - **Pinned-Packages-Manager** - *Fige les versions des packages telles que NumPy==1.26.4 via EZi Desktop > Menu*

<div align="center">

---

## ❤️ Soutenir le développement

Vous appréciez le projet ?  
S'il vous fait gagner du temps, votre soutien contribue à poursuivre son développement et sa maintenance.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
