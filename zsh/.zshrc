# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)   

ZSH_THEME=""

source "$ZSH/oh-my-zsh.sh"
source "$ZDOTDIR/themes/metalicfedora.zsh-theme"

 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

# -- Load Aliases -- #
# ZDOTDIR definend o .zshenv
ALIAS_FILE="$ZDOTDIR/aliases.zsh"

if [[ ! -f "$ALIAS_FILE" ]]; then
    touch "$ALIAS_FILE" 
fi

source $ALIAS_FILE

export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:$HOME/go/bin

# -- Customization -- #
# Custom bar code inspired from BreadOnPenguins: -> https://github.com/BreadOnPenguins/dots/
NEWLINE=$'\n'

BARRA_STATUS="${NEWLINE}\x1b[48;5;234m\x1b[38;5;111m $(print -P '%D{%_I:%M%P}') \x1b[0m"
BARRA_STATUS+="\x1b[48;5;235m\x1b[38;5;234m\x1b[38;5;111m $(uptime -p | cut -c 4-) \x1b[0m"
BARRA_STATUS+="\x1b[48;5;236m\x1b[38;5;235m\x1b[38;5;153m  $(uname -r) \x1b[0m"
BARRA_STATUS+="\x1b[38;5;236m\x1b[0m"

echo -e "$BARRA_STATUS \n"



