# Dotfiles

## Dependências

A lista completa de pacotes usados pelas configurações. Os nomes variam por distribuição — o `fast_setup.sh` normaliza isso automaticamente (dnf, pacman, apt).

### WM e ambiente de janelas

- `niri` — compositor Wayland (tiling)
- `noctalia` — configurações/daemon do desktop sobre o niri
- `swaylock` (bloqueio de tela), `swaync` (notificações), `waybar`, `wlogout`, `fuzzel` (launcher)

### Terminais e aplicativos

- `alacritty`, `kitty`
- `fastfetch`, `btop`, `cava`
- `emacs`, `neovim`, `zsh`, `fzf`, `bat`
- `grim`, `slurp`, `wl-clipboard` — screenshots e clipboard no Wayland
- `qt6ct`, `pavucontrol`, `wireplumber`, `power-profiles-daemon`
- `NetworkManager` (nmcli), `bluez` (bluetoothctl), `nautilus`
- `git`, `curl`, `jq`, `ffmpeg`, `python3`, `gcc`

### Fontes

- Fira Code, JetBrains Mono, Inter, Alegreya, JuliaMono
- Obs.: as configurações esperam variantes *Nerd Font*;
se o seu gerenciador só fornece a fonte normal, instale a variante Nerd manualmente.

### Linguagens e LSPs

- LSPs via gerenciador: `lua-language-server`, `clangd`/`clang-tools-extra`, `ruff`, `pyright`, `stylua`
- `rust-analyzer` e `gopls`: instalados pela própria toolchain, não pelo gerenciador
  - Rust: `rustup` (`https://rustup.rs`) + `cargo install rust-analyzer`
  - Go: pacote `go`/`golang` + `go install golang.org/x/tools/gopls@latest`
- Haskell: `ghcup` (`https://www.haskell.org/ghcup/`) — instala o próprio HLS

## Setup

1. Clone o repositório

```bash
mkdir -p ~/Projetos && cd ~/Projetos
git clone https://github.com/cristianism0/dotfiles.git && cd dotfiles
```

2. **`fast_setup.sh` (recomendado)** — instala as dependências, gera os symlinks e configura o wallpaper

```bash
chmod +x fast_setup.sh
./fast_setup.sh
```

Passos do script:

1. Detecta automaticamente o gerenciador de pacotes instalado (`dnf`, `pacman`, `apt` ou `dpkg`) e informa qual está sendo usado.
2. Instala WM (niri/noctalia quando disponíveis), aplicativos, fontes e LSPs de cada categoria disponível.
3. Pergunta se você quer instalar as toolchains de Rust e Haskell (exibe o link do site e o comando usado). Se instalar a toolchain do Rust, pergunta se instala o `rust-analyzer` via `cargo`; o Go pergunta se instala `gopls`.
4. Executa o `auto_symlink.sh --dry-run` e pergunta se aplica os symlinks de verdade.
5. Pergunta se quer configurar o wallpaper, listando as opções da pasta `wallpapers/`.

3. **`auto_symlink.sh` (manual)** — gera os symlinks dos dotfiles para `~/.config`. Use o `--dry-run` primeiro

```bash
chmod +x auto_symlink.sh
./auto_symlink.sh --dry-run
```

Se tudo estiver OK, rode novamente sem o `--dry-run`. Edite a lista `IGNORED_FILES` no script para controlar o que é linkado.
