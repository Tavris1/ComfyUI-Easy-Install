<a id="fr"></a>

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
    <strong>Installez ComfyUI en version portable en un clic, puis gérez et personnalisez votre installation avec EZi Desktop.</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

<p align="center">
  <a href="#install">📥 <strong>Installer</strong></a> &nbsp;·&nbsp;
  <a href="#features">✨ Fonctionnalités</a> &nbsp;·&nbsp;
  <a href="#requirements">💻 Configuration requise</a> &nbsp;·&nbsp;
  <a href="#help">🩺 Aide</a> &nbsp;·&nbsp;
  <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
  <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
  <a href="#support">❤️ Soutenir</a>
</p>

<br>

![ComfyUI Screenshot](ComfyUI-ivo.png)

**Vous découvrez EZi ?** [Découvrir EZi en BD](#comic)

</div>

<a id="features"></a>

## ✨ Fonctionnalités

**ComfyUI-Easy-Install** installe une version portable de ComfyUI avec son propre Python, des nœuds prêts à l’emploi et **EZi Desktop**.

- **En un clic** - Configuration automatique de Git, Python, PyTorch, ComfyUI et des nœuds
- **Aucune configuration manuelle** - Python, ComfyUI et les modèles dans un même dossier
- **Extensions en un clic** - Nunchaku, SageAttention, FlashAttention, InsightFace et plus encore
- **EZi Desktop** - Fenêtre dédiée avec console intelligente et menu
  - Versions de PyTorch/CUDA (Torch-Pack)
  - Versions de ComfyUI et de son interface
  - Dossiers des modèles et dossiers Input/Output/User
  - Arguments de démarrage et VRAM dynamique
  - Paramètres de ComfyUI-Manager et versions de paquets figées
  - Cache UV/PIP et conversion en GGUF
- **EZi Launcher** - Démarrer, mettre à jour, ouvrir des dossiers, enregistrer et restaurer des instantanés

<details>
<summary><b>Possibilités d’EZi Desktop</b></summary>

- Lancer ComfyUI dans sa propre fenêtre, dans le navigateur ou dans les deux
- Recevoir les notifications de nouvelles versions de ComfyUI et d’EZi
- Télécharger les modèles directement dans le bon dossier
- **Console**
  - Rechercher (Ctrl+F) et enregistrer le journal au format .txt (Ctrl+S)
  - Détacher la console dans une fenêtre distincte
  - Copier ou enregistrer le texte sélectionné, le rechercher sur Google ou interroger Claude ou ChatGPT
- **Capture** - Capture d’écran ou enregistrement vidéo
- **Dossiers de modèles** - Relier plusieurs dossiers existants
- **Dossiers Input, Output et User personnalisés**
- **Arguments de démarrage** - Éditeur avec la liste de toutes les options
- **ComfyUI-Manager** - Interface nouvelle ou classique, niveau de sécurité, installation via pip ou URL Git
- **Gestion des versions figées** - Figer des versions comme `numpy==1.26.4`
- **Cache des paquets** - Conserver ou vider le cache UV/PIP
- **Informations système** - GPU, RAM, Python, Torch, ComfyUI, chemins longs
- Thèmes, taille du texte, infobulles et fond de la console
- Liens vers les workflows et le cours ComfyUI de Pixaroma

</details>

---

<a id="requirements"></a>

## 💻 Configuration requise

| | |
|---|---|
| **Système** | Windows 10 / 11, 64 bits |
| **GPU** | NVIDIA RTX série 20 ou ultérieure |
| **Pilote** | NVIDIA 580 ou ultérieur (recommandé) |
| **RAM** | 8 Go minimum, 16 Go ou plus recommandés |
| **Disque** | Au moins 15 Go libres plus l’espace pour les modèles (SSD recommandé) |
| **Internet** | Nécessaire pendant l’installation |

> [!NOTE]
> Avec un pilote antérieur à **580**, l’installateur utilise **CUDA 12.8** et **Torch 2.8.0**. Mettez le pilote à jour pour utiliser **CUDA 13.0** et **Torch 2.11.0**.

---

<a id="install"></a>

## 🖥️ Installation sous Windows

> [!IMPORTANT]
> - Utilisez un chemin court en caractères anglais, par exemple `D:\AI\`.

1. [**📥 Télécharger la dernière version**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Extrayez le ZIP dans un nouveau dossier
3. Exécutez **`ComfyUI-Easy-Install.bat`**
4. Attendez la fin de l’installation
5. Cliquez sur **Start ComfyUI** ou ouvrez le raccourci **ComfyUI-EZi Launcher** sur le Bureau

<details>
<summary><b>Éléments installés</b></summary>

| Composant | Version |
|---|---|
| [Git](https://git-scm.com/) | Dernière version, uniquement si Git est absent |
| [Python](https://www.python.org/downloads/release/python-31210/) | 3.12.10 Embarqué, somme de contrôle vérifiée |
| PyTorch | 2.11.0 + CUDA 13.0 ou 2.8.0 + CUDA 12.8 |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | Dernière version |
| ComfyUI-Manager, Triton, ONNX Runtime GPU, llama-cpp-python | |
| [Nœuds inclus](#nodes) | Nœuds des tutoriels Pixaroma |
| Workflows de découverte | Juggernaut Reborn, Z-Image Turbo |
| Médias d’exemple | Dans le dossier `ComfyUI\input` |
| ComfyUI-EZi Launcher | Raccourci sur le Bureau |

</details>

---

<a id="start"></a>

## ▶️ Démarrer ComfyUI

Ouvrez **ComfyUI-EZi Launcher** et choisissez un mode.

- **Desktop** - Dans la fenêtre EZi Desktop
- **Browser** - Dans le navigateur avec la console classique
- **Hybrid** - Dans le navigateur avec la console EZi

Démarrez avec **KitchenAttention**, **SageAttention** ou **FlashAttention**. Pour Sage et Flash, installez d’abord l’extension.

---

<a id="addons"></a>

## 🧩 Extensions

Les extensions se trouvent dans **Add-ons**. La plupart sont aussi accessibles depuis **EZi Desktop > Menu**.

| Extension | Fonction |
|---|---|
| **Easy-Models-Linker** | Réutilise votre dossier **models**.<br>Ne prend pas en charge **LLM** et **llm_gguf**. |
| **Easy-System-Checker** | Affiche les informations matérielles et logicielles |
| **Nunchaku** | Installe [Nunchaku](https://github.com/nunchaku-ai/nunchaku) |
| **SageAttention-Multi** | Installe [SageAttention](https://github.com/woct0rdho/SageAttention) v2.2.0 et v3 (v3 uniquement sur RTX 50) |
| **FlashAttention** | Installe [FlashAttention](https://github.com/Dao-AILab/flash-attention) v2.8.3 |
| **InsightFace** | Installe [InsightFace](https://github.com/deepinsight/insightface) |
| **Trellis2 + Pixal3D** | Installe [Trellis 2.0 + Pixal3D @visualbruno](https://github.com/visualbruno/ComfyUI-Trellis2) et son modèle |
| **Torch-Pack** | Change les versions de PyTorch et CUDA |
| **Easy-model2GGUF** | Convertit les modèles en GGUF (Q2_K à Q8_0) |
| **Long-Paths-Enabler** | Active les chemins longs sous Windows |
| **Toggle-DynamicVRAM** | Active ou désactive `--disable-dynamic-vram` |

<details>
<summary><b>Versions de Torch-Pack et extensions compatibles</b></summary>

| Torch | CUDA | Nunchaku | Sage v2 | Sage v3 | Flash | Trellis2 |
|---|---|:---:|:---:|:---:|:---:|:---:|
| 2.7.1 | 12.8 | ✅ | ✅ | ✅ | ✅ | |
| 2.8.0 | 12.8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2.9.1 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.10.0 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| **2.11.0** (par défaut) | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.12.1 | 13.0 | | ✅ | | ✅ | |
| 2.13.0 | 13.0 | | ✅ | | ✅ | |
| 2.14.1 | 13.0 | | ✅ | | ✅ | |

</details>

---

<a id="updates"></a>

## 🔄 Mises à jour

Mettez à jour ComfyUI, les nœuds et EZi depuis le lanceur. Avant un changement important, enregistrez un instantané pour pouvoir le restaurer en un clic.

---

<a id="help"></a>

## 🩺 Dépannage

<details>
<summary><b>L’installateur s’arrête ou affiche des erreurs</b></summary>

- Si l’installation s’interrompt, cliquez sur **Show log** et utilisez **Copy details** pour partager les détails sur le [Discord de Pixaroma](https://discord.gg/gggpkVgBf3).
- Le journal complet se trouve dans `ComfyUI-Easy-Install.log`.
- Supprimez le dossier incomplet `ComfyUI-Easy-Install` avant de réessayer.

</details>

<details>
<summary><b>Windows 11: "Bad Image" (0xc0e90002)</b></summary>

- Sous Windows 11, en cas d’erreur « Bad Image » (0xc0e90002), désactivez Smart App Control et relancez ComfyUI.
- Cela réduit la protection contre les applications non fiables.
- Lisez l’avertissement de Windows avant de confirmer.

</details>

<details>
<summary><b>Fichiers absents ou bloqués</b></summary>

- Si des fichiers manquent, consultez l’historique de protection de Sécurité Windows.
- Autorisez les fichiers Python bloqués, supprimez le dossier et réinstallez.

</details>

<details>
<summary><b>Pilote NVIDIA non détecté</b></summary>

- Si le pilote est introuvable, installez le dernier pilote depuis [nvidia.com/drivers](https://www.nvidia.com/drivers) et testez `nvidia-smi` dans un terminal.

</details>

<details>
<summary><b>Caractères non anglais dans le chemin ou le nom d’utilisateur</b></summary>

- Placez l’installateur dans un chemin tel que `D:\AI\`.
- Des caractères non anglais dans le nom d’utilisateur Windows peuvent encore poser problème.

</details>

<details>
<summary><b>"ComfyUI is already running"</b></summary>

- « ComfyUI is already running » indique que le port (8188 par défaut) est occupé.
- Fermez l’autre fenêtre ComfyUI et réessayez.

</details>

<details>
<summary><b>Erreurs liées aux chemins longs</b></summary>

- En cas d’erreur liée aux chemins longs, lancez **Long-Paths-Enabler** depuis **Add-ons\Tools**.

</details>

---

<a id="uninstall"></a>

## 🧹 Désinstallation

Supprimez le dossier `ComfyUI-Easy-Install` et le raccourci **ComfyUI-EZi Launcher** du Bureau.

---

<a id="nodes"></a>

## 📦 Nœuds inclus

<details>
<summary><b>Nœuds des tutoriels Pixaroma</b></summary>

| 🖼️ Image | 🎬 Vidéo | 🎵 Audio | 🧩 Utilitaires et workflows | 🤖 Modèles |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [WanVideoWrapper](https://github.com/kijai/ComfyUI-WanVideoWrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | | [KJNodes](https://github.com/kijai/ComfyUI-KJNodes) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | [SeedVR2 VideoUpscaler](https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler) | | [iTools](https://github.com/MohammadAboulEla/ComfyUI-iTools) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI Nodes](https://github.com/gseth/ControlAltAI-Nodes) | |
| [Krea2Edit](https://github.com/lbouaraba/comfyui-krea2edit) | | | ✨ [Pixaroma](https://gitlab.com/pixaroma/ComfyUI-Pixaroma) | |

</details>

---

<a id="comic"></a>

## 🎭 Découvrir EZi en BD

Vous découvrez EZi ? Cliquez sur une image de la BD pour l’afficher en taille réelle.

<table width="100%">
  <tr>
    <th width="16.66%">Installer ComfyUI</th>
    <th width="16.66%">Lanceur EZi</th>
    <th width="16.66%">Réutiliser les modèles</th>
    <th width="16.66%">Installer des extensions</th>
    <th width="16.66%">Mettre à jour et restaurer</th>
    <th width="16.66%">Votre système</th>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6"><img src="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6" width="100%" alt="Installer ComfyUI"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9"><img src="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9" width="100%" alt="Lanceur EZi"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901"><img src="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901" width="100%" alt="Réutiliser les modèles"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b"><img src="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b" width="100%" alt="Installer des extensions"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6"><img src="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6" width="100%" alt="Mettre à jour et restaurer"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3"><img src="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3" width="100%" alt="Votre système"></a></td>
  </tr>
</table>

<div align="center">

<a id="support"></a>

## ❤️ Soutenir le développement

Si ce projet vous plaît, votre soutien contribue à la poursuite de son développement.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
