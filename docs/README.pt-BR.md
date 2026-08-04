<a id="pt-br"></a>

<p align="center">
🌍 
<a href="../README.md#english">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
<strong>Português</strong> |
<a href="README.de.md#de">Deutsch</a> |
<a href="README.fr.md#fr">Français</a> |
<a href="README.ru.md#ru">Русский</a> |
<a href="README.tr.md#de">Türkçe</a> |
<a href="README.vi.md#vi">Tiếng Việt</a>
</p>

---

<div align="center">
  <img src="docs/EZi-Logo.svg" width="120" alt="EZi Logo">
  <h1>ComfyUI-Easy-Instalar</h1>
  <p align="center">
    <strong>ComfyUI portátil com um clique usando o EZi Desktop</strong><br />
    Windows • GPUs NVIDIA • Edição Comunitária Pixaroma
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/Tavris1/ComfyUI-Easy-Install/Windows/.github/badges/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

  <p align="center">
    <a href="#%EF%B8%8F-windows-installation">📥 Instalar</a> &nbsp;·&nbsp;
    <a href="#-features">✨ Recursos/Componentees</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-Instalar/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#%EF%B8%8F-support-development">❤️ Apoiar o desenvolvimento</a>
  </p>

---

![ComfyUI Screenshot](docs/ComfyUI-ivo.jpg)

</div>

## ✨ Recursos

**O **ComfyUI-Easy-Instalar** fornece um ambiente portátil do ComfyUI com o **EZi Desktop**.  
Não é necessário configurar Python ou Git manualmente.

Instale com um clique pacotes complexos como Nunchaku, SageAttention, FlashAttention, InsightFace e Trellis 2.0.

Gerencie em um só lugar **modelos, pacotes, versões do PyTorch/CUDA, Dynamic VRAM, versões do ComfyUI/frontend, caches do UV/PIP e conversão para GGUF**.

## 📦 Componentees incluídos
<details open>
<summary><b>Componentees principais</b></summary>

| 🔧 Componente | 📝 Observação |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - Mais recente (instala/atualiza se necessário) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - Versão incorporada |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - Versão estável mais recente |

</details>

<details>
<summary><b>Nós usados nos tutoriais da Pixaroma</b></summary>

