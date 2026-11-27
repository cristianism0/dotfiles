#!/usr/bin/env bash
#
# Instala o tema Love no SDDM.
#
set -euo pipefail

THEME_NAME="love"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="/usr/share/sddm/themes/${THEME_NAME}"
CONF_DIR="/etc/sddm.conf.d"
CONF_FILE="${CONF_DIR}/zz-${THEME_NAME}.conf"

if [[ ${EUID} -ne 0 ]]; then
    echo "Este script precisa de root. Executando com sudo..."
    exec sudo -- "$0" "$@"
fi

if [[ ! -f "${SRC_DIR}/Main.qml" ]]; then
    echo "Main.qml não encontrado em ${SRC_DIR}" >&2
    exit 1
fi

echo "Instalando tema em ${DEST_DIR}..."
install -d -m 0755 "${DEST_DIR}" "${CONF_DIR}"

rm -rf \
    "${DEST_DIR}/Main.qml" \
    "${DEST_DIR}/theme.conf" \
    "${DEST_DIR}/metadata.desktop" \
    "${DEST_DIR}/components" \
    "${DEST_DIR}/assets"
cp -a \
    "${SRC_DIR}/Main.qml" \
    "${SRC_DIR}/theme.conf" \
    "${SRC_DIR}/metadata.desktop" \
    "${SRC_DIR}/components" \
    "${SRC_DIR}/assets" \
    "${DEST_DIR}/"

chmod -R a+rX "${DEST_DIR}"

if command -v restorecon >/dev/null 2>&1; then
    restorecon -R "${DEST_DIR}" || true
fi

cat > "${CONF_FILE}" <<EOF
[Theme]
Current=${THEME_NAME}
EOF

echo
echo "Tema instalado e ativado."
echo "O SDDM usará o tema no próximo logout/reboot."
echo
echo "Para testar agora (na sessão atual):"
echo "  sddm-greeter-qt6 --test-mode --theme ${DEST_DIR}"
