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
    <strong>EZi Desktop でポータブル版 ComfyUI をワンクリックでインストールし、管理・カスタマイズできます。</strong><br />
    Windows • NVIDIA GPUs • Pixaroma Community Edition
  </p>

[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat&label=date)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![Downloads](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Tavris1/95cfc6f0535930f25591dcfe08f34cc1/raw/downloads.json)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)

<p align="center">
  <a href="#install">📥 <strong>インストール</strong></a> &nbsp;·&nbsp;
  <a href="#features">✨ 機能</a> &nbsp;·&nbsp;
  <a href="#requirements">💻 動作環境</a> &nbsp;·&nbsp;
  <a href="#help">🩺 ヘルプ</a> &nbsp;·&nbsp;
  <a href="https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux">🍎 macOS/Linux</a> &nbsp;·&nbsp;
  <a href="https://discord.gg/gggpkVgBf3">💬 Pixaroma Discord</a> &nbsp;·&nbsp;
  <a href="#support">❤️ 開発支援</a>
</p>

<br>

![ComfyUI Screenshot](ComfyUI-ivo.png)

**EZi は初めてですか？** [漫画でわかる EZi](#comic)

</div>

<a id="features"></a>

## ✨ 機能

**ComfyUI-Easy-Install**は、専用の Python、設定済みのノード、**EZi Desktop** を含むポータブル版 ComfyUI をインストールします。

- **ワンクリック** - Git、Python、PyTorch、ComfyUI、ノードを自動設定
- **手動設定不要** - Python、ComfyUI、モデルを 1 つのフォルダーに集約
- **ワンクリックでアドオンを追加** - Nunchaku, SageAttention, FlashAttention, InsightFace など
- **EZi Desktop** - スマートコンソールと設定メニューを備えた専用ウィンドウ
  - PyTorch/CUDA のバージョン（Torch-Pack）
  - ComfyUI とフロントエンドのバージョン
  - モデルフォルダーと Input/Output/User フォルダー
  - 起動引数と Dynamic VRAM
  - ComfyUI-Manager の設定とパッケージのバージョン固定
  - UV/PIP キャッシュと GGUF 変換
- **EZi Launcher** - 起動、更新、フォルダーの表示、スナップショットの保存・復元

<details>
<summary><b>EZi Desktop でできること</b></summary>

- 専用ウィンドウ、ブラウザー、またはその両方で ComfyUI を実行
- ComfyUI と EZi の新しいバージョンを通知
- ComfyUI からダウンロードしたモデルを適切なフォルダーに保存
- **コンソール**
  - 検索（Ctrl+F）とログの .txt 保存（Ctrl+S）
  - 別ウィンドウに切り離す
  - 選択したテキストのコピー、保存、Google 検索、Claude や ChatGPT への質問
- **画面キャプチャ** - スクリーンショットまたは画面録画
- **モデルフォルダー** - 既存の複数のモデルフォルダーを連携
- **Input、Output、User フォルダーの変更**
- **起動引数** - すべてのオプションを一覧できるエディター
- **ComfyUI-Manager** - 新旧 UI の切り替え、セキュリティレベルの設定、pip や Git URL からのインストール
- **パッケージ管理** - バージョンを固定（例） `numpy==1.26.4`
- **パッケージキャッシュ** - UV/PIP キャッシュの保持または削除
- **システム情報** - GPU, RAM, Python, Torch, ComfyUI, 長いパスの状態
- テーマ、文字サイズ、ツールチップ、コンソール背景
- Pixaroma のワークフローと ComfyUI 講座へのリンク

</details>

---

<a id="requirements"></a>

## 💻 動作環境

| | |
|---|---|
| **OS** | Windows 10 / 11, 64 ビット |
| **GPU** | NVIDIA RTX 20 シリーズ以降 |
| **ドライバー** | NVIDIA 580 以降を推奨 |
| **RAM** | 最低 8 GB、16 GB 以上を推奨 |
| **ディスク** | 最低 15 GB の空き容量とモデル用の領域（SSD 推奨） |
| **Internet** | インストール時に必要 |

> [!NOTE]
> ドライバーが **580** 未満の場合は **CUDA 12.8** と **Torch 2.8.0** を使用します。**CUDA 13.0** と **Torch 2.11.0** を使うにはドライバーを更新してください。

---

<a id="install"></a>

## 🖥️ Windows へのインストール

> [!IMPORTANT]
> - 英字のみの短いパス（例：`D:\AI\`）を使用してください。

1. [**📥 最新版をダウンロード**](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
2. ZIP を新しいフォルダーに展開します
3. 次のファイルを実行します： **`ComfyUI-Easy-Install.bat`**
4. インストールの完了を待ちます
5. **Start ComfyUI** をクリックするか、デスクトップの **ComfyUI-EZi Launcher** ショートカットを開きます

<details>
<summary><b>インストールされるもの</b></summary>

| コンポーネント | バージョン |
|---|---|
| [Git](https://git-scm.com/) | 未導入の場合のみ最新版をインストール |
| [Python](https://www.python.org/downloads/release/python-31210/) | 3.12.10 組み込み版、チェックサム検証済み |
| PyTorch | 2.11.0 + CUDA 13.0 または 2.8.0 + CUDA 12.8 |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | 最新版 |
| ComfyUI-Manager, Triton, ONNX Runtime GPU, llama-cpp-python | |
| [同梱ノード](#nodes) | Pixaroma の講座で使用するノード |
| 入門ワークフロー | Juggernaut Reborn, Z-Image Turbo |
| サンプルメディア | 保存先： `ComfyUI\input` |
| ComfyUI-EZi Launcher | デスクトップのショートカット |

</details>

---

<a id="start"></a>

## ▶️ ComfyUI の起動

**ComfyUI-EZi Launcher** を開き、モードを選択します。

- **Desktop** - EZi Desktop の専用ウィンドウ
- **Browser** - ブラウザーと従来のコンソール
- **Hybrid** - ブラウザーと EZi コンソール

**KitchenAttention**、**SageAttention**、**FlashAttention** を使用して起動できます。Sage と Flash は先にアドオンをインストールしてください。

---

<a id="addons"></a>

## 🧩 アドオン

アドオンは **Add-ons** にあり、多くは **EZi Desktop > Menu** からも使えます。

| アドオン | 機能 |
|---|---|
| **Easy-Models-Linker** | 既存の **models** フォルダーを再利用します。<br>**LLM** と **llm_gguf** は対象外です。 |
| **Easy-System-Checker** | 主なハードウェアとソフトウェアの情報を表示 |
| **Nunchaku** | インストール対象： [Nunchaku](https://github.com/nunchaku-ai/nunchaku) |
| **SageAttention-Multi** | インストール対象： [SageAttention](https://github.com/woct0rdho/SageAttention) v2.2.0 と v3（v3 は RTX 50 のみ） |
| **FlashAttention** | インストール対象： [FlashAttention](https://github.com/Dao-AILab/flash-attention) v2.8.3 |
| **InsightFace** | インストール対象： [InsightFace](https://github.com/deepinsight/insightface) |
| **Trellis2 + Pixal3D** | インストール対象： [Trellis 2.0 + Pixal3D @visualbruno](https://github.com/visualbruno/ComfyUI-Trellis2) および対応モデル |
| **Torch-Pack** | PyTorch と CUDA のバージョンを切り替え |
| **Easy-model2GGUF** | モデルを GGUF に変換（Q2_K～Q8_0） |
| **Long-Paths-Enabler** | Windows の長いパスを有効化 |
| **Toggle-DynamicVRAM** | 次の設定を切り替え： `--disable-dynamic-vram` |

<details>
<summary><b>Torch-Pack のバージョンとアドオンの対応状況</b></summary>

| Torch | CUDA | Nunchaku | Sage v2 | Sage v3 | Flash | Trellis2 |
|---|---|:---:|:---:|:---:|:---:|:---:|
| 2.7.1 | 12.8 | ✅ | ✅ | ✅ | ✅ | |
| 2.8.0 | 12.8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2.9.1 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.10.0 | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| **2.11.0** (既定) | 13.0 | ✅ | ✅ | ✅ | ✅ | |
| 2.12.1 | 13.0 | | ✅ | | ✅ | |
| 2.13.0 | 13.0 | | ✅ | | ✅ | |
| 2.14.1 | 13.0 | | ✅ | | ✅ | |

</details>

---

<a id="updates"></a>

## 🔄 更新

ランチャーから ComfyUI、ノード、EZi を更新します。大きな変更の前にスナップショットを保存すると、ワンクリックで復元できます。

---

<a id="help"></a>

## 🩺 トラブルシューティング

<details>
<summary><b>インストーラーが停止する、またはエラーが表示される</b></summary>

- インストール停止時は **Show log** で確認し、**Copy details** で詳細を [Pixaroma Discord](https://discord.gg/gggpkVgBf3) に貼り付けます。
- 完全なログは `ComfyUI-Easy-Install.log` です。
- 再試行する前に未完成の `ComfyUI-Easy-Install` フォルダーを削除してください。

</details>

<details>
<summary><b>Windows 11: "Bad Image" (0xc0e90002)</b></summary>

- Windows 11 の「Bad Image」(0xc0e90002) では Smart App Control をオフにして ComfyUI を再起動します。
- 信頼されていないアプリに対する保護が弱まるため、確定前に Windows の警告を読んでください。

</details>

<details>
<summary><b>ファイルが見つからない、またはブロックされる</b></summary>

- ファイルが見つからない場合は Windows セキュリティの「保護の履歴」で Python のファイルを確認し、許可してからフォルダーを削除し、再インストールします。

</details>

<details>
<summary><b>NVIDIA ドライバーが検出されない</b></summary>

- GPU が検出されない場合は [nvidia.com/drivers](https://www.nvidia.com/drivers) から最新版を導入し、端末で `nvidia-smi` を確認します。

</details>

<details>
<summary><b>パスやユーザー名に英字以外の文字が含まれる</b></summary>

- インストーラーを `D:\AI\` などに移動します。
- Windows のユーザー名に英字以外があると問題が残る場合があります。

</details>

<details>
<summary><b>"ComfyUI is already running"</b></summary>

- 「ComfyUI is already running」は同じポート（既定 8188）が使用中です。
- もう一方のウィンドウを閉じて再試行します。

</details>

<details>
<summary><b>長いファイルパスに関するエラー</b></summary>

- 長いパスのエラーは **Add-ons\Tools** の **Long-Paths-Enabler** を実行します。

</details>

---

<a id="uninstall"></a>

## 🧹 アンインストール

`ComfyUI-Easy-Install` フォルダーとデスクトップの **ComfyUI-EZi Launcher** ショートカットを削除します。

---

<a id="nodes"></a>

## 📦 同梱ノード

<details>
<summary><b>Pixaroma の講座で使用するノード</b></summary>

| 🖼️ 画像 | 🎬 動画 | 🎵 音声 | 🧩 ツール／ワークフロー | 🤖 モデル |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [WanVideoWrapper](https://github.com/kijai/ComfyUI-WanVideoWrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | | [KJNodes](https://github.com/kijai/ComfyUI-KJNodes) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | [SeedVR2 VideoUpscaler](https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler) | | [iTools](https://github.com/MohammadAboulEla/ComfyUI-iTools) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI Nodes](https://github.com/gseth/ControlAltAI-Nodes) | |
| [Krea2Edit](https://github.com/lbouaraba/comfyui-krea2edit) | | | ✨[Pixaroma](https://gitlab.com/pixaroma/ComfyUI-Pixaroma) | |

</details>

---

<a id="comic"></a>

## 🎭 漫画でわかる EZi

初めての方は漫画をご覧ください。画像をクリックすると原寸で表示します。

<table width="100%">
  <tr>
    <th width="16.66%">ComfyUI の導入</th>
    <th width="16.66%">EZi Launcher</th>
    <th width="16.66%">モデルの再利用</th>
    <th width="16.66%">アドオンの導入</th>
    <th width="16.66%">更新と復元</th>
    <th width="16.66%">システム情報</th>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6"><img src="https://github.com/user-attachments/assets/74c2c772-00ed-453b-aa68-7d6bea6d18b6" width="100%" alt="ComfyUI の導入"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9"><img src="https://github.com/user-attachments/assets/cd01aba6-a169-4a16-8ba6-a2f4073f42f9" width="100%" alt="EZi Launcher"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901"><img src="https://github.com/user-attachments/assets/71e8a9fa-df5b-442f-b77d-34c1115f3901" width="100%" alt="モデルの再利用"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b"><img src="https://github.com/user-attachments/assets/f340d88c-a947-4b5e-bba9-deba90aabc4b" width="100%" alt="アドオンの導入"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6"><img src="https://github.com/user-attachments/assets/8a92e883-7af2-4935-a0e9-ae4f50dba5b6" width="100%" alt="更新と復元"></a></td>
    <td align="center"><a href="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3"><img src="https://github.com/user-attachments/assets/2fe2fbf4-bd2f-4d12-929d-cf355fd19ad3" width="100%" alt="システム情報"></a></td>
  </tr>
</table>

<div align="center">

<a id="support"></a>

## ❤️ 開発を支援

このプロジェクトを気に入っていただけたら、継続的な開発へのご支援をお願いします。

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/tavris1)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/tavris1)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/Tavris1)

</div>
