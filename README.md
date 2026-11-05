# ubuntu_desktop_setup

Ubuntu Desktop を Ansible で構成管理するためのリポジトリです。  
現在の主対象は **GNOME (Wayland) ベースの Ubuntu 26.04 LTS デスクトップ初期構築** です。

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
    ├── desktop_gnome
    ├── devtools
    ├── input_check
    ├── japanese_input
    ├── nvm
    └── third_party_apps
```

## 実行方法

前提:

- Ubuntu 上で実行する
- `ansible-playbook` がインストール済みである
- `sudo` 可能なユーザーで実行する

```bash
# ansible installation
chmod +x install_ansible.sh
sudo bash install_ansible.sh

# run playbook
sudo ansible-playbook ansible/site.yml
```

`ansible.cfg` で `ansible/inventory.ini` と `ansible/roles` を参照する設定にしています。

## このリポジトリで管理したい内容

手動セットアップで実施していた内容を管理する想定です。

```md
| ロール | 推測される役割 |
|---|---|
| `base` | 基本パッケージ・共通設定 |
| `desktop_gnome` | GNOMEデスクトップ環境のセットアップ |
| `third_party_apps` | Discord・Obsidianなどサードパーティ製アプリの導入 |
| `devtools` | 開発ツール（git・dockerなど）の導入 |
| `nvm` | nvm・Node.js・Claude Code / Codex CLI の導入 |
| `japanese_input` | 日本語入力（ibus-mozc）の設定 |
| `input_check` | 設定確認・動作チェック |
```

- 基本パッケージ
  - `curl`
  - `ca-certificates`
  - `gnupg`
  - `unattended-upgrades`
- デスクトップ環境
  - GNOME
  - Super 単押しの Activities は無効化
  - Super+←/→ はワークスペース移動（Tiling Assistant は無効化）
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
  - ibus-mozc
  - Super+Space で入力ソースを切り替える（GNOME の既定）
- セキュリティアップデート
  - `unattended-upgrades`

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

- 起動時に直接入力ではなくひらがな入力にしたい場合は、`~/.config/mozc/ibus_config.textproto` の `active_on_launch: True` を構成管理します
