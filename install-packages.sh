#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DOTFILES_DIR/libs/helper.sh"
check_dependencies

PKG_FILE="$DOTFILES_DIR/packages.ini"

install_apt() {
  local name="$1"
  dpkg -s "$name" &>/dev/null && { echo "apt: $name already installed"; return; }
  sudo apt install -y "$name"
}

install_apt_repo() {
  local name="$1" key_url="$2" key_path="$3" repo_line="$4" list_path="$5"

  dpkg -s "$name" &>/dev/null && { echo "apt-repo: $name already installed"; return; }

  if [ ! -f "$key_path" ]; then
    echo "adding gpg key for $name..."
    curl -fsSL "$key_url" | sudo gpg --yes --dearmor -o "$key_path"
    sudo chmod 644 "$key_path"
  fi

  if [ ! -f "$list_path" ]; then
    echo "adding apt repo for $name..."
    echo "$repo_line" | sudo tee "$list_path" > /dev/null
  fi

  sudo apt update
  sudo apt install -y "$name"
}

install_snap() {
  local name="$1" flags="$2"
  snap list "$name" &>/dev/null && { echo "snap: $name already installed"; return; }
  sudo snap install "$name" $flags
}

install_deb_url() {
  local name="$1" url="$2"
  dpkg -s "$name" &>/dev/null && { echo "deb: $name already installed"; return; }
  local tmp; tmp="$(mktemp --suffix=.deb)"
  echo "downloading $name..."
  curl -fsSL "$url" -o "$tmp"
  sudo apt install -y "$tmp"
  rm -f "$tmp"
}

install_appimage() {
  local name="$1" url="$2"
  local dest="$HOME/.local/bin/appimages/$name.AppImage"
  mkdir -p "$(dirname "$dest")"
  [ -f "$dest" ] && { echo "appimage: $name already downloaded"; return; }
  echo "downloading $name..."
  curl -fsSL "$url" -o "$dest"
  chmod +x "$dest"
  echo "installed appimage -> $dest"
}

install_shell_script() {
  local name="$1" url="$2" check_bin="$3"

  if [ -n "$check_bin" ] && command -v "$check_bin" >/dev/null 2>&1; then
    echo "shell-script: $name already installed ($check_bin found)"
    return
  fi

  echo "running install script for $name from $url..."
  echo "  -> this pipes a remote script to sh; review it if you don't trust the source"
  curl -fsSL "$url" | sh
}

while read -r name; do
  type="$(get_field "$name" type "$PKG_FILE")"
  source_val="$(get_field "$name" source "$PKG_FILE")"
  flags="$(get_field "$name" flags "$PKG_FILE")"

  case "$type" in
    apt)
        install_apt "$name"
        ;;
    apt-repo)
      key_url="$(get_field "$name" key_url "$PKG_FILE")"
      key_path="$(get_field "$name" key_path "$PKG_FILE")"
      repo_line="$(get_field "$name" repo_line "$PKG_FILE")"
      list_path="$(get_field "$name" list_path "$PKG_FILE")"
      install_apt_repo "$name" "$key_url" "$key_path" "$repo_line" "$list_path"
      ;;
    snap)
        install_snap "$name" "$flags"
        ;;
    deb-url)
    install_deb_url "$name" "$source_val"
    ;;
    appimage)
        install_appimage "$name" "$source_val"
        ;;
    shell-script)
        install_url="$(get_field "$name" install_url "$PKG_FILE")"
        check_bin="$(get_field "$name" check_bin "$PKG_FILE")"
        install_shell_script "$name" "$install_url" "$check_bin"
       ;;
    *)
        echo "unknown type '$type' for [$name]"
        ;;
  esac
done < <(list_sections "$PKG_FILE")

echo "Package install pass complete."
