#!/usr/bin/env bash
# install.sh  -  Sapi Installer for Linux / macOS
#
# Usage:
#   bash install.sh
#
# What it does:
#   1. Installs sapi  ->  ~/.local/bin/sapi  (added to PATH in .bashrc/.zshrc)

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
GRAY='\033[0;90m'
BOLD='\033[1m'
RESET='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_SRC="$SCRIPT_DIR/sapi"
SAPI_BIN_DIR="$HOME/.local/bin"

echo ""
echo -e "  ${CYAN}${BOLD}Sapi - Linux Installer${RESET}"
echo -e "  ${GRAY}-----------------------${RESET}"
echo ""

if [ ! -f "$BIN_SRC" ]; then
    echo -e "  ${RED}[ERROR] sapi binary not found in this folder.${RESET}"
    exit 1
fi

echo -e "  Installing sapi  ->  $SAPI_BIN_DIR"
mkdir -p "$SAPI_BIN_DIR"
cp -f "$BIN_SRC" "$SAPI_BIN_DIR/sapi"
chmod +x "$SAPI_BIN_DIR/sapi"

PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'
added=0
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$rc" ] && ! grep -q '.local/bin' "$rc"; then
        echo "" >> "$rc"
        echo "# Added by Sapi installer" >> "$rc"
        echo "$PATH_LINE" >> "$rc"
        echo -e "  Added to PATH in $(basename $rc)"
        added=1
    fi
done
if [ $added -eq 0 ]; then
    echo -e "  ${GRAY}~/.local/bin already in PATH${RESET}"
else
    echo -e "  ${YELLOW}Run: source ~/.bashrc  (or open a new terminal)${RESET}"
fi

echo ""
echo -e "  ${GREEN}Done!  Run: sapi new my-project${RESET}"
echo ""
