# Dotfiles

## Dependências
As principais dependencias são para o ambiente de trabalho e necessários para código como editores e compiladores/interpretadores.

A base da instalação:
```bash
sudo dnf update -y && sudo dnf install alacritty niri noctalia, neovim, go, uv 
```

Fira Code é a padrão, necessária para o Alacritty, as demais são apenas para o Emacs, se não for usar não são necessárias.
- Fira Code, JetBrains Mono, Inter, Alegreya, JuliaMono

## Toolchains
Rust e Haskell são instaladas direto pelo site, o Go existe o pacote dentro do proprio dnf.
As toolchains precisam de compiladores para rodar, tenha todos instalados.
Instala também o hugo.
```bash
sudo dnf install gcc make perl gmp-devel libffi-devel zlib-devel git
```
- Rust: `rustup` (`https://rustup.rs`)
- Go: pacote `go`/`golang` + `go install golang.org/x/tools/gopls@latest`
- Haskell: `ghcup` (`https://www.haskell.org/ghcup/`) — instala o hls junto também.


## Setup
Faz o clone:
```bash
cd ~/.config && git clone https://github.com/cristianism0/dotfiles && cd dotfiles
```

Agora, os principais symlinks:
```bash
chmod +x auto_symlink.sh
./auto_symlink.sh --dry-run
```
Se tudo estiver OK, rode novamente sem o `--dry-run`. Edite a lista `IGNORED_FILES` no script para controlar o que é linkado.

Se fez os sylinks manuais, lembra de fazer o symlink do .zshenv. Ele precisa estar na home e linkado com o $ZDOTDIR.
```bash
ln -s ~/config/dotfiles/zsh/.zshenv ~/
```
