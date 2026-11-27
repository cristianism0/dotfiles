#!/usr/bin/env bash
#
# Remove o tema Love do SDDM.
#
set -euo pipefail

THEME_NAME="love"
DEST_DIR="/usr/share/sddm/themes/${THEME_NAME}"
CONF_FILE="/etc/sddm.conf.d/zz-${THEME_NAME}.conf"

if [[ ${EUID} -ne 0 ]]; then
    echo "Este script precisa de root. Executando com sudo..."
    exec sudo -- "$0" "$@"
fi

rm -rf "${DEST_DIR:?}"
rm -f "${CONF_FILE}"

echo "Tema removido. O SDDM voltará ao tema padrão no próximo logout/reboot."
