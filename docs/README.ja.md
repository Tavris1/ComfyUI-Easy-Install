<a id="ja"></a>

<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<strong>日本語</strong> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
<a href="README.pt-BR.md#pt-br">Português</a> |
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
    <strong>EZi Desktop によるワンクリック・ポータブル ComfyUI</strong><br />
    Windows • NVIDIA GPU • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/Tavris1/ComfyUI-Easy-Install/Windows/.github/badges/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

  <p align="center">
    <a href="#windows-installation">📥 インストール</a> &nbsp;·&nbsp;
    <a href="#features">✨ 機能/コンポーネント</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#support-development">❤️ 開発を支援</a>
  </p>

<!-- Dedicated to the **Pixaroma** community  
[![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
-->

<!--[![GitHub All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)-->
<!--[![GitHub Downloads Latest](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=⬇+latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)-->

---

![ComfyUI Screenshot](ComfyUI-ivo.jpg)

</div>

<a id="features"></a>

## ✨ 機能

****ComfyUI-Easy-Install** は **EZi Desktop** とともにポータブルな ComfyUI 環境を提供します。  
Python や Git の手動セットアップは不要です。

Nunchaku、SageAttention、FlashAttention、InsightFace、Trellis 2.0 などの複雑なパッケージをワンクリックでインストールできます。

**モデル、パッケージ、PyTorch/CUDA バージョン、Dynamic VRAM、ComfyUI/フロントエンドのバージョン、UV/PIP キャッシュ、GGUF 変換**を一か所で管理できます。

## 📦 含まれるコンポーネント
<details open>
<summary><b>コアコンポーネント</b></summary>

| 🔧 コンポーネント | 📝 説明 |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - 最新版（必要に応じてインストール/更新） |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - 組み込み版 |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - 最新安定版 |

</details>

<details>
<summary><b>Pixaroma チュートリアルで使用するノード</b></summary>

| 🖼️ 画像 | 🎬 動画 | 🎵 音声 | 🧩 ユーティリティ / WF | 🤖 モデル |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [動画HelperSuite](https://github.com/Kosinkadink/ComfyUI-動画HelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [Wan動画Wrapper](https://github.com/kijai/ComfyUI-Wan動画Wrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | [Fish音声S2](https://github.com/Saganaki22/ComfyUI-Fish音声S2) | [KJノード](https://github.com/kijai/ComfyUI-KJノード) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SeedVR2 動画Upscaler](https://github.com/numz/ComfyUI-SeedVR2_動画Upscaler) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | | | [iツール](https://github.com/MohammadAboulEla/ComfyUI-iツール) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI ノード](https://github.com/gseth/ControlAltAI-ノード) | |
| [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | | ✨[Pixaroma](https://github.com/pixaroma/ComfyUI-Pixaroma) | |
| | | | [Krea2T-Enhancer](https://github.com/capitan01R/ComfyUI-Krea2T-Enhancer) | |
| | | | [Krea2Edit](https://github.com/lbouaraba/comfyui-krea2edit) | |

</details>

<details>
<summary><b>オプションのアドオンとツール</b></summary>

| 🧩 ノード | 🛠️ ツール |
|---|---|
| [Nunchaku](https://github.com/nunchaku-ai/nunchaku) | Easy-モデル-Linker |
| [SageAttention (v2.2.0 and v3)](https://github.com/woct0rdho/SageAttention) | Easy-System-Checker |
| [FlashAttention](https://github.com/Dao-AILab/flash-attention) | ComfyUI-Version-Switcher |
| [InsightFace](https://github.com/deepinsight/insightface) | Easy-model2GGUF |
| [Trellis 2.0](https://github.com/visualbruno/ComfyUI-Trellis2) | Long-Paths-Enabler |
| | Torch-Pack |
| | Toggle-DynamicVRAM |
| | Update Easy-インストール |

</details>

---

<a id="windows-installation"></a>

## 🖥️ Windows へのインストール

> [!IMPORTANT]
> - インストーラーを**管理者**として実行しないでください。
> - システムフォルダー（`Program Files`、`Windows`、`C:\` 直下）は避けてください。
> - フォルダー名にスペースや特殊文字を使用しないでください。
> - NVIDIA ドライバーを最新の状態にしてください。

1. [**📥 最新版をダウンロード**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. ZIP ファイルを新しいフォルダーに展開し、**`ComfyUI-Easy-Install.bat`** を実行します。
3. セットアップ後、必要に応じて **Add-ons** フォルダーまたは **EZi Desktop Menu** からコンポーネントをインストール/実行できます。
    - **Easy-モデル-Linker** - ***extra_model_paths.yaml** を使って既存の **MODELS** フォルダーを利用でき、再ダウンロードは不要です*
      - ***LLM** や **llm_gguf** など一部のフォルダーはこの方法ではリダイレクトできません*
    - **Easy-System-Checker** - *主要なハードウェアおよびソフトウェアの情報を表示します*
    - **Nunchaku** - *Nunchaku をインストールします。（後で問題が発生した場合は `Nunchaku.bat` を再度実行してください）*
    - **SageAttention-Multi** - *SageAttention v2.2.0 と v3 の両方をインストールします（v3 は NVIDIA 50 シリーズ GPU でのみ有効）*
    - **FlashAttention** - *FlashAttention v2.8.3 をインストールします*
    - **InsightFace** - *InsightFace をインストールします（事前学習モデルは非商用研究目的のみ）*
    - **Trellis2** - *Trellis 2.0 とモデルをインストールします（`Add-ons/Torch-Pack` の `Torch 2.8.0+cu128` が必要）*
    - **Torch-Pack** - *次のバージョンを素早く切り替え：*  
      - *`Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`, `Torch 2.9.1+cu130`, `Torch 2.10+cu130` & `Torch 2.11+cu130`*
    - **Easy-model2GGUF** - *モデルを GGUF（Q2_K–Q8_0）へ変換・量子化し、可能な場合は 5D テンソルを修正します*
    - **Long-Paths-Enabler** - *Windows 10/11 で**長いパス**を有効にします。Python/ComfyUI に必須です*
    - **ComfyUI-Version-Switcher** - *問題が発生した場合、**以前の** ComfyUI バージョンへ**可逆的に**ロールバックできます*
    - **Toggle-DynamicVRAM** - *ComfyUI の起動ファイルで **--disable-dynamic-vram** オプションを切り替えます*
    - **Update Easy-インストール** - ***Add-ons** などを更新し、デスクトップショートカットを作成します*
    - **EZi Desktop Themes** - *EZi Desktop > Menu > Advanced から*
    - **Input、Output、User フォルダーのカスタマイズ** - *EZi Desktop > Menu > Advanced から*
    - **ComfyUI とフロントエンドのバージョン変更** - *EZi Desktop > Menu > Advanced から*
    - **UV と PIP キャッシュのクリーナー** - *EZi Desktop > Menu から*
    - **ComfyUI-Manager Security-Level Config** - *EZi Desktop > Menu から security_level を簡単に設定できます*
    - **Pinned-Packages-Manager** - *EZi Desktop > Menu から NumPy==1.26.4 などのパッケージバージョンを固定できます*

<div align="center">

---

<a id="support-development"></a>

## ❤️ 開発を支援

このプロジェクトがお役に立ちましたか？  
時間の節約に役立ったなら、ご支援が開発とメンテナンスの継続に役立ちます。

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
