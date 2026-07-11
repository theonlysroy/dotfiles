#!/usr/bin/env bash

check_dependencies() {
  local missing=()
  for cmd in awk grep; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
  done
  if [ "${#missing[@]}" -ne 0 ]; then
    echo "Error: required command(s) not found: ${missing[*]}" >&2
    echo "Install manually first, e.g.: sudo apt install -y ${missing[*]}" >&2
    exit 1
  fi
}

# get_field <section> <key> <file>
get_field() {
  local section="$1" key="$2" file="$3"
  awk -v section="[$section]" -v key="$key" '
    $0 == section { found=1; next }
    /^\[/ { found=0 }
    found && index($0, key"=") == 1 { sub("^"key"=", ""); print; exit }
  ' "$file"
}

# list_sections <file>
list_sections() {
  grep -oP '^\[\K[^\]]+' "$1"
}
