#!/usr/bin/env bash
#
# Abre o greeter do SDDM em modo de teste, usando este diretório.
# Pressione Ctrl+C no terminal para fechar.
#
set -euo pipefail

THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -z "${DISPLAY:-}" && -z "${WAYLAND_DISPLAY:-}" ]]; then
    echo "Nenhum display gráfico encontrado (DISPLAY/WAYLAND_DISPLAY vazios)." >&2
    exit 1
fi

# O greeter real do Fedora roda em X11. Se houver XWayland disponível,
# prefira xcb também no teste (assim o seletor de teclado aparece).
if [[ -n "${DISPLAY:-}" && -z "${QT_QPA_PLATFORM:-}" ]]; then
    export QT_QPA_PLATFORM=xcb
fi

exec sddm-greeter-qt6 --test-mode --theme "${THEME_DIR}"
