## Dependencias

### Básico
Editores de texto, fontes, WM e pacotes.

```bash
sudo dnf update && sudo dnf install \
niri noctalia alacritty fastfetch btop ht-alegreya-fonts rsms-inter-fonts \
emacs neovim zsh
```
## Setup

1. Clona o repositório
```bash
git clone https://github.com/cristianism0/dotfiles.git
```

2. Executar o script para gerar os symlinks automáticos.
Usa primeiro o `--dry-run` antes de fazer a modificação.

```bash
chmod +x ~/dotfiles/auto_symlink.sh
. $HOME/dotfiles/auto_symlink.sh --dry-run
```

Se tudo estiver OK, tira o dry-run.