| 🖼️ Imagem | 🎬 Vídeo | 🎵 Áudio | 🧩 Utilitário / WF | 🤖 Modelos |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [VídeoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VídeoHelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [WanVídeoWrapper](https://github.com/kijai/ComfyUI-WanVídeoWrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | [FishÁudioS2](https://github.com/Saganaki22/ComfyUI-FishÁudioS2) | [KJNós](https://github.com/kijai/ComfyUI-KJNós) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SeedVR2 VídeoUpscaler](https://github.com/numz/ComfyUI-SeedVR2_VídeoUpscaler) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | | | [iFerramentas](https://github.com/MohammadAboulEla/ComfyUI-iFerramentas) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI Nós](https://github.com/gseth/ControlAltAI-Nós) | |
| [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | | ✨[Pixaroma](https://github.com/pixaroma/ComfyUI-Pixaroma) | |
| | | | [Krea2T-Enhancer](https://github.com/capitan01R/ComfyUI-Krea2T-Enhancer) | |
| | | | [Krea2Edit](https://github.com/lbouaraba/comfyui-krea2edit) | |

</details>

<details>
<summary><b>Complementos e ferramentas opcionais</b></summary>

| 🧩 Nós | 🛠️ Ferramentas |
|---|---|
| [Nunchaku](https://github.com/nunchaku-ai/nunchaku) | Easy-Modelos-Linker |
| [SageAttention (v2.2.0 and v3)](https://github.com/woct0rdho/SageAttention) | Easy-System-Checker |
| [FlashAttention](https://github.com/Dao-AILab/flash-attention) | ComfyUI-Version-Switcher |
| [InsightFace](https://github.com/deepinsight/insightface) | Easy-model2GGUF |
| [Trellis 2.0](https://github.com/visualbruno/ComfyUI-Trellis2) | Long-Paths-Enabler |
| | Torch-Pack |
| | Toggle-DynamicVRAM |
| | Update Easy-Instalar |

</details>

---

## 🖥️ Instalação no Windows

> [!IMPORTANT]
> - Não execute o instalador como **Administrador**.
> - Evite pastas do sistema (`Program Files`, `Windows`, raiz de `C:\`).
> - Evite espaços e caracteres especiais nos nomes das pastas.
> - Certifique-se de que os drivers NVIDIA estejam atualizados.

1. [**📥 BAIXAR A VERSÃO MAIS RECENTE**](https://github.com/Tavris1/ComfyUI-Easy-Instalar/releases/latest/download/ComfyUI-Easy-Instalar.zip)
2. Extraia o ZIP para uma nova pasta e execute **`ComfyUI-Easy-Instalar.bat`**
3. Após a configuração, opcionalmente instale ou execute componentes pela pasta **Add-ons** ou pelo **EZi Desktop Menu**:
    - **Easy-Modelos-Linker** - *Usa a pasta **MODELS** existente por meio do **extra_model_paths.yaml**, sem necessidade de baixar novamente*
      - *Algumas pastas, como **LLM** e **llm_gguf**, não podem ser redirecionadas dessa forma*
    - **Easy-System-Checker** - *Fornece informações sobre os principais componentes de hardware e software*
    - **Nunchaku** - *Instala o Nunchaku. (Execute `Nunchaku.bat` novamente se ocorrerem problemas depois)*
    - **SageAttention-Multi** - *Instala o SageAttention v2.2.0 e v3 (v3 funciona apenas em GPUs NVIDIA série 50)*
    - **FlashAttention** - *Instala o FlashAttention v2.8.3*
    - **InsightFace** - *Instala o InsightFace (modelos pré-treinados apenas para pesquisa não comercial)*
    - **Trellis2** - *Instala o Trellis 2.0 e o modelo (requer `Torch 2.8.0+cu128` de `Add-ons/Torch-Pack`)*
    - **Torch-Pack** - *Alternância rápida entre:*  
      - *`Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`, `Torch 2.9.1+cu130`, `Torch 2.10+cu130` & `Torch 2.11+cu130`*
    - **Easy-model2GGUF** - *Converte e quantiza modelos para GGUF (Q2_K–Q8_0), com correções de tensores 5D quando disponíveis*
    - **Long-Paths-Enabler** - *Ativa **Long Paths** no Windows 10/11. Essencial para Python/ComfyUI*
    - **ComfyUI-Version-Switcher** - *Permite reverter de forma **reversível** para uma versão **anterior** do ComfyUI se ocorrerem problemas*
    - **Toggle-DynamicVRAM** - *Alterna a opção **--disable-dynamic-vram** nos arquivos de inicialização do ComfyUI*
    - **Update Easy-Instalar** - *Atualiza **Add-ons** e outras pastas. Cria atalhos na área de trabalho*
    - **EZi Desktop Themes** - *pelo EZi Desktop > Menu > Advanced*
    - **Pastas Input, Output e User personalizadas** - *pelo EZi Desktop > Menu > Advanced*
    - **Alterador de versões do ComfyUI e frontend** - *pelo EZi Desktop > Menu > Advanced*
    - **Limpador de cache do UV e PIP** - *pelo EZi Desktop > Menu*
    - **ComfyUI-Manager Security-Level Config** - *Configuração fácil de security_level pelo EZi Desktop > Menu*
    - **Pinned-Packages-Manager** - *Fixe versões de pacotes como NumPy==1.26.4 pelo EZi Desktop > Menu*

<div align="center">

---

## ❤️ Apoiar o desenvolvimento

Gostou do projeto?  
Se ele economiza seu tempo, seu apoio ajuda a manter o desenvolvimento e a manutenção.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/Tavris1?style=for-the-badge&logo=github)](https://github.com/sponsors/Tavris1)

</div>
