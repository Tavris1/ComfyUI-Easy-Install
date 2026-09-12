<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
<strong>Português</strong> |
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
    <strong>ComfyUI portátil com um clique e EZi Desktop: um painel completo para pacotes, ambientes e configuração</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)


<!--[![GitHub All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)-->
<!--[![GitHub Downloads Latest](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=⬇+latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)-->

  <p align="center">
    <a href="#%EF%B8%8F-instalação-no-windows">📥 Instalar</a> &nbsp;·&nbsp;
    <a href="#-recursos">✨ Recursos/Componentes</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#%EF%B8%8F-apoiar-o-desenvolvimento">❤️ Apoiar o desenvolvimento</a>
  </p>

<!-- Dedicated to the **Pixaroma** community  
[![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
-->

---

![ComfyUI Screenshot](ComfyUI-ivo.jpg)

</div>

## ✨ Recursos

**ComfyUI-Easy-Install** fornece um ambiente portátil do ComfyUI com **EZi Desktop**.  
Não é necessária nenhuma configuração manual do Python ou Git.

Instale pacotes complexos como Nunchaku, SageAttention, FlashAttention, InsightFace e Trellis 2.0 com um único clique.

Gerencie **modelos, pacotes, versões do PyTorch/CUDA, Dynamic VRAM,  
versões do ComfyUI/frontend, caches do UV/PIP e conversão para GGUF** em um só lugar.

## 📦 Componentes incluídos
<details open>
<summary><b>Componentes principais</b></summary>

| 🔧 Componente | 📝 Observação |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - Mais recente (será instalado/atualizado se necessário) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - Versão Embedded |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - Versão estável mais recente |

</details>

<details>
<summary><b>Nodes usados nos tutoriais da Pixaroma</b></summary>

| 🖼️ Imagem | 🎬 Vídeo | 🎵 Áudio | 🧩 Utilitário / WF | 🤖 Modelos |
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
<summary><b>Add-ons e Tools opcionais</b></summary>

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

## 🖥️ Instalação no Windows

> [!IMPORTANT]
> - Não execute o instalador como **Administrator**.
> - Evite pastas do sistema (`Program Files`, `Windows`, raiz de `C:\`).
> - Evite espaços e caracteres especiais nos nomes das pastas.
> - Certifique-se de que os drivers NVIDIA estejam atualizados.

1. [**📥 DOWNLOAD LATEST VERSION**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Extraia o arquivo ZIP para uma nova pasta e execute **`ComfyUI-Easy-Install.bat`**
3. Opcionalmente, após a configuração, instale ou execute componentes da pasta **Add-ons** ou do **EZi Desktop Menu**:
    - **Easy-Models-Linker** - *Usa a pasta **MODELS** existente por meio do **extra_model_paths.yaml**, sem necessidade de baixar novamente*
      - *Algumas pastas, como **LLM** e **llm_gguf**, não podem ser redirecionadas dessa forma*
    - **Easy-System-Checker** - *Fornece informações sobre os principais componentes de hardware e software*
    - **Nunchaku** - *Instala o Nunchaku*
    - **SageAttention-Multi** - *Instala tanto o SageAttention v2.2.0 quanto o v3 (v3 é efetivo apenas em NVIDIA 50-series GPUs)*
    - **FlashAttention** - *Instala o FlashAttention v2.8.3*
    - **InsightFace** - *Instala o InsightFace (modelos pré-treinados apenas para pesquisa não comercial)*
    - **Trellis2** - *Instala o Trellis 2.0 e o modelo (requer `Torch 2.8.0+cu128` do `Add-ons/Torch-Pack`)*
    - **Torch-Pack** - *Alternância rápida entre: `Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`,  
      `Torch 2.9.1+cu130`, `Torch 2.10+cu130`, `Torch 2.11+cu130`, `Torch 2.12.1+cu130` & `Torch 2.13.0+cu130`*
    - **Easy-model2GGUF** - *Converte e quantiza modelos para GGUF (Q2_K–Q8_0), com correções de tensor 5D quando disponíveis*
    - **Long-Paths-Enabler** - *Ativa **Long Paths** no Windows 10/11. Essencial para Python/ComfyUI*
    - **ComfyUI-Version-Switcher** - *Rollback **reversível** para uma versão **anterior** do ComfyUI caso ocorram problemas*
    - **Toggle-DynamicVRAM** - *Alterna a opção **--disable-dynamic-vram** nos arquivos de inicialização do ComfyUI*
    - **Update Easy-Install** - *Atualiza **Add-ons** e outras pastas. Cria atalhos na área de trabalho*
    - **EZi Desktop Themes** - *via EZi Desktop > Menu > Advanced*
    - **Custom Input, Output & User folders** - *via EZi Desktop > Menu > Advanced*
    - **ComfyUI & Frontend Version Changer** - *via EZi Desktop > Menu > Advanced*
    - **UV & PIP cache cleaner** - *via EZi Desktop > Menu*
    - **ComfyUI-Manager Security-Level Config** - *Configuração fácil de security_level via EZi Desktop > Menu*
    - **Pinned-Packages-Manager** - *Fixe versões de pacotes, como NumPy==1.26.4, via EZi Desktop > Menu*

<div align="center">

---

## ❤️ Apoiar o desenvolvimento

Gostou do projeto?  
Se ele economiza seu tempo, seu apoio ajuda a manter o desenvolvimento e a manutenção.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
