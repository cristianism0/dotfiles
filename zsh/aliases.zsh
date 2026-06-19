# Aliases and Functions

FILE_LOCATE="$HOME/.config/zsh/aliases.zsh"

# ------------- Alias ----------------- #
alias shutdown='shutdown now'
alias update='sudo dnf update'
alias venv='source .venv/bin/activate'
alias vim='nvim'

alias grep='grep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias la='ls -a'

alias g='git'
alias ga='git add'
alias gc='git commit -v'
alias gp='git push'
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate -20'
alias gd='git diff'


alias ip='ip -c'
alias df='df -hT'
alias du='du -sh'
alias free='free -h'
alias ports='ss -tulnp'
alias path='echo $PATH | tr ":" "\n"'
alias reload='exec zsh'
alias zshrc='$EDITOR ~/.zshrc'

# ------------- Functions ----------------- #
compile() {gcc "$1" -o "${1%.c}" && ./"$1"}
add-alias() {
    local aliase="$1"
    
    if [[ -z "$1" ]]; then
        echo "Alias cannot be empty."
        echo "Use: add-alias name='function'"
        return 1
    fi
    if grep -qF "alias ${aliase}" "$FILE_LOCATE"; then
        echo "Alias already exists in file."
        return 1
    fi
    if [[ ! "$aliase" =~ "^[^=]+='[^']+'$" ]]; then
        echo "Format error. Use: name='function'"
        return 1
    fi

    echo "alias ${1}" >> "$HOME/.config/zsh/aliases.zsh"
    echo "Alias 'alias ${aliase}' added successfully.
}

