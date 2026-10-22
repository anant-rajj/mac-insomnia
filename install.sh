#!/usr/bin/env bash
# mac-insomnia installer
set -e

INSTALL_DIR="${HOME}/.local/bin"
mkdir -p "${INSTALL_DIR}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "${SCRIPT_DIR}/mac-insomnia" "${INSTALL_DIR}/mac-insomnia"
chmod +x "${INSTALL_DIR}/mac-insomnia"

echo "[✓] Installed mac-insomnia to ${INSTALL_DIR}/mac-insomnia"

# Ensure ~/.local/bin is in PATH
if [[ ":$PATH:" != *":${INSTALL_DIR}:"* ]]; then
  echo "[!] Warning: ${INSTALL_DIR} is not currently in your PATH."
  echo "    Add 'export PATH=\"${INSTALL_DIR}:\$PATH\"' to your ~/.zshrc or ~/.bash_profile."
fi

echo ""
echo "To enable passwordless toggling for sleep settings, run:"
echo "  mac-insomnia sudoers"
echo ""
echo "Ready to use! Try: mac-insomnia status"
