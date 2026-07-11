#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DOTFILES_DIR/libs/helper.sh"
check_dependencies

LINKS_FILE="$DOTFILES_DIR/links.ini"

while read -r name; do
  dst="$(get_field "$name" dst "$LINKS_FILE")"
  target="$HOME/$dst"
  if [ -L "$target" ]; then
    echo "OK   (symlink): $target -> $(readlink "$target")"
  elif [ -e "$target" ]; then
    echo "WARN (real file, not linked): $target"
  else
    echo "MISSING: $target"
  fi
done < <(list_sections "$LINKS_FILE")
