#!/usr/bin/env bash
# fast_setup.sh — installs repo dependencies, generates symlinks and sets up the wallpaper.
# Usage: ./fast_setup.sh   (depends on auto_symlink.sh in the same directory)

set -u

# toolchain install links
RUSTUP_SITE="https://rustup.rs"
RUSTUP_INSTALL="https://sh.rustup.rs"
GHCUP_SITE="https://www.haskell.org/ghcup/"
GHCUP_INSTALL="https://get-ghcup.haskell.org"

RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[1;33m'
BLUE=$'\033[0;34m'; BOLD=$'\033[1m'; NC=$'\033[0m'

info()    { echo -e "${BOLD}${BLUE}[INFO]${NC} $*"; }
ok()      { echo -e "${GREEN}  OK  :: $*${NC}"; }
warn()    { echo -e "${YELLOW}  SKIP :: $*${NC}"; }
section() { echo -e "\n${BOLD}${BLUE}── $* ──${NC}"; }

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
INSTALLED=()
SKIPPED=()

confirm() {
  local ans
  read -r -p "$1 [y/N] (Default: N) " ans
  case "${ans:-N}" in
    y|Y|yes|Yes|YES) return 0 ;;
    *) return 1 ;;
  esac
}

check_pkg() {
  case "$PM" in
    dnf)     dnf info --quiet "$1" &>/dev/null ;;
    pacman)  pacman -Si "$1" &>/dev/null ;;
    apt|dpkg) apt-cache show "$1" &>/dev/null ;;
  esac
}

is_installed() {
  case "$PM" in
    dnf)     rpm -q "$1" &>/dev/null ;;
    pacman)  pacman -Qq "$1" &>/dev/null ;;
    apt|dpkg) dpkg -s "$1" &>/dev/null ;;
  esac
}

do_install() {
  local label="$1" p
  shift
  local pkgs=("$@") avail=() missing=()
  for p in "${pkgs[@]}"; do
    if check_pkg "$p"; then avail+=("$p"); else missing+=("$p"); fi
  done
  for p in "${missing[@]}"; do
    warn "[$label] $p not available on $PM"
    SKIPPED+=("$p (not available on $PM)")
  done
  [[ ${#avail[@]} -eq 0 ]] && return
  echo -e "${BOLD}Installing [$label]:${NC} ${avail[*]}"
  case "$PM" in
    dnf)    sudo dnf install -y --skip-unavailable "${avail[@]}" ;;
    pacman) sudo pacman -S --needed --noconfirm "${avail[@]}" ;;
    apt|dpkg) sudo apt-get install -y "${avail[@]}" ;;
  esac
  for p in "${avail[@]}"; do
    if is_installed "$p"; then
      INSTALLED+=("[$label] $p")
    else
      warn "[$label] $p failed to install"
      SKIPPED+=("$p (installation failed)")
    fi
  done
}

# curl-based toolchain install (Rust, Haskell): shows the site + install command,
# asks for confirmation, runs it and verifies the result.
install_curl_toolchain() {
  local name="$1" site="$2" url="$3" verify="$4" shargs="${5:-}"
  info "site   : $site"
  info "install: curl --proto '=https' --tlsv1.2 -sSf $url | sh $shargs"
  if confirm "Install the $name toolchain?"; then
    curl --proto '=https' --tlsv1.2 -sSf "$url" | sh $shargs
    if eval "$verify"; then
      ok "$name toolchain installed"
      INSTALLED+=("[toolchain] $name")
      return 0
    else
      warn "$name toolchain failed to install"
      SKIPPED+=("$name toolchain (installation failed)")
      return 1
    fi
  else
    SKIPPED+=("$name toolchain (not chosen)")
    return 1
  fi
}

echo -e "${BOLD}${BLUE}════════ fast_setup ════════${NC}"
PM=""
for mgr in dnf pacman apt-get dpkg; do
  if command -v "$mgr" &>/dev/null; then
    case "$mgr" in
      apt-get) PM=apt ;;
      *)       PM=$mgr ;;
    esac
    break
  fi
done
if [[ -z $PM ]]; then
  echo -e "${RED}No supported package manager found (dnf, pacman, apt, dpkg).${NC}" >&2
  exit 1
fi
info "The package manager $PM is being used."
if [[ $PM == dpkg ]]; then
  info "dpkg cannot resolve dependencies; apt-get will be used as the back-end."
fi

if [[ $PM == apt || $PM == dpkg ]]; then
  info "Updating package lists (apt)..."
  sudo apt-get update -qq
