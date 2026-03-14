# ubuntu_desktop_setup

Ubuntu Desktop を Ansible で構成管理するためのリポジトリです。  
現在の主対象は **KDE Plasma ベースの Ubuntu デスクトップ初期構築** です。

## 方針

- メインのコードは `ansible/` 配下に集約する
- ローカルマシン `localhost` に対して適用する
- まずは手動で実施していた初期セットアップを Ansible 化する

## 現在の構成

```text
ansible/
├── inventory.ini
├── site.yml
└── roles/
    ├── base
    ├── desktop_kde
    ├── devtools
    ├── input_check
    ├── japanese_input
    └── third_party_apps
```

## 実行方法

前提:

- Ubuntu 上で実行する
- `ansible-playbook` がインストール済みである
- `sudo` 可能なユーザーで実行する

```bash
ansible-playbook ansible/site.yml
```

`ansible.cfg` で `ansible/inventory.ini` と `ansible/roles` を参照する設定にしています。

## このリポジトリで管理したい内容

手動セットアップで実施していた内容を、KDE 向けに置き換えながら管理する想定です。

```md
| ロール | 推測される役割 |
|---|---|
| `base` | 基本パッケージ・共通設定 |
| `desktop_kde` | KDEデスクトップ環境のセットアップ |
| `third_party_apps` | Discord・Obsidianなどサードパーティ製アプリの導入 |
| `devtools` | 開発ツール（git・dockerなど）の導入 |
| `japanese_input` | 日本語入力（Fcitx・Mozcなど）の設定 |
| `input_check` | 設定確認・動作チェック |
```

- 基本パッケージ
  - `curl`
  - `ca-certificates`
  - `gnupg`
  - `unattended-upgrades`
- デスクトップ環境
  - KDE Plasma
- 開発ツール・日常利用ツール
  - Docker
  - Chrome
  - Discord
  - Obsidian
  - VS Code
  - `nvm`
  - `codex`
  - `newsql`
  - TablePlus
- 日本語入力
  - mozc
  - Japanese Input の初期設定
- セキュリティアップデート
  - `unattended-upgrades`

## KDE 化は可能か

可能です。  
少なくともこのリポジトリの目的である「Ubuntu デスクトップの構成管理」という範囲では、XFCE から KDE への置き換えは自然です。

ただし、次の点は分けて考える必要があります。

- パッケージ導入
  - KDE 本体や mozc などは Ansible 化しやすい
- デスクトップ固有設定
  - 端末アプリ既定化
  - ワークスペースのショートカット
  - 電源管理
  - IME の起動時状態
  - これらは KDE の設定ファイルや `kwriteconfig5`/`kwriteconfig6` などの扱い確認が必要

## 次に Ansible 化すべき項目

優先度順ならこのあたりです。

1. `base` role で mozc の実在確認方針を整理する
2. `devtools` role で Docker を確実に入れる
3. `nvm` と Node.js 22 の導入手順を role 化する
4. KDE 固有設定を「パッケージ導入」と「個人設定」に分離して管理する

## 外部アプリの導入方針

`third_party_apps` role で管理します。

- APT repository 追加で管理
  - Google Chrome
  - TablePlus
  - VS Code
- 公式配布 `.deb` を取得して管理
  - Discord
  - Obsidian

## 日本語入力の方針

- `mozc` 自体は Ubuntu 日本語環境に含まれている可能性があるため、まずは確認を優先します
- 起動時に直接入力ではなくひらがな入力にしたい場合は、`~/.config/mozc/ibus_config.textproto` の `active_on_launch: True` を構成管理します
- これは IBus + Mozc 構成を前提にしています

## 注意

- Chrome / Discord / Obsidian / TablePlus / VS Code は role 化済みです
- `mozc` の導入自体は未実装で、現状は確認と設定反映を優先しています
- `nvm` / `codex` / `newsql` は未実装です
- KDE の詳細設定は未実装です
- 手動手順をそのまま全部自動化するより、まずは再現性が高い項目から Ansible 化する方が低コストです
