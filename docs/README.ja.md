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
    <strong>EZi Desktop を搭載したワンクリック・ポータブル ComfyUI：パッケージ、環境、設定を管理するためのフルダッシュボード</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)


<!--[![GitHub All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)-->
<!--[![GitHub Downloads Latest](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=⬇+latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)-->

  <p align="center">
    <a href="#%EF%B8%8F-windows-インストール">📥 インストール</a> &nbsp;·&nbsp;
    <a href="#-機能">✨ 機能/コンポーネント</a> &nbsp;·&nbsp;
    <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
    <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
    <a href="#%EF%B8%8F-開発を支援">❤️ 開発を支援</a>
  </p>

<!-- Dedicated to the **Pixaroma** community  
[![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
-->

---

![ComfyUI Screenshot](ComfyUI-ivo.jpg)

</div>

## ✨ 機能

**ComfyUI-Easy-Install** は、**EZi Desktop** を備えたポータブルな ComfyUI 環境を提供します。  
Python や Git を手動でセットアップする必要はありません。

Nunchaku、SageAttention、FlashAttention、InsightFace、Trellis 2.0 などの複雑なパッケージをワンクリックでインストールできます。

**モデル、パッケージ、PyTorch/CUDA バージョン、Dynamic VRAM、  
ComfyUI/frontend バージョン、UV/PIP キャッシュ、GGUF 変換**を1か所から管理できます。

## 📦 含まれるコンポーネント
<details open>
<summary><b>コアコンポーネント</b></summary>

| 🔧 コンポーネント | 📝 説明 |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - 最新版（必要に応じてインストール/更新） |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - Embedded バージョン |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - 最新の安定版 |

</details>

<details>
<summary><b>Pixaroma チュートリアルで使用される Nodes</b></summary>

| 🖼️ 画像 | 🎬 動画 | 🎵 オーディオ | 🧩 ユーティリティ / WF | 🤖 モデル |
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
<summary><b>オプションの Add-ons と Tools</b></summary>

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

## 🖥️ Windows インストール

> [!IMPORTANT]
> - インストーラーを **Administrator** として実行しないでください。
> - システムフォルダ（`Program Files`、`Windows`、`C:\` ルート）は避けてください。
> - フォルダ名にスペースや特殊文字を使用しないでください。
> - NVIDIA ドライバーが最新であることを確認してください。

1. [**📥 DOWNLOAD LATEST VERSION**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. ZIP ファイルを新しいフォルダに展開し、**`ComfyUI-Easy-Install.bat`** を実行します
3. セットアップ後、必要に応じて **Add-ons** フォルダまたは **EZi Desktop Menu** からコンポーネントをインストールまたは実行できます：
    - **Easy-Models-Linker** - ***extra_model_paths.yaml** を使用して既存の **MODELS** フォルダを利用するため、再ダウンロードは不要*
      - ***LLM** や **llm_gguf** など、一部のフォルダはこの方法ではリダイレクトできません*
    - **Easy-System-Checker** - *主要なハードウェアおよびソフトウェアコンポーネントに関する情報を提供*
    - **Nunchaku** - *Nunchaku をインストール*
    - **SageAttention-Multi** - *SageAttention v2.2.0 と v3 の両方をインストール（v3 は NVIDIA 50-series GPUs でのみ有効）*
    - **FlashAttention** - *FlashAttention v2.8.3 をインストール*
    - **InsightFace** - *InsightFace をインストール（事前学習済みモデルは非商用研究用途のみ）*
    - **Trellis2** - *Trellis 2.0 とモデルをインストール（`Add-ons/Torch-Pack` の `Torch 2.8.0+cu128` が必要）*
    - **Torch-Pack** - *以下を素早く切り替え：`Torch 2.7.1+cu128`、`Torch 2.8.0+cu128`、  
      `Torch 2.9.1+cu130`、`Torch 2.10+cu130`、`Torch 2.11+cu130`、`Torch 2.12.1+cu130`、`Torch 2.13.0+cu130`*
    - **Easy-model2GGUF** - *モデルを GGUF（Q2_K–Q8_0）に変換・量子化し、利用可能な場合は 5D tensor 修正を適用*
    - **Long-Paths-Enabler** - *Windows 10/11 で **Long Paths** を有効化。Python/ComfyUI に不可欠*
    - **ComfyUI-Version-Switcher** - *問題が発生した場合、**以前の** ComfyUI バージョンへ**元に戻せる**ロールバック*
    - **Toggle-DynamicVRAM** - *ComfyUI 起動ファイル内の **--disable-dynamic-vram** オプションを切り替え*
    - **Update Easy-Install** - ***Add-ons** やその他のフォルダを更新。デスクトップショートカットを作成*
    - **EZi Desktop Themes** - *EZi Desktop > Menu > Advanced 経由*
    - **Custom Input, Output & User folders** - *EZi Desktop > Menu > Advanced 経由*
    - **ComfyUI & Frontend Version Changer** - *EZi Desktop > Menu > Advanced 経由*
    - **UV & PIP cache cleaner** - *EZi Desktop > Menu 経由*
    - **ComfyUI-Manager Security-Level Config** - *EZi Desktop > Menu 経由で security_level を簡単に設定*
    - **Pinned-Packages-Manager** - *EZi Desktop > Menu 経由で NumPy==1.26.4 などのパッケージバージョンを固定*

<div align="center">

---

## ❤️ 開発を支援

このプロジェクトを気に入っていただけましたか？  
時間の節約につながったなら、皆様の支援が開発とメンテナンスの継続に役立ちます。

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
