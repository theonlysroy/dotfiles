#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DOTFILES_DIR/libs/helper.sh"
check_dependencies

LINKS_FILE="$DOTFILES_DIR/links.ini"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link_one() {
  local src="$DOTFILES_DIR/$1" dst="$HOME/$2"
  [ ! -e "$src" ] && { echo "skip: source missing -> $src"; return; }

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mkdir -p "$BACKUP_DIR/$(dirname "$2")"
    mv "$dst" "$BACKUP_DIR/$2"
    echo "backed up existing $dst -> $BACKUP_DIR/$2"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
  echo "linked $dst -> $src"
}

while read -r name; do
  src="$(get_field "$name" src "$LINKS_FILE")"
  dst="$(get_field "$name" dst "$LINKS_FILE")"
  link_one "$src" "$dst"
done < <(list_sections "$LINKS_FILE")

echo "Done. Backups (if any) are in $BACKUP_DIR"
