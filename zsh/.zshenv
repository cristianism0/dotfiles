# --- Distro detection ---
if   command -v apt-get &>/dev/null; then export PKG_MANAGER="apt"
elif command -v pacman  &>/dev/null; then export PKG_MANAGER="pacman"
fi

# --- XDG Base Directory ---
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# #.zcompdump, .zsh_history etc... into XDG state directories instead of the home
export ZDOTDIR="$HOME/.config/zsh"              # .zshrc location
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
export HISTFILE="$XDG_STATE_HOME/zsh/history"

mkdir -p "$XDG_CACHE_HOME/zsh" "$XDG_STATE_HOME/zsh"

# --- Path ---
typeset -U path
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  /usr/local/bin
  $path            
)
export PATH

# --- Editor & pager ---
export EDITOR="${EDITOR:-nvim}"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-RFX"       # -R: cores ANSI | -F: sai se cabe na tela | -X: não limpa

# --- Locale ---
export LANG="${LANG:-pt_BR.UTF-8}"
export LC_ALL="${LC_ALL:-pt_BR.UTF-8}"

# FZF — pesquisa fuzzy usada em fzf-tab e Ctrl-R
export FZF_DEFAULT_OPTS="
  --height=40%
  --layout=reverse
  --border=rounded
  --info=inline
  --prompt='❯ '
  --pointer='▶'
  --color=fg:#cdd6f4,bg:-1,hl:#89b4fa
  --color=fg+:#cdd6f4,bg+:#313244,hl+:#89b4fa
  --color=info:#cba6f7,prompt:#cba6f7,pointer:#f5e0dc
  --color=marker:#a6e3a1,spinner:#f5e0dc,header:#89dceb
"

# BAT 
if   command -v bat    &>/dev/null; then export MANPAGER="sh -c 'col -bx | bat -l man -p'"
elif command -v batcat &>/dev/null; then export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
fi

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export NEXT_TELEMETRY_DISABLED=1
export GATSBY_TELEMETRY_DISABLED=1
