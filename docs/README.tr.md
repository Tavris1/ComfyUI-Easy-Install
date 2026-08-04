<a id="tr"></a>

<p align="center">
🌍 
<a href="../README.md#english">English</a> |
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
  <img src="docs/EZi-Logo.svg" width="120" alt="EZi Logo">
  <h1>ComfyUI-Easy-Kurulum</h1>
  <p align="center">
    <strong>EZi Desktop ile Tek Tıkla Taşınabilir ComfyUI</strong><br />
    Windows • NVIDIA GPU'lar • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/Tavris1/ComfyUI-Easy-Install/Windows/.github/badges/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

  <p align="center">
    <a href="#%EF%B8%8F-windows-installation">📥 Kurulum</a> &nbsp;·&nbsp;
    <a href="#-features">✨ Özellikler/Bileşenler</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-Kurulum/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#%EF%B8%8F-support-development">❤️ Geliştirmeyi Destekle</a>
  </p>

---

![ComfyUI Screenshot](docs/ComfyUI-ivo.jpg)

</div>

## ✨ Özellikler

****ComfyUI-Easy-Kurulum**, **EZi Desktop** ile taşınabilir bir ComfyUI ortamı sağlar.  
Manuel Python veya Git kurulumu gerekmez.

Nunchaku, SageAttention, FlashAttention, InsightFace ve Trellis 2.0 gibi karmaşık paketleri tek tıkla kurun.

**Modelleri, paketleri, PyTorch/CUDA sürümlerini, Dynamic VRAM'ı, ComfyUI/frontend sürümlerini, UV/PIP önbelleklerini ve GGUF dönüşümünü** tek yerden yönetin.

## 📦 Dahil Bileşenler
<details open>
<summary><b>Temel Bileşenler</b></summary>

| 🔧 Bileşen | 📝 Not |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - En yeni (gerekirse kurulur/güncellenir) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - Gömülü sürüm |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - En yeni kararlı sürüm |

</details>

<details>
<summary><b>Pixaroma Eğitimlerinde Kullanılan Node'lar</b></summary>

