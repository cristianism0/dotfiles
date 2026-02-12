# -- Git Aliases -- #
alias g="git"
alias gcm="git commit -m"
alias g-s="git status"

alias g-ca="commit --append --no-edit"

# -- Venv Aliases -- #
alias venv="uv venv .venv && source ./.venv/bin/activate"
alias uva="uv add"

# -- Random -- #
alias synt="syncthing"
alias vim="nvim"
alias shutdown="shutdown now"

rustrun() {
    local arquivo="$1"
    local destino="$2"
    shift 2
    mkdir -p "$destino"
    
    local binario="${arquivo%.rs}"
    
    rustc "$arquivo" -o "$destino/$binario" "$@" && "./$destino/$binario"
}

c-run() {
    local arquivo="$1"
    local destino="$2"
    shift 2
    mkdir -p "$destino"

    local binario="${arquivo%.c}"
    
    gcc "$arquivo" -o "$destino/$binario" "$@" && "./$destino/$binario"
}