fi

# ---- package lists ----
# "wm" is identical on every manager; the rest is keyed by "PM:category".
# dpkg (raw dpkg) reuses the apt lists (see list()).
declare -A PKGS=(
  ["wm"]="niri noctalia"

  ["dnf:apps"]="alacritty kitty fuzzel waybar SwayNotificationCenter swaylock wlogout fastfetch btop cava emacs neovim zsh fzf bat git curl jq ffmpeg python3 gcc grim slurp wl-clipboard qt6ct power-profiles-daemon pavucontrol wireplumber NetworkManager bluez nautilus"
  ["dnf:fonts"]="fira-code-fonts jetbrains-mono-fonts rsms-inter-fonts ht-alegreya-fonts juliamono-fonts"
  ["dnf:lsp"]="lua-language-server clang-tools-extra ruff pyright"

  ["pacman:apps"]="alacritty kitty fuzzel waybar swaync swaylock wlogout fastfetch btop cava emacs neovim zsh fzf bat git curl jq ffmpeg python gcc grim slurp wl-clipboard qt6ct power-profiles-daemon pavucontrol wireplumber networkmanager bluez nautilus"
  ["pacman:fonts"]="ttf-firacode-nerd ttf-jetbrainsmono-nerd inter-font ttf-alegreya otf-juliamono"
  ["pacman:lsp"]="lua-language-server clang ruff pyright stylua"

  ["apt:apps"]="alacritty kitty fuzzel waybar sway-notification-center swaylock wlogout fastfetch btop cava emacs neovim zsh fzf bat git curl jq ffmpeg python3 gcc grim slurp wl-clipboard qt6ct power-profiles-daemon pavucontrol wireplumber network-manager bluez nautilus"
  ["apt:fonts"]="fonts-firacode fonts-jetbrains-mono fonts-inter fonts-alegreya"
  ["apt:lsp"]="lua-language-server clangd ruff pyright"
)

list() {
  local cat=$1 pm=$PM
  [[ $pm == dpkg ]] && pm=apt
  if [[ $cat == wm ]]; then
    echo "${PKGS[wm]-}"
  else
    echo "${PKGS[$pm:$cat]-}"
  fi
}

section "1/6 · System dependencies (WM + apps + fonts + languages/LSP)"
do_install "WM (niri/noctalia)" $(list wm)
do_install "apps" $(list apps)
do_install "fonts" $(list fonts)
do_install "languages/LSP" $(list lsp)
warn "Note: the configs expect 'Nerd Font' variants; if your package manager only ships the plain font, install the Nerd variant manually."

section "2/6 · Rust toolchain"
if install_curl_toolchain "Rust" "$RUSTUP_SITE" "$RUSTUP_INSTALL" \
     'command -v rustup &>/dev/null || [[ -f "$HOME/.cargo/env" ]]' '-s -- -y'; then
  if confirm "Install the rust-analyzer LSP (rustup component)?"; then
    if [[ -x "$HOME/.cargo/bin/rust-analyzer" ]]; then
      ok "rust-analyzer available (~/.cargo/bin, bundled with rustup)"
      INSTALLED+=("[rust] rust-analyzer")
    else
      "$HOME/.cargo/bin/rustup" component add rust-analyzer
      if [[ -x "$HOME/.cargo/bin/rust-analyzer" ]]; then
        ok "rust-analyzer installed (~/.cargo/bin)"
        INSTALLED+=("[rust] rust-analyzer")
      else
        warn "rust-analyzer not available; try: rustup component add rust-analyzer"
        SKIPPED+=("rust-analyzer (rustup component missing)")
      fi
    fi
  else
    SKIPPED+=("rust-analyzer (not chosen)")
  fi
fi

section "3/6 · Go toolchain"
if confirm "Install the Go toolchain?"; then
  case "$PM" in
    dnf)     sudo dnf install -y golang ;;
    pacman)  sudo pacman -S --needed --noconfirm go ;;
    apt|dpkg) sudo apt-get install -y golang ;;
  esac
  if command -v go &>/dev/null; then
    ok "Go toolchain installed"
    INSTALLED+=("[toolchain] Go")
    if confirm "Install the gopls LSP via go install?"; then
      GOBIN="$HOME/.local/bin" go install golang.org/x/tools/gopls@latest
      if [[ -x "$HOME/.local/bin/gopls" ]]; then
        ok "gopls installed (~/.local/bin, on PATH via .zshenv)"
        INSTALLED+=("[go] gopls")
      else
        warn "gopls failed to install"
        SKIPPED+=("gopls (go install failed)")
      fi
    else
      SKIPPED+=("gopls (not chosen)")
    fi
  else
    warn "Go toolchain failed to install"
    SKIPPED+=("go toolchain (installation failed)")
  fi
