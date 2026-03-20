#!/bin/bash
# ============================================================
# Ansible インストールスクリプト (Ubuntu / PPA 方式)
# 参考: https://docs.ansible.com/projects/ansible/latest/installation_guide/intro_installation.html
# ============================================================

set -e  # エラー発生時にスクリプトを停止

# --- カラー出力の定義 ---
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo_info()    { echo -e "${CYAN}[INFO]${NC}  $1"; }
echo_success() { echo -e "${GREEN}[OK]${NC}    $1"; }
echo_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# --- sudo チェック ---
if [ "$EUID" -ne 0 ]; then
    echo_error "このスクリプトは sudo で実行してください。"
    echo "  例: sudo bash $0"
    exit 1
fi

echo ""
echo "======================================"
echo "  Ansible インストール (PPA 方式)"
echo "======================================"
echo ""

# 1. パッケージリストの更新
echo_info "パッケージリストを更新中..."
apt-get update -y

# 2. software-properties-common のインストール
echo_info "software-properties-common をインストール中..."
apt-get install -y software-properties-common

# 3. Ansible 公式 PPA の追加
echo_info "Ansible 公式 PPA を追加中..."
add-apt-repository --yes --update ppa:ansible/ansible

# 4. Ansible のインストール
echo_info "Ansible をインストール中..."
apt-get install -y ansible

echo ""
echo_success "Ansible のインストールが完了しました！"

# 5. 動作確認
echo ""
echo "---------- ansible --version ----------"
ansible --version
echo "---------------------------------------"
echo ""
echo_success "セットアップ完了。"
