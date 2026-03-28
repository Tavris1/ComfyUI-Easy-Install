<p align="center">
🌍 
<a href="../README.md#english">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<strong>日本語</strong> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<a href="README.de.md#de">Deutsch</a> |
<a href="README.fr.md#fr">Français</a> |
<a href="README.ru.md#ru">Русский</a> |
<a href="README.tr.md#de">Türkçe</a> |
<a href="README.vi.md#vi">Tiếng Việt</a>
</p>

---

<div align="center">

# ComfyUI-Easy-Install
ワンクリックで使えるポータブル **ComfyUI** インストーラー、**Windows** 用 🔹 Nvidia GPU 対応  
[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![GitHub All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![GitHub Downloads Latest](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=⬇+latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)

**Pixaroma** チームに捧ぐ  
[![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Join%20Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)

![ComfyUI Screenshot](ComfyUI-ivo.jpg)

ComfyUI-Easy-Install は、完全に設定済みでワンクリックで使えるポータブル ComfyUI です。Python のセットアップや手動依存関係は不要です。

</div>

## 📦 含まれるコンポーネント
<details>
<summary><b>コアコンポーネント</b></summary>

| 🔧 コンポーネント | 📝 説明 |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - 最新（必要に応じてインストール/更新） |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - 埋め込み版 |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - 最新版 |

</details>

<details>
<summary><b>Pixaroma チュートリアルのノード</b></summary>

| 🖼️ 画像 | 🎬 動画 | 🎵 音声 | 🧩 ユーティリティ / WF | 🤖 モデル |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [WanVideoWrapper](https://github.com/kijai/ComfyUI-WanVideoWrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | [FishAudioS2](https://github.com/Saganaki22/ComfyUI-FishAudioS2) | [KJNodes](https://github.com/kijai/ComfyUI-KJNodes) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SeedVR2 VideoUpscaler](https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | | | [iTools](https://github.com/MohammadAboulEla/ComfyUI-iTools) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI Nodes](https://github.com/gseth/ControlAltAI-Nodes) | |
| [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | | | |

</details>

<details>
<summary><b>オプション追加ノードとツール</b></summary>

| 🧩 ノード | 🛠️ ツール |
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
1. [**▶️ ここをクリック ◀️**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip) 最新バージョンをダウンロード
2. ZIP ファイルを新しいフォルダに解凍し、**`ComfyUI-Easy-Install.bat`** を実行
3. セットアップ後、**Add-ons** フォルダから以下のコンポーネントをインストールまたは実行可能：
    - **Easy-Models-Linker** - *既存の **MODELS** フォルダを **extra_model_paths.yaml** 経由で使用、再ダウンロード不要*
      - ***LLM** や **llm_gguf** のフォルダはこの方法でリダイレクトできません*
    - **Easy-System-Checker** - *主要なハードウェアおよびソフトウェアコンポーネントに関する情報を提供します*
    - **Nunchaku** - *Nunchaku をインストール（問題があれば `Nunchaku.bat` を再実行）*
    - **SageAttention-Multi** - *SageAttention v2.2.0 と v3 をインストール（v3 は NVIDIA 50 シリーズ GPU のみ有効）*
    - **FlashAttention** - *FlashAttention v2.8.3 をインストール*
    - **InsightFace** - *InsightFace をインストール（非商用研究用の事前学習モデルのみ）*
    - **Trellis2** - *Trellis 2.0 とモデルをインストール（`Add-ons/Torch-Pack` の `Torch 2.8.0+cu128` 必須）*
    - **Torch-Pack** - *`Torch 2.7.1+cu128`、`Torch 2.8.0+cu128`、`Torch 2.9.1+cu130` の間で簡単切替*
    - **Easy-model2GGUF** - *モデルを GGUF に変換・量子化（Q2_K–Q8_0）、可能なら 5D テンソル修正も適用*
    - **Long-Paths-Enabler** - *Windows 10/11 で **Long Paths** を有効化、Python/ComfyUI に必須*
    - **ComfyUI-Version-Switcher** - ***以前のバージョン** へ巻き戻し可能*
    - **Toggle-DynamicVRAM** - *ComfyUI 起動ファイルの **--disable-dynamic-vram** オプションを切替*
    - **Update Easy-Install** - *Add-ons やその他フォルダを更新、デスクトップショートカット作成*
> [!IMPORTANT]
> - インストーラーを **管理者として** 実行しないこと。
> - システムフォルダ（`Program Files`、`Windows`、`C:\` 直下）を避ける。
> - フォルダ名にスペースや特殊文字を含めない。
> - NVIDIA ドライバーが最新であることを確認。

> [!TIP]
> - 複数の ComfyUI インストールが可能、競合なし。
> - インストール後、`ComfyUI-Easy-Install` フォルダをリネーム/移動可能。
> - [**macOS / Linux の場合はこちら**](https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux)


<div align="center">

## ❤️ サポート

私のプロジェクトが気に入ったら、サポートいただけると嬉しいです！

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
