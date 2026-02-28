# -- Load Aliases -- #
[[ -f "$ZDOTDIR/aliases.zsh" ]] && source $ZDOTDIR/aliases.zsh

# -- Modules -- #
zmodload zsh/complist               # allow select directions and files on a menu
autoload -U compinit && compinit    # init everything
autoload -U colors && colors        # allow using colors with &fg instead ansi

# -- Theme -- #
source "$ZDOTDIR/themes/metalicblue.zsh-theme"

# -- Opts -- #
setopt append_history inc_append_history share_history
setopt auto_menu menu_complete
setopt autocd                                           # type dir to autocd
setopt auto_param_slash                                 # disable glob dir patterns
setopt no_case_glob no_case_match                       # disable case sensitive
setopt globdots
setopt extended_glob
setopt interactive_comments                             # allow comments in shell
unsetopt prompt_sp

# -- Bindings -- #
bindkey -e
bindkey "^[[1;5C" forward-word                          # Ctrl + <Right> go to next word
bindkey "^[[1;5D" backward-word                         # Ctrl + <Left> go to previous word
bindkey '^H' backward-kill-word                         # Ctrl + Backspace kill word

# -- History -- #
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$HOME/.cache/zsh_history"

# -- Paths -- #
export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:$HOME/go/bin
export PATH="$HOME/.cargo/bin:$PATH"

# -- Customization -- #
# Custom bar code and opts inspired from BreadOnPenguins: -> https://github.com/BreadOnPenguins/dots/
NEWLINE=$'\n'
BARRA_STATUS="${NEWLINE}\x1b[48;5;234m\x1b[38;5;111m $(print -P '%D{%H:%M}') \x1b[0m"
BARRA_STATUS+="\x1b[48;5;235m\x1b[38;5;234m\x1b[38;5;111m $(uptime -p | cut -c 4-) \x1b[0m"
BARRA_STATUS+="\x1b[48;5;236m\x1b[38;5;235m\x1b[38;5;153m  $(uname -r) \x1b[0m"
BARRA_STATUS+="\x1b[38;5;236m\x1b[0m"
echo -e "$BARRA_STATUS \n"

# -- Plugins -- #
source $PLUGINSDIR/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source $PLUGINSDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
