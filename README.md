
## Dependencias

Dependencias para o WM:

```bash
sudo dnf copr enable yalter/niri
sudo dnf install niri swayidle swaylock waybar mock kitty wofi fastfetch zsh
```

Para os editores de texto:

```bash
sudo dnf install emacs nvim
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
./dotfiles/auto_symlink.sh --dry-run
```

Se tudo estiver OK, tira o dry-run.

