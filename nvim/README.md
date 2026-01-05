# Dotfiles NVIM

I use Fedora, so, we need to have LSP servers.

We currently use:
- Lua (default)
- Python 
- Rust
- C
- Go

## Installing
1. For Python, we will use `Ruff`, because there's a package of it on `dnf`:
```bash
sudo dnf upgrade
sudo dnf install ruff
```

2. For Rust we can use Rust Analyzer. It's already on the default install of Rust.
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
``` 

3. For C, like Ruff, we can install using dnf too:
```bash
sudo dnf install clangd
```

4. For GO, we can install directly from Mason (:Mason). We will use `gopls`:
```bash
go install golang.org/x/tools/gopls@latest
```
