## Dependencias
Para usar o sway e baixar todos os items necessários:

```bash
sudo apt update && sudo apt install \
sway swayidle swaylock waybar swaybg \
nm-connection-editor brightnessctl playerctl pavucontrol \
wofi mako kitty fastfetch \
grim slurp wl-clipboard \
pulseaudio-utils fonts-font-awesome unzip
```

Para os editores de texto:
```bash
sudo apt install emacs nvim
```
É necessário ainda baixar o Fira Code Nerd Font e o Brave Browser.

Brave:
```bash
curl -fsS https://dl.brave.com/install.sh | sh
```

Fira Code fontes:
```bash
mkdir -p ~/.local/share/fonts
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
cd ~/.local/share/fonts
unzip FiraCode.zip
rm FiraCode.zip
fc-cache -fv
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
