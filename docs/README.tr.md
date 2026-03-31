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

# ComfyUI-Easy-Install
**Windows** 🔹 Nvidia GPU'lar için tek tıklamayla taşınabilir **ComfyUI** kurucusu  
[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![GitHub All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![GitHub Downloads Latest](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=⬇+latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)

**Pixaroma** ekibine adanmıştır  
[![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Join%20Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)

![ComfyUI Screenshot](ComfyUI-ivo.jpg)

ComfyUI-Easy-Install, tek tıklamayla tamamen yapılandırılmış ve taşınabilir bir ComfyUI'dir. Python kurulumu yok, manuel bağımlılık yok.

</div>

## 📦 Dahil Edilen Bileşenler
<details>
<summary><b>Temel Bileşenler</b></summary>

| 🔧 Bileşen | 📝 Not |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - En son sürüm (gerekirse kurulacak/güncellenecek) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - Embedded sürüm |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - En son sürüm |

</details>

<details>
<summary><b>Pixaroma eğitimlerinden node'lar</b></summary>

| 🖼️ Görüntü | 🎬 Video | 🎵 Ses | 🧩 Yardımcı / WF | 🤖 Modeller |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [WanVideoWrapper](https://github.com/kijai/ComfyUI-WanVideoWrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | [FishAudioS2](https://github.com/Saganaki22/ComfyUI-FishAudioS2) | [KJNodes](https://github.com/kijai/ComfyUI-KJNodes) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SeedVR2 VideoUpscaler](https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | | | [iTools](https://github.com/MohammadAboulEla/ComfyUI-iTools) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI Nodes](https://github.com/gseth/ControlAltAI-Nodes) | |
| [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | | ✨[Pixaroma](https://github.com/pixaroma/ComfyUI-Pixaroma) | |

</details>

<details>
<summary><b>İsteğe Bağlı Ek Node'lar ve Araçlar</b></summary>

| 🧩 Node'lar | 🛠️ Araçlar |
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
1. [**▶️ BURAYA TIKLAYIN ◀️**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip) en son sürümü indirmek için
2. ZIP dosyasını yeni bir klasöre çıkarın ve **`ComfyUI-Easy-Install.bat`** dosyasını çalıştırın
3. Kurulumdan sonra **Add-ons** klasöründen aşağıdaki bileşenleri kurabilir veya çalıştırabilirsiniz:
    - **Easy-Models-Linker** - *Mevcut **MODELS** klasörünü **extra_model_paths.yaml** aracılığıyla kullanır, yeniden indirme gerekmez*
      - *Bazı klasörler (**LLM** ve **llm_gguf** gibi) bu şekilde yönlendirilemez*
    - **Easy-System-Checker** - *Temel donanım ve yazılım bileşenleri hakkında bilgi sağlar*
    - **Nunchaku** - *Nunchaku'yu kurar. (Daha sonra sorun oluşursa `Nunchaku.bat` dosyasını tekrar çalıştırın)*
    - **SageAttention-Multi** - *Hem SageAttention v2.2.0 hem de v3'ü kurar (v3 yalnızca NVIDIA 50 serisi GPU'larda etkilidir)*
    - **FlashAttention** - *FlashAttention v2.8.3'ü kurar*
    - **InsightFace** - *InsightFace'i kurar (Önceden eğitilmiş modeller yalnızca ticari olmayan araştırmalar için)*
    - **Trellis2** - *Trellis 2.0 ve modeli kurar (`Add-ons/Torch-Pack` içindeki `Torch 2.8.0+cu128` gereklidir)*
    - **Torch-Pack** - *Şunlar arasında hızlı geçiş: `Torch 2.7.1+cu128`, `Torch 2.8.0+cu128` ve `Torch 2.9.1+cu130`*
    - **Easy-model2GGUF** - *Modelleri GGUF'a dönüştürür ve quantize eder (Q2_K–Q8_0) ve varsa 5D tensor düzeltmeleri uygular*
    - **Long-Paths-Enabler** - *Windows 10/11'de **Long Paths** özelliğini etkinleştirir. Python/ComfyUI için gereklidir*
    - **ComfyUI-Version-Switcher** - *Sorun durumunda önceki bir ComfyUI sürümüne **geri döndürme** (reversible)*
    - **Toggle-DynamicVRAM** - *ComfyUI başlangıç dosyalarındaki **--disable-dynamic-vram** seçeneğini açıp kapatır*
    - **Update Easy-Install** - ***Add-ons** ve diğer klasörleri günceller. Masaüstü kısayolları oluşturur*
> [!IMPORTANT]
> - Kurucuyu **Administrator** olarak çalıştırmayın.
> - Sistem klasörlerinden kaçının (`Program Files`, `Windows`, `C:\` kökü).
> - Klasör adlarında boşluk ve özel karakterlerden kaçının.
> - NVIDIA sürücülerinizin güncel olduğundan emin olun.

> [!TIP]
> - Birden fazla ComfyUI kurulumu çakışma olmadan kullanılabilir.
> - Kurulumdan sonra `ComfyUI-Easy-Install` klasörünü yeniden adlandırabilir/taşıyabilirsiniz.
> - [**macOS / Linux için buraya tıklayın**](https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux)


<div align="center">

## ❤️ Bana Destek Olun

Projelerimi beğeniyor musunuz? Her türlü destek çok takdir edilir!

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
