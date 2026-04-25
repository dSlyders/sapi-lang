#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BIN_SRC="$SCRIPT_DIR/sapi"

if [ ! -f "$BIN_SRC" ]; then
  echo "Error: ARM binary not found next to installer script."
  echo "Expected: $BIN_SRC"
  exit 1
fi

INSTALL_DIR="${SAPI_INSTALL_DIR:-$HOME/.local/bin}"
TARGET="$INSTALL_DIR/sapi"

mkdir -p "$INSTALL_DIR"
cp "$BIN_SRC" "$TARGET"
chmod +x "$TARGET"

echo "Installed: $TARGET (ARM package)"

echo ""
echo "Installing prerequisites for SAPI projects (Rust, Cargo, targets, tools)..."
if [ "${SAPI_SKIP_PREREQS:-0}" = "1" ]; then
  echo "Prerequisites install skipped (SAPI_SKIP_PREREQS=1)."
else
  "$TARGET" install prerequisites
fi

case ":${PATH}:" in
  *":$INSTALL_DIR:"*)
    echo "PATH already contains $INSTALL_DIR"
    ;;
  *)
    SHELL_NAME=$(basename "${SHELL:-sh}")
    if [ "$SHELL_NAME" = "zsh" ]; then
      PROFILE="$HOME/.zshrc"
    else
      PROFILE="$HOME/.bashrc"
    fi

    echo ""
    echo "Add this line to your profile if needed:"
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
    echo "Profile suggested: $PROFILE"
    ;;
esac

echo ""
echo "Verification:"
echo "  sapi -V"
echo "  sapi install prerequisites"
