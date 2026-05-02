#!/usr/bin/env bash

set -e

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()    { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERR ]${NC} $*"; exit 1; }

detect_distro() {
  if command -v apt-get &>/dev/null; then
    echo "debian"
  elif command -v pacman &>/dev/null; then
    echo "arch"
  else
    error "Distro não suportada. Instale os pacotes manualmente."
  fi
}

DISTRO=$(detect_distro)
info "Distro detectada: $DISTRO"

install_deps() {
  if [[ $DISTRO == "debian" ]]; then
    sudo apt-get update -qq
    sudo apt-get install -y zsh git curl
  else
    sudo pacman -Sy --noconfirm zsh git curl
  fi
}

info "Instalando dependências..."
install_deps

ZSH_PLUGINS="$HOME/.zsh/plugins"
mkdir -p "$ZSH_PLUGINS"

clone_or_update() {
  local name=$1 url=$2
  if [[ -d "$ZSH_PLUGINS/$name" ]]; then
    info "Atualizando $name..."
    git -C "$ZSH_PLUGINS/$name" pull --ff-only -q
  else
    info "Clonando $name..."
    git clone --depth=1 -q "$url" "$ZSH_PLUGINS/$name"
  fi
}

clone_or_update "zsh-syntax-highlighting" \
  "https://github.com/zsh-users/zsh-syntax-highlighting"

clone_or_update "zsh-autosuggestions" \
  "https://github.com/zsh-users/zsh-autosuggestions"

clone_or_update "zsh-completions" \
  "https://github.com/zsh-users/zsh-completions"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cp "$SCRIPT_DIR/.zshenv" "$HOME/.zshenv"
cp "$SCRIPT_DIR/.zshrc"  "$HOME/.zshrc"
info "Arquivos de configuração copiados."

# --- Compila completion cache (antecipado) ------------------------------------
zsh -c 'autoload -Uz compinit && compinit -d ~/.zcompdump' 2>/dev/null || true

# --- Define ZSH como shell padrão ---------------------------------------------
if [[ "$SHELL" != "$(which zsh)" ]]; then
  warn "Definindo ZSH como shell padrão (requer senha)..."
  chsh -s "$(which zsh)"
fi

info "✔ Instalação concluída! Abra um novo terminal ou execute: exec zsh"
