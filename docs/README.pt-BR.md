<a id="pt-br"></a>

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
    <strong>Instale o ComfyUI portátil com um clique e use o EZi Desktop para gerenciar e personalizar tudo em um só lugar.</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

<p align="center">
  <a href="#install">📥 <strong>Instalar</strong></a> &nbsp;·&nbsp;
  <a href="#features">✨ Recursos</a> &nbsp;·&nbsp;
  <a href="#requirements">💻 Requisitos</a> &nbsp;·&nbsp;
  <a href="#help">🩺 Ajuda</a> &nbsp;·&nbsp;
  <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
  <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
  <a href="#support">❤️ Apoiar</a>
</p>

<br>

![ComfyUI Screenshot](ComfyUI-ivo.png)

**Está começando com o EZi?** [Guia do EZi em quadrinhos](#comic)

</div>

<a id="features"></a>

## ✨ Recursos

**ComfyUI-Easy-Install** instala uma versão portátil do ComfyUI com Python próprio, nós prontos para uso e **EZi Desktop**.

- **Um clique** - Configuração automática de Git, Python, PyTorch, ComfyUI e nós
- **Sem configuração manual** - Python, ComfyUI e modelos na mesma pasta
- **Complementos com um clique** - Nunchaku, SageAttention, FlashAttention, InsightFace e outros
- **EZi Desktop** - Janela própria com console inteligente e menu
  - Versões de PyTorch/CUDA (Torch-Pack)
  - Versões do ComfyUI e da interface
  - Pastas de modelos e pastas Input/Output/User
  - Argumentos de inicialização e VRAM dinâmica
  - Configurações do ComfyUI-Manager e versões fixas de pacotes
  - Cache UV/PIP e conversão para GGUF
- **EZi Launcher** - Inicie, atualize, abra pastas, salve e restaure snapshots

<details>
<summary><b>O que o EZi Desktop permite fazer</b></summary>

- Executar o ComfyUI em uma janela própria, no navegador ou nos dois
- Receber notificações de novas versões do ComfyUI e do EZi
- Baixar modelos diretamente na pasta certa
- **Console**
  - Pesquisar (Ctrl+F) e salvar o log em .txt (Ctrl+S)
  - Destacar o console em outra janela
  - Copiar ou salvar a seleção, pesquisar no Google ou consultar Claude ou ChatGPT
- **Captura** - Captura ou gravação de tela
- **Pastas de modelos** - Vincule várias pastas existentes
- **Pastas Input, Output e User personalizadas**
- **Argumentos de inicialização** - Editor com todas as opções
- **ComfyUI-Manager** - Interface nova ou antiga, nível de segurança e instalações via pip ou URL do Git
- **Gerenciador de versões fixas** - Fixe versões como `numpy==1.26.4`
- **Cache de pacotes** - Mantenha ou limpe o cache UV/PIP
- **Informações do sistema** - GPU, RAM, Python, Torch, ComfyUI, caminhos longos
- Temas, tamanho do texto, dicas e fundo do console
- Links para os fluxos e o curso de ComfyUI da Pixaroma

</details>

---

<a id="requirements"></a>

## 💻 Requisitos

| | |
|---|---|
| **Sistema operacional** | Windows 10 / 11, 64 bits |
| **GPU** | NVIDIA RTX série 20 ou mais recente |
| **Driver** | NVIDIA 580 ou mais recente (recomendado) |
| **RAM** | Mínimo de 8 GB, recomendados 16 GB ou mais |
| **Disco** | Pelo menos 15 GB livres mais espaço para os modelos (SSD recomendado) |
| **Internet** | Necessária durante a instalação |

> [!NOTE]
> Com driver anterior ao **580**, o instalador usa **CUDA 12.8** e **Torch 2.8.0**. Atualize o driver para usar **CUDA 13.0** e **Torch 2.11.0**.

---

<a id="install"></a>

## 🖥️ Instalação no Windows

> [!IMPORTANT]
> - Use um caminho curto com caracteres do alfabeto inglês, como `D:\AI\`.

1. [**📥 Baixar a versão mais recente**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. Extraia o ZIP em uma nova pasta
3. Execute **`ComfyUI-Easy-Install.bat`**
4. Aguarde o término da instalação
5. Clique em **Start ComfyUI** ou abra o atalho **ComfyUI-EZi Launcher** na área de trabalho

<details>
<summary><b>O que será instalado</b></summary>

| Componente | Versão |
|---|---|
| [Git](https://git-scm.com/) | Versão mais recente, somente se o Git estiver ausente |
| [Python](https://www.python.org/downloads/release/python-31210/) | 3.12.10 Integrado, com soma de verificação conferida |
| PyTorch | 2.11.0 + CUDA 13.0 ou 2.8.0 + CUDA 12.8 |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | Versão mais recente |
| ComfyUI-Manager, Triton, ONNX Runtime GPU, llama-cpp-python | |
| [Nós incluídos](#nodes) | Nós dos tutoriais da Pixaroma |
| Fluxos para começar | Juggernaut Reborn, Z-Image Turbo |
| Mídia de exemplo | Na pasta `ComfyUI\input` |
| ComfyUI-EZi Launcher | Atalho na área de trabalho |

</details>

---

<a id="start"></a>

## ▶️ Iniciar o ComfyUI

Abra **ComfyUI-EZi Launcher** e escolha um modo.

- **Desktop** - Na janela do EZi Desktop
- **Browser** - No navegador com o console clássico
- **Hybrid** - No navegador com o console do EZi

Inicie com **KitchenAttention**, **SageAttention** ou **FlashAttention**. Para Sage e Flash, instale o complemento primeiro.

---

<a id="addons"></a>

## 🧩 Complementos

Os complementos ficam em **Add-ons**. A maioria também está em **EZi Desktop > Menu**.

| Complemento | Função |
|---|---|
| **Easy-Models-Linker** | Reutiliza a pasta **models**.<br>Não se aplica a **LLM** e **llm_gguf**. |
| **Easy-System-Checker** | Exibe informações de hardware e software |
| **Nunchaku** | Instala [Nunchaku](https://github.com/nunchaku-ai/nunchaku) |
| **SageAttention-Multi** | Instala [SageAttention](https://github.com/woct0rdho/SageAttention) v2.2.0 e v3 (v3 somente na RTX 50) |
| **FlashAttention** | Instala [FlashAttention](https://github.com/Dao-AILab/flash-attention) v2.8.3 |
| **InsightFace** | Instala [InsightFace](https://github.com/deepinsight/insightface) |
| **Trellis2 + Pixal3D** | Instala [Trellis 2.0 + Pixal3D @visualbruno](https://github.com/visualbruno/ComfyUI-Trellis2) e o modelo |
| **Torch-Pack** | Alterna versões de PyTorch e CUDA |
| **Easy-model2GGUF** | Converte modelos para GGUF (Q2_K a Q8_0) |
| **Long-Paths-Enabler** | Ativa caminhos longos no Windows |
| **Toggle-DynamicVRAM** | Ativa ou desativa `--disable-dynamic-vram` |

<details>
<summary><b>Versões do Torch-Pack e compatibilidade com complementos</b></summary>

| Torch | CUDA | Nunchaku | Sage v2 | Sage v3 | Flash | Trellis2 |
|---|---|:---:|:---:|:---:|:---:|:---:|
| 2.7.1 | 12.8 | ✅ | ✅ | ✅ | ✅ | |
| 2.8.0 | 12.8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2.9.1 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.10.0 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| **2.11.0** (padrão) | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.12.1 | 13.0 | | ✅ | | ✅ | |
| 2.13.0 | 13.0 | | ✅ | | ✅ | |
| 2.14.1 | 13.0 | | ✅ | | ✅ | |

</details>

---

<a id="updates"></a>

## 🔄 Atualizações

Atualize o ComfyUI, os nós e o EZi pelo inicializador. Salve um snapshot antes de mudanças importantes para restaurá-lo com um clique.

---

<a id="help"></a>

## 🩺 Solução de problemas

<details>
<summary><b>O instalador parou ou exibe erros</b></summary>

- Se a instalação parar, clique em **Show log** e use **Copy details** para compartilhar os detalhes no [Discord da Pixaroma](https://discord.gg/gggpkVgBf3).
- O log completo está em `ComfyUI-Easy-Install.log`.
- Exclua a pasta incompleta `ComfyUI-Easy-Install` antes de tentar de novo.

</details>

<details>
<summary><b>Windows 11: "Bad Image" (0xc0e90002)</b></summary>

- No Windows 11, se aparecer “Bad Image” (0xc0e90002), desative o Smart App Control e reinicie o ComfyUI.
- Isso reduz a proteção contra aplicativos não confiáveis.
- Leia o aviso do Windows antes de confirmar.

</details>

<details>
<summary><b>Arquivos ausentes ou bloqueados</b></summary>

- Se faltarem arquivos, confira o histórico de proteção na Segurança do Windows.
- O antivírus pode ter bloqueado arquivos do Python.
- Permita os arquivos, exclua a pasta e reinstale.

</details>

<details>
<summary><b>Driver NVIDIA não detectado</b></summary>

- Se o driver não for detectado, instale a versão mais recente em [nvidia.com/drivers](https://www.nvidia.com/drivers) e teste `nvidia-smi` em um terminal.

</details>

<details>
<summary><b>Caminho ou nome de usuário com caracteres fora do alfabeto inglês</b></summary>

- Mova o instalador para um caminho como `D:\AI\`.
- Caracteres fora do alfabeto inglês no nome de usuário do Windows ainda podem causar problemas.

</details>

<details>
<summary><b>"ComfyUI is already running"</b></summary>

- “ComfyUI is already running” indica que a porta (8188 por padrão) está em uso.
- Feche a outra janela do ComfyUI e tente novamente.

</details>

<details>
<summary><b>Erros com caminhos longos</b></summary>

- Para erros de caminho longo, execute **Long-Paths-Enabler** em **Add-ons\Tools**.

</details>

---

<a id="uninstall"></a>

## 🧹 Desinstalação

Exclua a pasta `ComfyUI-Easy-Install` e o atalho **ComfyUI-EZi Launcher** da área de trabalho.

---

<a id="nodes"></a>

## 📦 Nós incluídos

<details>
<summary><b>Nós dos tutoriais da Pixaroma</b></summary>

| 🖼️ Imagem | 🎬 Vídeo | 🎵 Áudio | 🧩 Utilitários e fluxos | 🤖 Modelos |
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

## 🎭 Guia do EZi em quadrinhos

Está começando com o EZi? Clique em qualquer imagem dos quadrinhos para vê-la em tamanho original.

<table width="100%">
  <tr>
    <th width="16.66%">Instalar ComfyUI</th>
    <th width="16.66%">Inicializador EZi</th>
    <th width="16.66%">Reutilizar modelos</th>
    <th width="16.66%">Instalar complementos</th>
    <th width="16.66%">Atualizar e restaurar</th>
    <th width="16.66%">Seu sistema</th>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6"><img src="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6" width="100%" alt="Instalar ComfyUI"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9"><img src="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9" width="100%" alt="Inicializador EZi"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901"><img src="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901" width="100%" alt="Reutilizar modelos"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b"><img src="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b" width="100%" alt="Instalar complementos"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6"><img src="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6" width="100%" alt="Atualizar e restaurar"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3"><img src="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3" width="100%" alt="Seu sistema"></a></td>
  </tr>
</table>

<div align="center">

<a id="support"></a>

## ❤️ Apoie o desenvolvimento

Se você gosta do projeto, sua contribuição ajuda a manter o desenvolvimento.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
