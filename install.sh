#!/usr/bin/env bash
#
# Instalador dos dotfiles: dependências, plugins do zsh e symlinks.
#
# Uso:
#   ./install.sh              instala tudo
#   ./install.sh --dry-run    mostra o que seria feito, sem alterar nada
#   ./install.sh --skip-deps  não instala pacotes do sistema
#   ./install.sh --help       mostra esta ajuda
#
set -euo pipefail

REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CONFIG_DIR="$HOME/.config"
PLUGIN_DIR="$HOME/.zsh/plugins"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

DRY_RUN=false
SKIP_DEPS=false

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERR ]${NC} $*" >&2; exit 1; }
step()  { echo -e "\n${BLUE}==> $*${NC}"; }

CREATED=0
UPDATED=0
UNCHANGED=0
BACKUPS=0

usage() {
    cat <<EOF
Uso: $(basename "$0") [opções]

Opções:
  --dry-run     Não altera nada (nem roda sudo); apenas mostra as ações.
  --skip-deps   Não instala zsh/git/curl no sistema.
  -h, --help    Mostra esta ajuda.

Symlinks criados:
  \$HOME/.config/{alacritty,emacs,fastfetch,niri,nvim,zsh} -> $REPO_DIR/<dir>
  \$HOME/.tmux.conf -> $REPO_DIR/.tmux.conf
  \$HOME/.zshenv    -> $REPO_DIR/zsh/.zshenv
EOF
}

# Executa um comando, ou apenas o imprime em dry-run.
run() {
    if [[ $DRY_RUN == true ]]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} $*"
    else
        "$@"
    fi
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run)   DRY_RUN=true ;;
            --skip-deps) SKIP_DEPS=true ;;
            -h|--help)   usage; exit 0 ;;
            *)           error "Opção desconhecida: $1 (use --help)" ;;
        esac
        shift
    done
}

detect_distro() {
    if command -v apt-get &>/dev/null; then
        echo "debian"
    elif command -v pacman &>/dev/null; then
        echo "arch"
    elif command -v dnf &>/dev/null; then
        echo "fedora"
    else
        echo "unknown"
    fi
}

install_deps() {
    local distro
    distro=$(detect_distro)
    step "Dependências do sistema"

    if [[ $SKIP_DEPS == true ]]; then
        info "Pulando instalação de dependências (--skip-deps)."
        return
    fi

    case "$distro" in
        debian)
            info "Distro detectada: debian"
            run sudo apt-get update -qq
            run sudo apt-get install -y zsh git curl
            ;;
        fedora)
            info "Distro detectada: fedora"
            run sudo dnf install -y zsh git curl
            ;;
        arch)
            info "Distro detectada: arch"
            run sudo pacman -Sy --noconfirm zsh git curl
            ;;
        *)
            warn "Distro não suportada. Instale manualmente: zsh git curl"
            return
            ;;
    esac
}

clone_or_update() {
    local name=$1 url=$2 dir="$PLUGIN_DIR/$1"

    if [[ -d $dir ]]; then
        info "Atualizando $name..."
        run git -C "$dir" pull --ff-only -q
    else
        info "Clonando $name..."
        run git clone --depth=1 -q "$url" "$dir"
    fi
}

install_plugins() {
    step "Plugins do zsh"

    run mkdir -p "$PLUGIN_DIR"

    clone_or_update "zsh-syntax-highlighting" \
        "https://github.com/zsh-users/zsh-syntax-highlighting"
    clone_or_update "zsh-autosuggestions" \
        "https://github.com/zsh-users/zsh-autosuggestions"
    clone_or_update "zsh-completions" \
        "https://github.com/zsh-users/zsh-completions"
}

