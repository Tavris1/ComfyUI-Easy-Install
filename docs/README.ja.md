<p align="center">
🌍 
<a href="../README.md">English</a> |
<a href="README.zh-CN.md#zh-cn">简体中文</a> |
<strong>日本語</strong> |
<a href="README.ko.md#ko">한국어</a> |
<a href="README.es.md#es">Español</a> |
<a href="README.pt-BR.md#pt-br">Português</a> |
<a href="README.ru.md#ru">Русский</a> |
<a href="README.de.md#de">Deutsch</a> |
<a href="README.fr.md#fr">Français</a> |
<a href="README.vi.md#vi">Tiếng Việt</a>
</p>

---

# ComfyUI-Easy-Install
> **ComfyUI** のワンクリック ポータブル版 **Windows** 向け 🔹 Nvidia GPU 🔹 Pixaroma コミュニティエディション 🔹  
> [![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
> [![GitHun Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
> [![Github All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)]()
> [![GitHub Downloads latest)](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=downloads%40latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
>
> **Pixaroma** チームに捧げます  
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Join%20Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_presence_count&logo=discord&logoColor=white&label=Online&color=blue&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)

---

## 含まれるコンポーネント:  
- **Git** *(必要に応じてインストールまたは更新されます)*  
- **ComfyUI portable**  
- **Python 3.12.10** *(組み込みポータブル版)*  

### Pixaroma のチュートリアルで使用されているノード [YouTube](https://www.youtube.com/@pixaroma)

||||||
|---|---|---|---|---|
ComfyUI Manager | Tiled Diffusion & VAE | LayerStyle | rgthree | GGUF
VideoHelperSuite | Inpaint-CropAndStitch | SCAIL-Pose | KJNodes | iTools
Comfyroll Studio | SeedVR2_VideoUpscaler | ControlNet Aux | Easy-Use | RMBG
WanVideoWrapper | WanAnimatePreprocess | MelBandRoFormer | Easy-Sam3 | QwenVL
Qwen3-TTS

### オプション追加ノード
||||||
|---|---|---|---|---|
Nunchaku | SageAttention-Multi (v2.2.0 and v3) | FlashAttention | Trellis 2.0 | InsightFace

### 追加ツール
||||||
|---|---|---|---|---|
Easy-Models-Linker | Torch-Pack | Easy-model2GGUF | Long-Paths-Enabler | ComfyUI-Version-Switcher

---

## Windows インストール
1. [:arrow_forward:**最新バージョンはこちらからダウンロード**◀️](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. ZIP ファイルを新しいフォルダーに解凍し **`ComfyUI-Easy-Install.bat`** を実行してセットアップを開始します
3. セットアップ後、**Add-ons** フォルダーから以下のコンポーネントを必要に応じてインストールまたは実行できます:
    - **Easy-Models-Linker** - ***extra_model_paths.yaml** を使用して既存の **MODELS** フォルダーを利用し、再ダウンロードは不要です*
      - *一部のフォルダー (**LLM** や **llm_gguf**) はこの方法ではリダイレクトできません*
    - **Nunchaku** - *Nunchaku をインストールします。後で問題が発生した場合は `Nunchaku.bat` を再実行してください*
    - **SageAttention-Multi** - *SageAttention v2.2.0 と v3 をインストールします (v3 は NVIDIA 50 シリーズ GPU のみ有効)*
    - **FlashAttention** - *FlashAttention v2.8.3 をインストールします*
    - **InsightFace** - *InsightFace をインストールします (事前学習モデルは非商用研究目的のみ)*
    - **Trellis2** - *Trellis 2.0 とモデルをインストールします (`Add-ons/Torch-Pack` の `Torch 2.8.0+cu128` が必要)*
    - **Torch-Pack** - *以下を素早く切り替え可能:*
      - ***Torch 2.7.1+cu128***
      - ***Torch 2.8.0+cu128***
      - ***Torch 2.9.1+cu130** (デフォルト、NVIDIA ドライバー v580+ が必要)*  
    - **Easy-model2GGUF** *(**Add-Ons/Tools**)*  
      - *モデル (`.safetensors`, `.pth`, `.pt`) を数分で **GGUF** 形式 (FP16 または BF16) に変換します*  
      - ***Q2_K** から **Q8_0** までの量子化オプションに対応し、利用可能な場合は **5D tensor 修正** を適用します*  
    - **Long-Paths-Enabler** *(`Add-Ons/Tools`)* - *Windows 10/11 で **Long Paths** を有効にします。Python/ComfyUI に重要です*  
    - **ComfyUI-Version-Switcher** *(`Add-Ons/Tools`)* - ***以前の** ComfyUI バージョンへ **可逆的に** ロールバックできます*  
    - **Update Easy-Install.bat** *(メインフォルダー)* - ***Add-ons** やその他のフォルダーを更新し、デスクトップショートカットを作成します*  

> [!IMPORTANT]
> - インストーラーを **管理者として** 実行しないでください。
> - システムフォルダー (`Program Files`, `Windows`, `C:\` ルート) は避けてください。
> - フォルダー名にスペースや特殊文字を使用しないでください。
> - NVIDIA ドライバーが最新であることを確認してください。

> [!TIP]
> - 複数の ComfyUI インストールが競合なしで可能です。
> - インストール後に `ComfyUI-Easy-Install` フォルダーの名前変更や移動が可能です。
> - macOS / Linux の場合は [here](https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux) をクリックしてください。

---

<img width="1038" height="240" alt="123321" src="https://github.com/user-attachments/assets/6d0655ef-8724-4cb1-bce2-a29fc9004173" />

---

私のプロジェクトを気に入っていただけましたら、ぜひご支援をご検討ください。どのようなサポートでも大変感謝いたします。

💜 PayPal: https://paypal.me/tavris1  
☕ Buy Me a Coffee: https://buymeacoffee.com/tavris1  
❤️ GitHub Sponsors: https://github.com/sponsors/Tavris1  