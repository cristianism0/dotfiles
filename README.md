## Dependencias
Para usar o sway e baixar todos os items necessários:

```bash
sudo pacman -Syu && sudo pacman -S \
niri swayidle swaylock waybar swaybg swaync \
brightnessctl playerctl pavucontrol \
fuzzel alacritty fastfetch blueman-applet\
grim slurp wl-clipboard wireplumber btop
```

Para os editores de texto:

```bash
sudo pacman -S emacs nvim
```
É necessário ainda baixar o Iosevka Nerd
```bash
sudo pacman -S ttf-iosevka-nerd
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
