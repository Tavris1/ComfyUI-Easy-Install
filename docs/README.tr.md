<a id="tr"></a>

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
    <strong>Taşınabilir ComfyUI’ı tek tıklamayla kurun, EZi Desktop üzerinden yönetin ve özelleştirin.</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

<p align="center">
  <a href="#install">📥 <strong>Kur</strong></a> &nbsp;·&nbsp;
  <a href="#features">✨ Özellikler</a> &nbsp;·&nbsp;
  <a href="#requirements">💻 Sistem gereksinimleri</a> &nbsp;·&nbsp;
  <a href="#help">🩺 Yardım</a> &nbsp;·&nbsp;
  <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
  <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
  <a href="#support">❤️ Destek</a>
</p>

<br>

![ComfyUI Screenshot](ComfyUI-ivo.png)

**EZi’yi ilk kez mi kullanıyorsunuz?** [Çizgi romanla EZi’yi tanıyın](#comic)

</div>

<a id="features"></a>

## ✨ Özellikler

**ComfyUI-Easy-Install** kendi Python ortamı, kullanıma hazır düğümler ve **EZi Desktop** ile birlikte taşınabilir ComfyUI’ı kurar.

- **Tek tıklama** - Git, Python, PyTorch, ComfyUI ve düğümler otomatik yapılandırılır
- **Elle yapılandırma gerekmez** - Python, ComfyUI ve modeller tek klasörde bulunur
- **Tek tıklamayla eklentiler** - Nunchaku, SageAttention, FlashAttention, InsightFace ve daha fazlası
- **EZi Desktop** - Akıllı konsolu ve menüsü olan ayrı bir pencere
  - PyTorch/CUDA sürümleri (Torch-Pack)
  - ComfyUI ve ön yüz sürümleri
  - Model klasörleri ve Input/Output/User klasörleri
  - Başlatma parametreleri ve Dynamic VRAM
  - ComfyUI-Manager ayarları ve sabitlenmiş paketler
  - UV/PIP önbelleği ve GGUF dönüşümü
- **EZi Launcher** - Başlatma, güncelleme, klasör açma, anlık görüntü kaydetme ve geri yükleme

<details>
<summary><b>EZi Desktop ile neler yapabilirsiniz?</b></summary>

- ComfyUI’ı kendi penceresinde, tarayıcıda veya her ikisinde çalıştırın
- Yeni ComfyUI ve EZi sürümleri için bildirim alın
- Modelleri doğrudan doğru klasöre indirin
- **Konsol**
  - Arama yapın (Ctrl+F) ve günlüğü .txt olarak kaydedin (Ctrl+S)
  - Konsolu ayrı bir pencereye taşıyın
  - Seçili metni kopyalayın, kaydedin, Google’da arayın veya Claude ya da ChatGPT’ye sorun
- **Ekran yakalama** - Ekran görüntüsü veya video kaydı
- **Model klasörleri** - Birden fazla mevcut klasörü bağlayın
- **Özel Input, Output ve User klasörleri**
- **Başlatma parametreleri** - Tüm seçenekleri listeleyen düzenleyici
- **ComfyUI-Manager** - Yeni veya eski arayüz, güvenlik düzeyi, pip ve Git URL’siyle kurulum
- **Paket sürümlerini sabitleme** - Örnek sabit sürüm: `numpy==1.26.4`
- **Paket önbelleği** - UV/PIP önbelleğini koruyun veya temizleyin
- **Sistem bilgileri** - GPU, RAM, Python, Torch, ComfyUI, uzun yollar
- Tema, yazı boyutu, araç ipuçları ve konsol arka planı
- Pixaroma iş akışlarına ve ComfyUI kursuna bağlantılar

</details>

---

<a id="requirements"></a>

## 💻 Sistem gereksinimleri

| | |
|---|---|
| **İşletim sistemi** | Windows 10 / 11, 64 bit |
| **GPU** | NVIDIA RTX 20 serisi veya daha yeni |
| **Sürücü** | NVIDIA 580 veya daha yeni (önerilir) |
| **RAM** | En az 8 GB, 16 GB veya üzeri önerilir |
| **Disk** | En az 15 GB boş alan ve modeller için ek alan (SSD önerilir) |
| **Internet** | Kurulum sırasında gerekir |

> [!NOTE]
> **580**’den eski sürücülerle **CUDA 12.8** ve **Torch 2.8.0** kurulur. **CUDA 13.0** ve **Torch 2.11.0** için sürücüyü güncelleyin.

---

<a id="install"></a>

## 🖥️ Windows kurulumu

> [!IMPORTANT]
> - Yalnızca İngilizce karakterler içeren kısa bir yol kullanın, örneğin `D:\AI\`.

1. [**📥 Son sürümü indir**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. ZIP dosyasını yeni bir klasöre çıkarın
3. Şu dosyayı çalıştırın: **`ComfyUI-Easy-Install.bat`**
4. Kurulumun tamamlanmasını bekleyin
5. **Start ComfyUI** düğmesine tıklayın veya masaüstündeki **ComfyUI-EZi Launcher** kısayolunu açın

<details>
<summary><b>Kurulan bileşenler</b></summary>

| Bileşen | Sürüm |
|---|---|
| [Git](https://git-scm.com/) | Yalnızca Git yoksa en son sürüm |
| [Python](https://www.python.org/downloads/release/python-31210/) | 3.12.10 Gömülü sürüm, sağlama toplamı doğrulanır |
| PyTorch | 2.11.0 + CUDA 13.0 veya 2.8.0 + CUDA 12.8 |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | En son sürüm |
| ComfyUI-Manager, Triton, ONNX Runtime GPU, llama-cpp-python | |
| [Birlikte gelen düğümler](#nodes) | Pixaroma eğitimlerindeki düğümler |
| Başlangıç iş akışları | Juggernaut Reborn, Z-Image Turbo |
| Örnek medya | Bulunduğu klasör: `ComfyUI\input` |
| ComfyUI-EZi Launcher | Masaüstü kısayolu |

</details>

---

<a id="start"></a>

## ▶️ ComfyUI’ı başlatma

**ComfyUI-EZi Launcher** aracını açıp bir mod seçin.

- **Desktop** - EZi Desktop penceresinde
- **Browser** - Tarayıcıda klasik konsolla
- **Hybrid** - Tarayıcıda EZi konsoluyla

**KitchenAttention**, **SageAttention** veya **FlashAttention** ile başlatın. Sage ve Flash için önce eklentiyi kurun.

---

<a id="addons"></a>

## 🧩 Eklentiler

Eklentiler **Add-ons** klasöründedir. Çoğuna **EZi Desktop > Menu** üzerinden de erişilebilir.

| Eklenti | İşlevi |
|---|---|
| **Easy-Models-Linker** | Mevcut **models** klasörünü kullanır.<br>**LLM** ve **llm_gguf** kapsam dışıdır. |
| **Easy-System-Checker** | Donanım ve yazılım bilgilerini gösterir |
| **Nunchaku** | Kurduğu bileşen: [Nunchaku](https://github.com/nunchaku-ai/nunchaku) |
| **SageAttention-Multi** | Kurduğu bileşen: [SageAttention](https://github.com/woct0rdho/SageAttention) v2.2.0 ve v3 (v3 yalnızca RTX 50’de) |
| **FlashAttention** | Kurduğu bileşen: [FlashAttention](https://github.com/Dao-AILab/flash-attention) v2.8.3 |
| **InsightFace** | Kurduğu bileşen: [InsightFace](https://github.com/deepinsight/insightface) |
| **Trellis2 + Pixal3D** | Kurduğu bileşen: [Trellis 2.0 + Pixal3D @visualbruno](https://github.com/visualbruno/ComfyUI-Trellis2) ve ilgili model |
| **Torch-Pack** | PyTorch ve CUDA sürümlerini değiştirir |
| **Easy-model2GGUF** | Modelleri GGUF’ye dönüştürür (Q2_K–Q8_0) |
| **Long-Paths-Enabler** | Windows’ta uzun yolları etkinleştirir |
| **Toggle-DynamicVRAM** | Şu seçeneği açıp kapatır: `--disable-dynamic-vram` |

<details>
<summary><b>Torch-Pack sürümleri ve eklenti desteği</b></summary>

| Torch | CUDA | Nunchaku | Sage v2 | Sage v3 | Flash | Trellis2 |
|---|---|:---:|:---:|:---:|:---:|:---:|
| 2.7.1 | 12.8 | ✅ | ✅ | ✅ | ✅ | |
| 2.8.0 | 12.8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2.9.1 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.10.0 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| **2.11.0** (varsayılan) | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.12.1 | 13.0 | | ✅ | | ✅ | |
| 2.13.0 | 13.0 | | ✅ | | ✅ | |
| 2.14.1 | 13.0 | | ✅ | | ✅ | |

</details>

---

<a id="updates"></a>

## 🔄 Güncellemeler

ComfyUI, düğümler ve EZi’yi başlatıcıdan güncelleyin. Büyük değişikliklerden önce anlık görüntü kaydedin. Tek tıklamayla geri yükleyebilirsiniz.

---

<a id="help"></a>

## 🩺 Sorun giderme

<details>
<summary><b>Kurulum durdu veya hata veriyor</b></summary>

- Kurulum durursa **Show log** ile günlüğü açın. **Copy details** ile ayrıntıları kopyalayıp [Pixaroma Discord](https://discord.gg/gggpkVgBf3)’da paylaşın.
- Günlüğün tamamı `ComfyUI-Easy-Install.log` dosyasındadır.
- Tekrar denemeden önce yarım kalan `ComfyUI-Easy-Install` klasörünü silin.

</details>

<details>
<summary><b>Windows 11: "Bad Image" (0xc0e90002)</b></summary>

- Windows 11’de “Bad Image” (0xc0e90002) hatasında Smart App Control’ü kapatıp ComfyUI’ı yeniden başlatın.
- Bu işlem güvenilmeyen uygulamalara karşı korumayı azaltır.
- Onaylamadan önce Windows uyarısını okuyun.

</details>

<details>
<summary><b>Dosyalar eksik veya engellenmiş</b></summary>

- Dosyalar eksikse Windows Güvenliği’nde koruma geçmişini kontrol edin.
- Engellenen Python dosyalarına izin verin, klasörü silip yeniden kurun.

</details>

<details>
<summary><b>NVIDIA sürücüsü algılanmadı</b></summary>

- Sürücü algılanmıyorsa [nvidia.com/drivers](https://www.nvidia.com/drivers) üzerinden güncel sürücüyü kurun ve terminalde `nvidia-smi` komutunu deneyin.

</details>

<details>
<summary><b>Yolda veya kullanıcı adında İngilizce dışı karakterler</b></summary>

- Kurulum programını `D:\AI\` gibi bir yola taşıyın.
- Windows kullanıcı adındaki İngilizce dışı karakterler yine de sorun yaratabilir.

</details>

<details>
<summary><b>"ComfyUI is already running"</b></summary>

- “ComfyUI is already running” aynı bağlantı noktasının (varsayılan 8188) kullanımda olduğunu gösterir.
- Diğer ComfyUI penceresini kapatıp tekrar deneyin.

</details>

<details>
<summary><b>Uzun dosya yolu hataları</b></summary>

- Uzun yol hatalarında **Add-ons\Tools** içinden **Long-Paths-Enabler** aracını çalıştırın.

</details>

---

<a id="uninstall"></a>

## 🧹 Kaldırma

`ComfyUI-Easy-Install` klasörünü ve masaüstündeki **ComfyUI-EZi Launcher** kısayolunu silin.

---

<a id="nodes"></a>

## 📦 Birlikte gelen düğümler

<details>
<summary><b>Pixaroma eğitimlerindeki düğümler</b></summary>

| 🖼️ Görüntü | 🎬 Video | 🎵 Ses | 🧩 Araçlar ve iş akışları | 🤖 Modeller |
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

## 🎭 Çizgi romanla EZi’yi tanıyın

EZi’yi ilk kez mi kullanıyorsunuz? Çizgi romandaki görsellere tıklayarak tam boyutta görüntüleyebilirsiniz.

<table width="100%">
  <tr>
    <th width="16.66%">ComfyUI kurulumu</th>
    <th width="16.66%">EZi başlatıcısı</th>
    <th width="16.66%">Modelleri yeniden kullanma</th>
    <th width="16.66%">Eklenti kurulumu</th>
    <th width="16.66%">Güncelleme ve geri yükleme</th>
    <th width="16.66%">Sisteminiz</th>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6"><img src="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6" width="100%" alt="ComfyUI kurulumu"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9"><img src="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9" width="100%" alt="EZi başlatıcısı"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901"><img src="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901" width="100%" alt="Modelleri yeniden kullanma"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b"><img src="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b" width="100%" alt="Eklenti kurulumu"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6"><img src="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6" width="100%" alt="Güncelleme ve geri yükleme"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3"><img src="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3" width="100%" alt="Sisteminiz"></a></td>
  </tr>
</table>

<div align="center">

<a id="support"></a>

## ❤️ Geliştirmeyi destekleyin

Projeyi beğendiyseniz desteğiniz geliştirme çalışmalarının sürmesine yardımcı olur.

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
