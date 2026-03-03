<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
<strong>Português</strong> |
<a href="README.ru.md#ru">Русский</a> |
<a href="README.de.md#de">Deutsch</a> |
<a href="README.fr.md#fr">Français</a> |
<a href="README.vi.md#vi">Tiếng Việt</a>
</p>

---

# ComfyUI-Easy-Install
> **ComfyUI** portátil com um clique para **Windows** 🔹 GPUs Nvidia 🔹 Edição Comunidade Pixaroma 🔹  
> [![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
> [![GitHun Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
> [![Github All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)]()
> [![GitHub Downloads latest)](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=downloads%40latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
>
> Dedicado à equipe **Pixaroma**  
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Join%20Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_presence_count&logo=discord&logoColor=white&label=Online&color=blue&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)

---

## Componentes incluídos:  
- **Git** *(será instalado ou atualizado se necessário)*  
- **ComfyUI portátil**  
- **Python 3.12.10** *(versão portátil incorporada)*  

### Nodes dos tutoriais da Pixaroma no [YouTube](https://www.youtube.com/@pixaroma)

||||||
|---|---|---|---|---|
ComfyUI Manager | Tiled Diffusion & VAE | LayerStyle | rgthree | GGUF
VideoHelperSuite | Inpaint-CropAndStitch | SCAIL-Pose | KJNodes | iTools
Comfyroll Studio | SeedVR2_VideoUpscaler | ControlNet Aux | Easy-Use | RMBG
WanVideoWrapper | WanAnimatePreprocess | MelBandRoFormer | Easy-Sam3 | QwenVL
Qwen3-TTS

### Nodes adicionais opcionais
||||||
|---|---|---|---|---|
Nunchaku | SageAttention-Multi (v2.2.0 and v3) | FlashAttention | Trellis 2.0 | InsightFace

### Ferramentas adicionais
||||||
|---|---|---|---|---|
Easy-Models-Linker | Torch-Pack | Easy-model2GGUF | Long-Paths-Enabler | ComfyUI-Version-Switcher

---

## Instalação no Windows
1. Baixe a [:arrow_forward:**última versão AQUI**◀️](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Extraia o arquivo ZIP para uma nova pasta e execute **`ComfyUI-Easy-Install.bat`** para iniciar a instalação
3. Após a instalação, você pode opcionalmente instalar ou executar os seguintes componentes na pasta **Add-ons**:
    - **Easy-Models-Linker** - *Usa a pasta **MODELS** existente via **extra_model_paths.yaml**, sem necessidade de novo download*
      - *Algumas pastas como **LLM** e **llm_gguf** não podem ser redirecionadas dessa forma*
    - **Nunchaku** - *Instala o Nunchaku. Execute `Nunchaku.bat` novamente caso ocorram problemas posteriormente*
    - **SageAttention-Multi** - *Instala SageAttention v2.2.0 e v3 (v3 efetivo apenas em GPUs NVIDIA série 50)*
    - **FlashAttention** - *Instala FlashAttention v2.8.3*
    - **InsightFace** - *Instala InsightFace (modelos pré-treinados apenas para pesquisa não comercial)*
    - **Trellis2** - *Instala Trellis 2.0 e o modelo (requer `Torch 2.8.0+cu128` de `Add-ons/Torch-Pack`)*
    - **Torch-Pack** - *Alternância rápida entre:*
      - ***Torch 2.7.1+cu128***
      - ***Torch 2.8.0+cu128***
      - ***Torch 2.9.1+cu130** (padrão, requer driver NVIDIA v580+)*  
    - **Easy-model2GGUF** *(**Add-Ons/Tools**)*  
      - *Converte modelos (`.safetensors`, `.pth`, `.pt`) para o formato **GGUF** (FP16 ou BF16) em poucos minutos*  
      - *Quantiza modelos com opções de **Q2_K** até **Q8_0** e aplica **correções de tensor 5D** quando disponíveis*  
    - **Long-Paths-Enabler** *(`Add-Ons/Tools`)* - *Ativa **Long Paths** no Windows 10/11. Essencial para Python/ComfyUI*  
    - **ComfyUI-Version-Switcher** *(`Add-Ons/Tools`)* - ***Reversão** para uma versão **anterior** do ComfyUI em caso de problemas*  
    - **Update Easy-Install.bat** *(pasta principal)* - *Atualiza **Add-ons** e outras pastas. Cria atalhos na área de trabalho*  

> [!IMPORTANT]
> - Não execute o instalador como **Administrador**.
> - Evite pastas do sistema (`Program Files`, `Windows`, raiz `C:\`).
> - Evite espaços e caracteres especiais nos nomes das pastas.
> - Certifique-se de que seus drivers NVIDIA estejam atualizados.

> [!TIP]
> - São permitidas múltiplas instalações do ComfyUI sem conflitos.
> - Você pode renomear ou mover a pasta `ComfyUI-Easy-Install` após a instalação.
> - Para macOS / Linux clique [here](https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux)

---

<img width="1038" height="240" alt="123321" src="https://github.com/user-attachments/assets/6d0655ef-8724-4cb1-bce2-a29fc9004173" />

---

Se você gosta dos meus projetos, considere me apoiar. Qualquer apoio é muito apreciado!

💜 PayPal: https://paypal.me/tavris1  
☕ Buy Me a Coffee: https://buymeacoffee.com/tavris1  
❤️ GitHub Sponsors: https://github.com/sponsors/Tavris1  
