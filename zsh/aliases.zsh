# Aliases and Functions

typeset -g FILE_LOCATE="${ZDOTDIR:-$HOME/.config/zsh}/aliases.zsh"

# ------------- Functions ----------------- #
add-alias() {
    local name="$1"
    if [[ -z "$name" || $# -lt 2 ]]; then
        echo "Use: add-alias name command..."
        return 1
    fi
    if [[ "$name" == *[^A-Za-z0-9_.-]* ]]; then
        echo "Invalid alias name: $name"
        return 1
    fi
    if grep -q "^alias ${name}=" "$FILE_LOCATE"; then
        echo "Alias '$name' already exists in file."
        return 1
    fi

    local cmd="${*:2}"
    local line="alias ${name}=${(qq)cmd}"

    print -r -- "$line" >> "$FILE_LOCATE" || return 1
    eval "$line"
    echo "Added: $line"
}

compile() {
    [[ -f "$1" ]] || { echo "uso: compile arquivo.c [args...]" >&2; return 1; }
    local out="${1%.c}"
    gcc -Wall -Wextra -g "$1" -o "$out" && "${out:A}" "${@:2}"
}

compasm() {
    [[ -f "$1" ]] || { echo "uso: compasm arquivo.c [0-3]" >&2; return 1; }
    local otim="${2:-0}"
    case "$otim" in
        0|1|2|3) ;;
        *) echo "erro: otimização inválida: $otim" >&2; return 1 ;;
    esac
    gcc "-O${otim}" -S -masm=intel -fno-asynchronous-unwind-tables \
        -o "${1%.c}.s" "$1"
}

shutdown() {
    (( $# )) || set -- now
    command shutdown "$@"
}

update() {
    local id; id=$(. /etc/os-release; print -r -- "$ID $ID_LIKE")
    case "$id" in
        *arch*)   sudo pacman -Syu ;;
        *fedora*) sudo dnf upgrade --refresh ;;
        *debian*) sudo apt update && sudo apt upgrade ;;
        *) echo "update: distro não suportada: $id" >&2; return 1 ;;
    esac
}

venv() {
    [[ -d .venv ]] || uv venv .venv || return
    source .venv/bin/activate
}

# ------------- Alias ----------------- #
alias v='nvim'
alias em='emacsclient -t -a ""'

alias grep='grep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias ls='ls --color=auto'
alias la='ls -a'

alias g='git'
alias ga='git add'
alias gc='git commit -v'
alias gp='git push'
alias gs='git status'
alias gl='git log --oneline --graph --decorate -20'
alias gd='git diff'


alias ip='ip -c'
alias df='df -hT'
alias du='du -h'
alias dus='du -sh'
alias free='free -h'
alias ports='ss -tulnp'
alias paths='print -l $path'
alias reload='exec zsh'
alias zshrc='$EDITOR "$ZDOTDIR/.zshrc"'
alias aliases='$EDITOR "$FILE_LOCATE"'
alias c='clear'
