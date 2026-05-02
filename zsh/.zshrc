[[ -o interactive ]] || return

# --- Profiling --- (time debug)
# zmodload zsh/zprof
# EOF: zprof

# Function fot LazyLoad and sync
() {
  local f
  for f in "$ZDOTDIR/.zshrc" "$ZDOTDIR/.zshenv"; do
    [[ $f -nt ${f}.zwc ]] && zcompile "$f" 2>/dev/null
  done
}

fpath=( "$HOME/.zsh/plugins/zsh-completions/src" $fpath )

autoload -Uz compinit

() {
  local dump="$ZSH_COMPDUMP"
  if [[ -f $dump && $(find "$dump" -mtime -1 2>/dev/null) ]]; then
    compinit -C -d "$dump"
  else
    compinit -d "$dump"
  fi
}

[[ "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc" ]] && \
  zcompile "$ZSH_COMPDUMP" 2>/dev/null

# --- Estilo do completion ---
zstyle ':completion:*' menu select          
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 
zstyle ':completion:*' group-name ''                   
zstyle ':completion:*:descriptions' format '[%d]'     
zstyle ':completion:*:warnings' format 'Nada encontrado para: %d'
zstyle ':completion:*' use-cache yes                 
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/compcache"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

source "$HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons $realpath 2>/dev/null || ls --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --height=50% --layout=reverse --border=rounded
zstyle ':fzf-tab:*' switch-group ',' '.'

HISTSIZE=100000
SAVEHIST=100000

setopt HIST_IGNORE_DUPS         # não grava duplicatas consecutivas
setopt HIST_IGNORE_ALL_DUPS     # remove duplicata mais antiga
setopt HIST_FIND_NO_DUPS        # não mostra duplicatas ao buscar
setopt HIST_IGNORE_SPACE        # comandos com espaço inicial não são gravados (útil p/ senhas)
setopt HIST_REDUCE_BLANKS       # remove espaços extras antes de gravar
setopt HIST_VERIFY              # ao usar !!, mostra o comando antes de executar
setopt SHARE_HISTORY            # compartilha histórico entre sessões em tempo real
setopt EXTENDED_HISTORY         # grava timestamp e duração (:start:elapsed;command)
setopt INC_APPEND_HISTORY_TIME  # grava ao terminar o comando, não ao sair do shell


setopt AUTO_CD              # digitar o nome de um dir entra nele sem precisar de 'cd'
setopt AUTO_PUSHD           # cd empilha o dir anterior (use popd ou cd -)
setopt PUSHD_IGNORE_DUPS    # não empilha duplicatas
setopt PUSHD_SILENT         # não imprime a pilha após pushd/popd
setopt CORRECT              # sugere correção de comandos digitados errado
setopt INTERACTIVE_COMMENTS # permite # comentários em linha no shell interativo
setopt MULTIOS              # permite redirecionar para múltiplos destinos (cmd > a > b)
setopt EXTENDED_GLOB        # habilita padrões glob avançados: ^, #, ~
setopt GLOB_DOTS            # inclui arquivos ocultos (.foo) nos globs sem precisar de .*
setopt NO_BEEP              # silencia o beep de erro
setopt NO_FLOW_CONTROL      # libera Ctrl-S/Ctrl-Q para uso no readline


bindkey -e 

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A"  up-line-or-beginning-search   
bindkey "^[[B"  down-line-or-beginning-search
bindkey "^P"    up-line-or-beginning-search
bindkey "^N"    down-line-or-beginning-search

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

autoload -Uz vcs_info       
autoload -Uz colors && colors

setopt PROMPT_SUBST

zstyle ':vcs_info:*'          enable git
zstyle ':vcs_info:*'          check-for-changes true
zstyle ':vcs_info:git:*'      stagedstr   "%F{green}●%f"   # tem staged
zstyle ':vcs_info:git:*'      unstagedstr "%F{yellow}●%f"  # tem unstaged
zstyle ':vcs_info:git:*'      formats     " %F{magenta}(%b)%f%c%u"
zstyle ':vcs_info:git:*'      actionformats " %F{magenta}(%b|%a)%f%c%u"

precmd() { vcs_info }

_exit_code() {
  local code=$?
  (( code != 0 )) && echo " %F{red}✘$code%f"
}

# line 1: user@host  diretório  (branch●)  ✘código
# line 2: λ
PROMPT='%F{cyan}%n@%m%f %F{blue}%~%f${vcs_info_msg_0_}$(_exit_code)
%F{yellow}λ%f '

RPROMPT='%F{240}%*%f'

# grep colorido
alias grep='grep --color=auto'

# cd navegação
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# Git shortcuts
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

source "aliases.zsh"

# zsh-autosuggestions: sugere baseado no histórico (cinza, → ou End para aceitar)
source "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)  
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20            
ZSH_AUTOSUGGEST_USE_ASYNC=1                  
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"

source "$HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

ZSH_HIGHLIGHT_STYLES[command]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[function]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[path]='fg=blue'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[comment]='fg=240'

# zprof
