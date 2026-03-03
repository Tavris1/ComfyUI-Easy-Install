<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<a href="README.ru.md#ru">Русский</a> |
<a href="README.de.md#de">Deutsch</a> |
<strong>Français</strong> |
<a href="README.vi.md#vi">Tiếng Việt</a>
</p>

---

# ComfyUI-Easy-Install
> **ComfyUI** portable en un clic pour **Windows** 🔹 GPU Nvidia 🔹 Édition Communauté Pixaroma 🔹  
> [![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
> [![GitHun Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
> [![Github All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)]()
> [![GitHub Downloads latest)](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=downloads%40latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
>
> Dédié à l’équipe **Pixaroma**  
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Join%20Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_presence_count&logo=discord&logoColor=white&label=Online&color=blue&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)

---

## Composants inclus :  
- **Git** *(sera installé ou mis à jour si nécessaire)*  
- **ComfyUI portable**  
- **Python 3.12.10** *(version portable intégrée)*  

### Nœuds des tutoriels Pixaroma sur [YouTube](https://www.youtube.com/@pixaroma)

||||||
|---|---|---|---|---|
ComfyUI Manager | Tiled Diffusion & VAE | LayerStyle | rgthree | GGUF
VideoHelperSuite | Inpaint-CropAndStitch | SCAIL-Pose | KJNodes | iTools
Comfyroll Studio | SeedVR2_VideoUpscaler | ControlNet Aux | Easy-Use | RMBG
WanVideoWrapper | WanAnimatePreprocess | MelBandRoFormer | Easy-Sam3 | QwenVL
Qwen3-TTS

### Nœuds supplémentaires optionnels
||||||
|---|---|---|---|---|
Nunchaku | SageAttention-Multi (v2.2.0 and v3) | FlashAttention | Trellis 2.0 | InsightFace

### Outils supplémentaires
||||||
|---|---|---|---|---|
Easy-Models-Linker | Torch-Pack | Easy-model2GGUF | Long-Paths-Enabler | ComfyUI-Version-Switcher

---

## Installation Windows
1. Téléchargez la [:arrow_forward:**dernière version ICI**◀️](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Extrayez le fichier ZIP dans un nouveau dossier et exécutez **`ComfyUI-Easy-Install.bat`** pour démarrer l’installation
3. Après l’installation, vous pouvez éventuellement installer ou exécuter les composants suivants depuis le dossier **Add-ons** :
    - **Easy-Models-Linker** - *Utilise le dossier **MODELS** existant via **extra_model_paths.yaml**, aucun nouveau téléchargement requis*
      - *Certains dossiers comme **LLM** et **llm_gguf** ne peuvent pas être redirigés de cette manière*
    - **Nunchaku** - *Installe Nunchaku. Relancez `Nunchaku.bat` en cas de problème ultérieur*
    - **SageAttention-Multi** - *Installe SageAttention v2.2.0 et v3 (v3 effectif uniquement sur les GPU NVIDIA série 50)*
    - **FlashAttention** - *Installe FlashAttention v2.8.3*
    - **InsightFace** - *Installe InsightFace (modèles pré-entraînés pour la recherche non commerciale uniquement)*
    - **Trellis2** - *Installe Trellis 2.0 et le modèle (nécessite `Torch 2.8.0+cu128` depuis `Add-ons/Torch-Pack`)*
    - **Torch-Pack** - *Changement rapide entre :*
      - ***Torch 2.7.1+cu128***
      - ***Torch 2.8.0+cu128***
      - ***Torch 2.9.1+cu130** (par défaut, nécessite le pilote NVIDIA v580+)*  
    - **Easy-model2GGUF** *(**Add-Ons/Tools**)*  
      - *Convertit les modèles (`.safetensors`, `.pth`, `.pt`) au format **GGUF** (FP16 ou BF16) en quelques minutes*  
      - *Quantifie les modèles de **Q2_K** à **Q8_0** et applique les corrections **5D tensor** si disponibles*  
    - **Long-Paths-Enabler** *(`Add-Ons/Tools`)* - *Active les **Long Paths** sous Windows 10/11. Essentiel pour Python/ComfyUI*  
    - **ComfyUI-Version-Switcher** *(`Add-Ons/Tools`)* - ***Retour arrière réversible** vers une version **précédente** de ComfyUI en cas de problème*  
    - **Update Easy-Install.bat** *(dossier principal)* - *Met à jour les **Add-ons** et autres dossiers. Crée des raccourcis sur le bureau*  

> [!IMPORTANT]
> - N’exécutez pas l’installateur en tant qu’**Administrateur**.
> - Évitez les dossiers système (`Program Files`, `Windows`, racine `C:\`).
> - Évitez les espaces et caractères spéciaux dans les noms de dossiers.
> - Assurez-vous que vos pilotes NVIDIA sont à jour.

> [!TIP]
> - Plusieurs installations de ComfyUI sont possibles sans conflit.
> - Vous pouvez renommer ou déplacer le dossier `ComfyUI-Easy-Install` après l’installation.
> - Pour macOS / Linux cliquez [here](https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux)

---

<img width="1038" height="240" alt="123321" src="https://github.com/user-attachments/assets/6d0655ef-8724-4cb1-bce2-a29fc9004173" />

---

Si vous appréciez mes projets, merci d’envisager de me soutenir. Toute aide est grandement appréciée !

💜 PayPal: https://paypal.me/tavris1  
☕ Buy Me a Coffee: https://buymeacoffee.com/tavris1  
❤️ GitHub Sponsors: https://github.com/sponsors/Tavris1  