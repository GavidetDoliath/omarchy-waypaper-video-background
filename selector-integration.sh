#!/usr/bin/env bash

set -euo pipefail

readonly menu_file="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/extensions/omarchy-menu.jsonc"
readonly begin_marker="// BEGIN Waypaper Video background selector"
readonly end_marker="// END Waypaper Video background selector"
readonly override_key='"style.background"'

fail() {
  local exit_code="$1"
  shift
  printf 'waypaper-video-integration: %s\n' "$*" >&2
  exit "$exit_code"
}

refresh_menu() {
  [[ ${WAYPAPER_VIDEO_SKIP_MENU_REFRESH:-0} == "1" ]] && return
  if command -v omarchy >/dev/null 2>&1; then
    omarchy menu refresh >/dev/null 2>&1 || true
  fi
}

backup_menu() {
  local timestamp backup
  timestamp="$(date +%Y%m%d-%H%M%S-%N)"
  backup="$menu_file.bak.waypaper-video.$timestamp"
  cp -p -- "$menu_file" "$backup"
  printf '%s\n' "$backup"
}

install_integration() {
  local menu_dir backup temporary block current_block

  menu_dir="${menu_file%/*}"
  mkdir -p -- "$menu_dir"
  if [[ ! -e $menu_file ]]; then
    printf '{\n}\n' >"$menu_file"
  fi
  [[ -f $menu_file && -r $menu_file && -w $menu_file ]] || \
    fail 73 "menu extension is not a writable file: $menu_file"

  block='  // BEGIN Waypaper Video background selector
  "style.background": {"icon":"","label":"Background","aliases":["background","wallpaper"],"action":"$HOME/.config/omarchy/plugins/io.github.gavidetdoliath.waypaper-video-background/background-selector.sh"},
  // END Waypaper Video background selector'

  if grep -Fq "$begin_marker" "$menu_file"; then
    grep -Fq "$end_marker" "$menu_file" || \
      fail 65 "managed selector block is missing its end marker"
    current_block="$(awk -v begin="$begin_marker" -v end="$end_marker" '
      index($0, begin) { capture = 1 }
      capture { print }
      capture && index($0, end) { exit }
    ' "$menu_file")"
    if [[ $current_block == "$block" ]]; then
      printf 'Waypaper Video background selector is already integrated.\n'
      exit 0
    fi

    backup="$(backup_menu)"
    temporary="$(mktemp "$menu_file.tmp.XXXXXX")"
    if ! awk -v begin="$begin_marker" -v end="$end_marker" -v block="$block" '
      index($0, begin) {
        if (!replaced) print block
        replaced = 1
        replacing = 1
        next
      }
      replacing && index($0, end) { replacing = 0; next }
      !replacing { print }
      END { if (!replaced) exit 1 }
    ' "$menu_file" >"$temporary"; then
      rm -f -- "$temporary"
      fail 65 "could not update the managed selector block"
    fi

    chmod --reference="$menu_file" "$temporary"
    mv -f -- "$temporary" "$menu_file"
    refresh_menu
    printf 'Updated the Waypaper Video background selector integration.\n'
    printf 'Backup: %s\n' "$backup"
    exit 0
  fi
  if grep -Eq "^[[:space:]]*$override_key[[:space:]]*:" "$menu_file"; then
    fail 65 "style.background already has a user override; refusing to replace it"
  fi

  backup="$(backup_menu)"
  temporary="$(mktemp "$menu_file.tmp.XXXXXX")"

  if ! awk -v block="$block" '
    { print }
    !inserted && /^[[:space:]]*\{[[:space:]]*$/ { print block; inserted = 1 }
    END { if (!inserted) exit 1 }
  ' "$menu_file" >"$temporary"; then
    rm -f -- "$temporary"
    fail 65 "menu extension is not a top-level JSONC object"
  fi

  chmod --reference="$menu_file" "$temporary"
  mv -f -- "$temporary" "$menu_file"
  refresh_menu
  printf 'Integrated Waypaper Video into the Omarchy background selector.\n'
  printf 'Backup: %s\n' "$backup"
}

remove_integration() {
  local backup temporary

  [[ -f $menu_file ]] || {
    printf 'Waypaper Video background selector is not integrated.\n'
    exit 0
  }
  if ! grep -Fq "$begin_marker" "$menu_file"; then
    printf 'Waypaper Video background selector is not integrated.\n'
    exit 0
  fi

  backup="$(backup_menu)"
  temporary="$(mktemp "$menu_file.tmp.XXXXXX")"
  awk -v begin="$begin_marker" -v end="$end_marker" '
    index($0, begin) { removing = 1; next }
    index($0, end) { removing = 0; next }
    !removing { print }
  ' "$menu_file" >"$temporary"
  chmod --reference="$menu_file" "$temporary"
  mv -f -- "$temporary" "$menu_file"
  refresh_menu
  printf 'Restored the stock Omarchy background selector action.\n'
  printf 'Backup: %s\n' "$backup"
}

show_status() {
  if [[ -f $menu_file ]] && grep -Fq "$begin_marker" "$menu_file"; then
    printf 'integrated\n'
  else
    printf 'not-integrated\n'
  fi
}

case "${1:-status}" in
  install) install_integration ;;
  remove) remove_integration ;;
  status) show_status ;;
  *) fail 64 "usage: ${0##*/} [install|remove|status]" ;;
esac
