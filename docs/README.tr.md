<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<a href="README.ja.md#ja">日本語</a> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<a href="README.de.md#de">Deutsch</a> |
<a href="README.fr.md#fr">Français</a> |
<a href="README.ru.md#ru">Русский</a> |
<strong>Türkçe</strong> |
<a href="README.vi.md#vi">Tiếng Việt</a>
</p>

---

<div align="center">
  <img src="EZi-Logo.svg" width="120" alt="EZi Logo">
  <h1>ComfyUI-Easy-Install</h1>
  <p align="center">
    <strong>EZi Desktop ile tek tıkla taşınabilir ComfyUI: paketler, ortamlar ve yapılandırma için eksiksiz bir kontrol paneli</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)


<!--[![GitHub All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)-->
<!--[![GitHub Downloads Latest](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=⬇+latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)-->

  <p align="center">
    <a href="#%EF%B8%8F-windows-kurulumu">📥 Yükle</a> &nbsp;·&nbsp;
    <a href="#-özellikler">✨ Özellikler/Bileşenler</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#%EF%B8%8F-geliştirmeyi-destekle">❤️ Geliştirmeyi Destekle</a>
  </p>

<!-- **Pixaroma** topluluğuna adanmıştır  
[![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
-->

---

![ComfyUI Screenshot](ComfyUI-ivo.jpg)

</div>

## ✨ Özellikler

**ComfyUI-Easy-Install**, **EZi Desktop** ile taşınabilir bir ComfyUI ortamı sağlar.  
Manuel Python veya Git kurulumu gerekmez.

Nunchaku, SageAttention, FlashAttention, InsightFace ve Trellis 2.0 gibi karmaşık paketleri tek tıklamayla yükleyin.

**Modelleri, paketleri, PyTorch/CUDA sürümlerini, Dynamic VRAM'i,  
ComfyUI/frontend sürümlerini, UV/PIP önbelleklerini ve GGUF dönüştürmeyi** tek bir yerden yönetin.

## 📦 Dahil Edilen Bileşenler
<details open>
<summary><b>Temel Bileşenler</b></summary>

| 🔧 Bileşen | 📝 Not |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - En son sürüm (gerekirse yüklenir/güncellenir) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - Gömülü sürüm |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - En son kararlı sürüm |

</details>

<details>
<summary><b>Pixaroma Eğitimlerinde Kullanılan Nodes</b></summary>

| 🖼️ Görsel | 🎬 Video | 🎵 Ses | 🧩 Utility / WF | 🤖 Modeller |
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
<summary><b>İsteğe Bağlı Add-ons & Tools</b></summary>

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

## 🖥️ Windows Kurulumu

> [!IMPORTANT]
> - Yükleyiciyi **Administrator** olarak çalıştırmayın.
> - Sistem klasörlerinden kaçının (`Program Files`, `Windows`, `C:\` root).
> - Klasör adlarında boşluk ve özel karakter kullanmaktan kaçının.
> - NVIDIA sürücülerinizin güncel olduğundan emin olun.

1. [**📥 EN SON SÜRÜMÜ İNDİR**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. ZIP dosyasını yeni bir klasöre çıkarın ve **`ComfyUI-Easy-Install.bat`** dosyasını çalıştırın
3. Kurulumdan sonra isteğe bağlı olarak **Add-ons** klasöründen veya **EZi Desktop Menu** üzerinden bileşenleri yükleyebilir ya da çalıştırabilirsiniz:
    - **Easy-Models-Linker** - *Mevcut **MODELS** klasörünü **extra_model_paths.yaml** üzerinden kullanır, yeniden indirme gerekmez*
      - *Bazı klasörler, örneğin **LLM** ve **llm_gguf**, bu şekilde yönlendirilemez*
    - **Easy-System-Checker** - *Temel donanım ve yazılım bileşenleri hakkında bilgi sağlar*
    - **Nunchaku** - *Nunchaku'yu yükler*
    - **SageAttention-Multi** - *Hem SageAttention v2.2.0 hem de v3'ü yükler (v3 yalnızca NVIDIA 50-series GPUs üzerinde etkilidir)*
    - **FlashAttention** - *FlashAttention v2.8.3'ü yükler*
    - **InsightFace** - *InsightFace'i yükler (Pretrained models for non-commercial research only)*
    - **Trellis2** - *Trellis 2.0'ı ve modeli yükler (`Add-ons/Torch-Pack` içindeki `Torch 2.8.0+cu128` gereklidir)*
    - **Torch-Pack** - *Şunlar arasında hızlı geçiş sağlar:`Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`,  
      `Torch 2.9.1+cu130`, `Torch 2.10+cu130`, `Torch 2.11+cu130`, `Torch 2.12.1+cu130` & `Torch 2.13.0+cu130`*
    - **Easy-model2GGUF** - *Modelleri GGUF'a (Q2_K–Q8_0) dönüştürür ve quantize eder; mevcutsa 5D tensor düzeltmelerini uygular*
    - **Long-Paths-Enabler** - *Windows 10/11'de **Long Paths** özelliğini etkinleştirir. Python/ComfyUI için gereklidir*
    - **ComfyUI-Version-Switcher** - *Sorun oluşması durumunda **önceki** bir ComfyUI sürümüne ***geri alınabilir** rollback* sağlar*
    - **Toggle-DynamicVRAM** - *ComfyUI başlangıç dosyalarındaki **--disable-dynamic-vram** seçeneğini açar/kapatır*
    - **Update Easy-Install** - ***Add-ons** ve diğer klasörleri günceller. Masaüstü kısayolları oluşturur*
    - **EZi Desktop Themes** - *EZi Desktop > Menu > Advanced üzerinden*
    - **Custom Input, Output & User folders** - *EZi Desktop > Menu > Advanced üzerinden*
    - **ComfyUI & Frontend Version Changer** - *EZi Desktop > Menu > Advanced üzerinden*
    - **UV & PIP cache cleaner** - *EZi Desktop > Menu üzerinden*
    - **ComfyUI-Manager Security-Level Config** - *security_level ayarını EZi Desktop > Menu üzerinden kolayca yapılandırır*
    - **Pinned-Packages-Manager** - *NumPy==1.26.4 gibi paket sürümlerini EZi Desktop > Menu üzerinden sabitler*

<div align="center">

---

## ❤️ Geliştirmeyi Destekle

Projeyi beğendiniz mi?  
Size zaman kazandırıyorsa, desteğiniz geliştirme ve bakım çalışmalarının devam etmesine yardımcı olur.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
