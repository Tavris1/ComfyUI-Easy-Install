<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<a href="README.ru.md#ru">Русский</a> |
<strong>Deutsch</strong> |
<a href="README.fr.md#fr">Français</a> |
<a href="README.vi.md#vi">Tiếng Việt</a>
</p>

---

# ComfyUI-Easy-Install
> **ComfyUI** Portable mit einem Klick für **Windows** 🔹 Nvidia GPUs 🔹 Pixaroma Community Edition 🔹  
> [![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
> [![GitHun Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
> [![Github All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)]()
> [![GitHub Downloads latest)](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=downloads%40latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
>
> Gewidmet dem **Pixaroma** Team  
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Join%20Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_presence_count&logo=discord&logoColor=white&label=Online&color=blue&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)

---

## Enthaltene Komponenten:  
- **Git** *(wird bei Bedarf installiert oder aktualisiert)*  
- **ComfyUI portable**  
- **Python 3.12.10** *(integrierte Portable-Version)*  

### Nodes aus den Pixaroma Tutorials auf [YouTube](https://www.youtube.com/@pixaroma)

|||||||
|---|---|---|---|---|---|
ComfyUI Manager | Tiled Diffusion & VAE | SCAIL-Pose | KJNodes | rgthree | iTools
MelBandRoFormer | Inpaint-CropAndStitch | Qwen3-TTS | Easy-Use | QwenVL | GGUF
VideoHelperSuite | SeedVR2_VideoUpscaler | ControlNet Aux | LayerStyle | Easy-Sam3 | RMBG
WanVideoWrapper | WanAnimatePreprocess | Comfyroll Studio

### Optionale zusätzliche Nodes
||||||
|---|---|---|---|---|
Nunchaku | SageAttention-Multi (v2.2.0 and v3) | FlashAttention | Trellis 2.0 | InsightFace

### Zusätzliche Tools
||||||
|---|---|---|---|---|
Easy-Models-Linker | Torch-Pack | Easy-model2GGUF | Long-Paths-Enabler | ComfyUI-Version-Switcher

---

## Windows Installation
1. Lade die [:arrow_forward:**neueste Version HIER**◀️](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip) herunter
2. Entpacke die ZIP-Datei in einen neuen Ordner und starte **`ComfyUI-Easy-Install.bat`** um die Einrichtung zu beginnen
3. Nach der Einrichtung kannst du optional folgende Komponenten aus dem **Add-ons** Ordner installieren oder ausführen:
    - **Easy-Models-Linker** - *Verwendet den vorhandenen **MODELS** Ordner über **extra_model_paths.yaml**, kein erneuter Download erforderlich*
      - *Einige Ordner wie **LLM** und **llm_gguf** können auf diese Weise nicht umgeleitet werden*
    - **Nunchaku** - *Installiert Nunchaku. Starte `Nunchaku.bat` erneut, falls später Probleme auftreten*
    - **SageAttention-Multi** - *Installiert SageAttention v2.2.0 und v3 (v3 nur wirksam auf NVIDIA 50-Serie GPUs)*
    - **FlashAttention** - *Installiert FlashAttention v2.8.3*
    - **InsightFace** - *Installiert InsightFace (vortrainierte Modelle nur für nicht-kommerzielle Forschung)*
    - **Trellis2** - *Installiert Trellis 2.0 und das Modell (benötigt `Torch 2.8.0+cu128` aus `Add-ons/Torch-Pack`)*
    - **Torch-Pack** - *Schneller Wechsel zwischen:*
      - ***Torch 2.7.1+cu128***
      - ***Torch 2.8.0+cu128***
      - ***Torch 2.9.1+cu130** (Standard, benötigt NVIDIA Treiber v580+)*  
    - **Easy-model2GGUF** *(**Add-Ons/Tools**)*  
      - *Konvertiert Modelle (`.safetensors`, `.pth`, `.pt`) innerhalb weniger Minuten in das **GGUF** Format (FP16 oder BF16)*  
      - *Quantisiert Modelle von **Q2_K** bis **Q8_0** und wendet bei Verfügbarkeit **5D Tensor Fixes** an*  
    - **Long-Paths-Enabler** *(`Add-Ons/Tools`)* - *Aktiviert **Long Paths** in Windows 10/11. Essenziell für Python/ComfyUI*  
    - **ComfyUI-Version-Switcher** *(`Add-Ons/Tools`)* - ***Reversibler** Rollback auf eine **frühere** ComfyUI-Version bei Problemen*  
    - **Toggle-DynamicVRAM** *(`Add-Ons/Tools`)* - *Schaltet die Option **--disable-dynamic-vram** in den ComfyUI-Startdateien um*  
    - **Update Easy-Install.bat** *(Hauptordner)* - *Aktualisiert **Add-ons** und andere Ordner. Erstellt Desktop-Verknüpfungen*  

> [!IMPORTANT]
> - Führe den Installer nicht als **Administrator** aus.
> - Vermeide Systemordner (`Program Files`, `Windows`, `C:\` Root).
> - Vermeide Leerzeichen und Sonderzeichen in Ordnernamen.
> - Stelle sicher, dass deine NVIDIA Treiber aktuell sind.

> [!TIP]
> - Mehrere ComfyUI Installationen sind ohne Konflikte möglich.
> - Du kannst den Ordner `ComfyUI-Easy-Install` nach der Installation umbenennen oder verschieben.
> - Für macOS / Linux klicke [here](https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux)

---

<img width="1038" height="240" alt="123321" src="https://github.com/user-attachments/assets/6d0655ef-8724-4cb1-bce2-a29fc9004173" />

---

Wenn dir meine Projekte gefallen, unterstütze mich bitte. Jede Unterstützung wird sehr geschätzt!

💜 PayPal: https://paypal.me/tavris1  
☕ Buy Me a Coffee: https://buymeacoffee.com/tavris1  
❤️ GitHub Sponsors: https://github.com/sponsors/Tavris1  