# link <origem> <destino>
# Idempotente: não recria links corretos, substitui links errados e
# faz backup de arquivos/diretórios reais antes de linkar.
link() {
    local src="$1" dest="$2"
    local replaced=false

    if [[ -L $dest ]]; then
        if [[ $(readlink -f "$dest") == $(readlink -f "$src") ]]; then
            info "ok: $dest"
            UNCHANGED=$((UNCHANGED + 1))
            return
        fi
        info "Substituindo symlink: $dest"
        run rm -f "$dest"
        replaced=true
        UPDATED=$((UPDATED + 1))
    elif [[ -e $dest ]]; then
        local backup="${dest}.bak_${TIMESTAMP}"
        warn "Arquivo existente: $dest -> backup em ${backup##*/}"
        run mv "$dest" "$backup"
        BACKUPS=$((BACKUPS + 1))
    fi

    run ln -s "$src" "$dest"
    if [[ $DRY_RUN == false ]]; then
        info "link: $dest -> $src"
    fi
    [[ $replaced == true ]] || CREATED=$((CREATED + 1))
}

create_symlinks() {
    step "Symlinks"

    run mkdir -p "$CONFIG_DIR"

    # Diretórios do repo linkados em ~/.config
    local dirs=(
        alacritty
        emacs
        fastfetch
        umbriel
        nvim
        zsh
    )
    local d
    for d in "${dirs[@]}"; do
        link "$REPO_DIR/$d" "$CONFIG_DIR/$d"
    done

    # Arquivos linkados na home: "origem_no_repo:destino"
    local pairs=(
        ".tmux.conf:.tmux.conf"
        "zsh/.zshenv:.zshenv"
    )
    local pair src dest
    for pair in "${pairs[@]}"; do
        src=${pair%%:*}
        dest=${pair##*:}
        link "$REPO_DIR/$src" "$HOME/$dest"
    done
}

# O zsh lê .zshrc de $ZDOTDIR (~/.config/zsh, já linkado), então um
# ~/.zshrc na home é legado do antigo install.sh que copiava o arquivo.
cleanup_legacy_zshrc() {
    local legacy="$HOME/.zshrc"
    local repo_rc="$REPO_DIR/zsh/.zshrc"

    step "Limpeza do ~/.zshrc legado"

    if [[ ! -e $legacy && ! -L $legacy ]]; then
        info "Nada a fazer."
        return
    fi

    if [[ -L $legacy ]]; then
        info "Removendo symlink redundante: $legacy"
        run rm -f "$legacy"
        return
    fi

    if cmp -s "$legacy" "$repo_rc"; then
        info "Removendo cópia idêntica ao repo: $legacy"
        run rm -f "$legacy"
    else
        local backup="${legacy}.bak_${TIMESTAMP}"
        warn "~/.zshrc difere do repo; backup em ${backup##*/}"
        run mv "$legacy" "$backup"
        BACKUPS=$((BACKUPS + 1))
    fi
}

finalize() {
    step "Finalizando"

    if [[ $DRY_RUN == false ]] && command -v zsh &>/dev/null; then
        zsh -c 'autoload -Uz compinit && compinit -d "${ZSH_COMPDUMP:-$HOME/.zcompdump}"' \
            &>/dev/null || warn "Não foi possível rodar compinit agora (será refeito no primeiro shell)."
    fi

    if [[ ${SHELL:-} != *zsh ]]; then
        warn "Shell padrão atual: ${SHELL:-desconhecido}. Para trocar: chsh -s \"\$(command -v zsh)\""
    fi

    echo
    info "Resumo: $CREATED criado(s), $UPDATED atualizado(s), $UNCHANGED já correto(s), $BACKUPS backup(s)."
    if [[ $DRY_RUN == true ]]; then
        echo -e "${YELLOW}Dry-run: nenhuma alteração foi feita.${NC}"
    fi
}

main() {
    parse_args "$@"

    echo -e "${BLUE}Instalando dotfiles a partir de $REPO_DIR${NC}"
    if [[ $DRY_RUN == true ]]; then
        echo -e "${YELLOW}>>> MODO DRY-RUN: nenhuma alteração será feita${NC}"
    fi

    install_deps
    install_plugins
    create_symlinks
    cleanup_legacy_zshrc
    finalize
}

main "$@"