else
  SKIPPED+=("go toolchain (not chosen)")
fi

section "4/6 · Haskell toolchain"
if confirm "Install the Haskell toolchain (ghcup)?"; then
  # ghcup needs these system packages to install GHC from its binary distribution.
  case "$PM" in
    dnf)       sudo dnf install -y gcc gcc-c++ make gmp-devel ncurses-devel libffi-devel pkgconf ;;
    pacman)    sudo pacman -S --needed --noconfirm base-devel gmp ncurses libffi pkg-config ;;
    apt|dpkg)  sudo apt-get install -y build-essential libffi-dev libgmp-dev libncurses-dev pkg-config ;;
  esac
  info "site   : $GHCUP_SITE"
  info "install: curl --proto '=https' --tlsv1.2 -sSf $GHCUP_INSTALL | sh"
  curl --proto '=https' --tlsv1.2 -sSf "$GHCUP_INSTALL" \
    | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 BOOTSTRAP_HASKELL_INSTALL_HLS=1 sh
  if [[ -x "$HOME/.ghcup/bin/ghcup" ]] || command -v ghcup &>/dev/null; then
    ok "Haskell toolchain (ghcup) installed"
    INSTALLED+=("[haskell] ghcup")
    if command -v ghc &>/dev/null || [[ -x "$HOME/.ghcup/bin/ghc" ]]; then
      ok "GHC installed"
      INSTALLED+=("[haskell] ghc")
    else
      warn "ghcup is installed but GHC is not; fix with: source ~/.ghcup/env && ghcup install ghc"
      SKIPPED+=("ghc (ghcup failed to install it)")
    fi
  else
    warn "Haskell toolchain failed to install"
    SKIPPED+=("haskell toolchain (installation failed)")
  fi
else
  SKIPPED+=("haskell toolchain (not chosen)")
fi

section "5/6 · Symlinks (auto_symlink.sh)"
info "Running --dry-run first...\n"
"$SCRIPT_DIR/auto_symlink.sh" --dry-run
echo
if confirm "Apply the symlinks for real?"; then
  "$SCRIPT_DIR/auto_symlink.sh"
  INSTALLED+=("[symlink] applied")
else
  SKIPPED+=("symlinks (not applied)")
fi

section "6/6 · Wallpaper"
WALLS=()
for f in "$SCRIPT_DIR"/wallpapers/*; do
  [[ -f $f && $f =~ \.(jpg|jpeg|png|webp)$ ]] && WALLS+=("$f")
done
if [[ ${#WALLS[@]} -eq 0 ]]; then
  warn "No wallpapers found in wallpapers/"
  SKIPPED+=("wallpaper (no files in wallpapers/)")
else
  echo "Available wallpapers:"
  for i in "${!WALLS[@]}"; do
    echo "  $((i+1))) ${WALLS[$i]##*/}"
  done
  read -r -p "Pick the wallpaper number (Default: 1): " choice
  choice=${choice:-1}
  idx=$((choice-1))
  if (( idx >= 0 && idx < ${#WALLS[@]} )); then
    WALL_DIR="$HOME/.local/share/wallpapers"
    mkdir -p "$WALL_DIR"
    cp "${WALLS[$idx]}" "$WALL_DIR/wallpaper.jpg"
    ok "Wallpaper set: $WALL_DIR/wallpaper.jpg"
    info "Point swaylock (niri/noctalia) at that file."
    INSTALLED+=("[wallpaper] ${WALLS[$idx]##*/}")
  else
    warn "Invalid choice"
    SKIPPED+=("wallpaper (invalid choice)")
  fi
fi

section "Final summary"
echo -e "${GREEN}Installed / done:${NC}"
[[ ${#INSTALLED[@]} -eq 0 ]] && echo "  (none)" || printf '  - %s\n' "${INSTALLED[@]}"
echo -e "${YELLOW}Not installed:${NC}"
[[ ${#SKIPPED[@]} -eq 0 ]] && echo "  (none)" || printf '  - %s\n' "${SKIPPED[@]}"
info "If symlinks were not applied, edit the IGNORED_FILES list in auto_symlink.sh"
info "to control which files/directories get linked."
echo -e "${BOLD}${GREEN}fast_setup finished.${NC}"