| 🖼️ Görüntü | 🎬 Video | 🎵 Ses | 🧩 Yardımcı / WF | 🤖 Modeller |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [WanVideoWrapper](https://github.com/kijai/ComfyUI-WanVideoWrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | [FishSesS2](https://github.com/Saganaki22/ComfyUI-FishSesS2) | [KJNode'lar](https://github.com/kijai/ComfyUI-KJNode'lar) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SeedVR2 VideoUpscaler](https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | | | [iAraçlar](https://github.com/MohammadAboulEla/ComfyUI-iAraçlar) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI Node'lar](https://github.com/gseth/ControlAltAI-Node'lar) | |
| [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | | ✨[Pixaroma](https://github.com/pixaroma/ComfyUI-Pixaroma) | |
| | | | [Krea2T-Enhancer](https://github.com/capitan01R/ComfyUI-Krea2T-Enhancer) | |
| | | | [Krea2Edit](https://github.com/lbouaraba/comfyui-krea2edit) | |

</details>

<details>
<summary><b>İsteğe Bağlı Eklentiler ve Araçlar</b></summary>

| 🧩 Node'lar | 🛠️ Araçlar |
|---|---|
| [Nunchaku](https://github.com/nunchaku-ai/nunchaku) | Easy-Modeller-Linker |
| [SageAttention (v2.2.0 and v3)](https://github.com/woct0rdho/SageAttention) | Easy-System-Checker |
| [FlashAttention](https://github.com/Dao-AILab/flash-attention) | ComfyUI-Version-Switcher |
| [InsightFace](https://github.com/deepinsight/insightface) | Easy-model2GGUF |
| [Trellis 2.0](https://github.com/visualbruno/ComfyUI-Trellis2) | Long-Paths-Enabler |
| | Torch-Pack |
| | Toggle-DynamicVRAM |
| | Update Easy-Kurulum |

</details>

---

## 🖥️ Windows Kurulumu

> [!IMPORTANT]
> - Yükleyiciyi **Yönetici** olarak çalıştırmayın.
> - Sistem klasörlerinden (`Program Files`, `Windows`, `C:\` kökü) kaçının.
> - Klasör adlarında boşluk ve özel karakter kullanmaktan kaçının.
> - NVIDIA sürücülerinizin güncel olduğundan emin olun.

1. [**📥 EN SON SÜRÜMÜ İNDİR**](https://github.com/Tavris1/ComfyUI-Easy-Kurulum/releases/latest/download/ComfyUI-Easy-Kurulum.zip)
2. ZIP dosyasını yeni bir klasöre çıkarın ve **`ComfyUI-Easy-Kurulum.bat`** dosyasını çalıştırın.
3. Kurulumdan sonra isteğe bağlı olarak **Add-ons** klasöründen veya **EZi Desktop Menu** üzerinden bileşenleri kurun ya da çalıştırın:
    - **Easy-Modeller-Linker** - ***extra_model_paths.yaml** üzerinden mevcut **MODELS** klasörünü kullanır; yeniden indirme gerekmez*
      - ***LLM** ve **llm_gguf** gibi bazı klasörler bu şekilde yönlendirilemez*
    - **Easy-System-Checker** - *Temel donanım ve yazılım bileşenleri hakkında bilgi sağlar*
    - **Nunchaku** - *Nunchaku'yu kurar. (Daha sonra sorun oluşursa `Nunchaku.bat` dosyasını tekrar çalıştırın)*
    - **SageAttention-Multi** - *SageAttention v2.2.0 ve v3'ü birlikte kurar (v3 yalnızca NVIDIA 50 serisi GPU'larda etkilidir)*
    - **FlashAttention** - *FlashAttention v2.8.3'ü kurar*
    - **InsightFace** - *InsightFace'i kurar (önceden eğitilmiş modeller yalnızca ticari olmayan araştırmalar içindir)*
    - **Trellis2** - *Trellis 2.0 ve modeli kurar (`Add-ons/Torch-Pack` içindeki `Torch 2.8.0+cu128` gereklidir)*
    - **Torch-Pack** - *Şunlar arasında hızlı geçiş:*  
      - *`Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`, `Torch 2.9.1+cu130`, `Torch 2.10+cu130` & `Torch 2.11+cu130`*
    - **Easy-model2GGUF** - *Modelleri GGUF'a (Q2_K–Q8_0) dönüştürür ve nicemler; mümkünse 5D tensör düzeltmelerini uygular*
    - **Long-Paths-Enabler** - *Windows 10/11'de **Long Paths** özelliğini etkinleştirir. Python/ComfyUI için gereklidir*
    - **ComfyUI-Version-Switcher** - *Sorun oluşursa **önceki** bir ComfyUI sürümüne **geri alınabilir** dönüş sağlar*
    - **Toggle-DynamicVRAM** - *ComfyUI başlangıç dosyalarındaki **--disable-dynamic-vram** seçeneğini açıp kapatır*
    - **Update Easy-Kurulum** - ***Add-ons** ve diğer klasörleri günceller. Masaüstü kısayolları oluşturur*
    - **EZi Desktop Themes** - *EZi Desktop > Menu > Advanced üzerinden*
    - **Özel Input, Output ve User klasörleri** - *EZi Desktop > Menu > Advanced üzerinden*
    - **ComfyUI ve frontend sürüm değiştirici** - *EZi Desktop > Menu > Advanced üzerinden*
    - **UV ve PIP önbellek temizleyici** - *EZi Desktop > Menu üzerinden*
    - **ComfyUI-Manager Security-Level Config** - *security_level ayarını EZi Desktop > Menu üzerinden kolayca yapılandırın*
    - **Pinned-Packages-Manager** - *NumPy==1.26.4 gibi paket sürümlerini EZi Desktop > Menu üzerinden sabitleyin*

<div align="center">

---

## ❤️ Geliştirmeyi Destekle

Projeyi beğendiniz mi?  
Size zaman kazandırıyorsa desteğiniz geliştirme ve bakım çalışmalarının sürmesine yardımcı olur.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
