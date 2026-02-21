# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)   

source $ZSH/oh-my-zsh.sh

 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

# -- Load Aliases -- #

ALIAS_FILE="$HOME/dotfiles/aliases.zsh"

if [[ ! -f "$ALIAS_FILE" ]]; then
    touch "$ALIAS_FILE" 
fi

source $ALIAS_FILE

export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:$HOME/go/bin
