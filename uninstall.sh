#!/usr/bin/env bash
# mac-insomnia uninstaller
set -e

# Restore normal sleep first if active
if command -v mac-insomnia >/dev/null 2>&1; then
  mac-insomnia stop 2>/dev/null || true
fi

rm -f "${HOME}/.local/bin/mac-insomnia"
rm -rf "${HOME}/.cache/mac-insomnia"

if [ -f /etc/sudoers.d/mac-insomnia ]; then
  echo "Found /etc/sudoers.d/mac-insomnia. To remove it, run:"
  echo "  sudo rm -f /etc/sudoers.d/mac-insomnia"
fi

echo "[✓] mac-insomnia has been uninstalled."
