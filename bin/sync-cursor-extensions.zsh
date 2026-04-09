#!/usr/bin/env zsh
# Sync Cursor extensions with cursor/extensions.txt in this repo.
# Approach: https://dev.to/0916dhkim/sync-cursor-settings-the-dotfiles-way-20c9
# Compare ~/.cursor/extensions/extensions.json mtime vs the list file; newer side wins.

emulate -L zsh

DOTFILES=$(readlink -f $0 | xargs dirname | xargs dirname)
LIST="$DOTFILES/cursor/extensions.txt"
EXT_JSON="$HOME/.cursor/extensions/extensions.json"

cursor_bin=$(command -v cursor) || {
  echo "cursor: command not found; install Cursor CLI or add it to PATH." >&2
  exit 1
}

# Cursor is Electron/Node; suppress punycode and other deprecation noise on stderr.
# Also keep only publisher.extension lines so any stray stdout is ignored.
list_installed_ids() {
  env NODE_NO_WARNINGS=1 "$cursor_bin" --list-extensions 2>/dev/null \
    | grep -E '^[[:alnum:]][[:alnum:]._-]*\.[[:alnum:]][[:alnum:]._-]*$' \
    | sort -u
}

mtime() {
  local f=$1
  [[ -f $f ]] || { echo 0; return }
  stat -f %m "$f" 2>/dev/null || stat -c %Y "$f" 2>/dev/null || echo 0
}

list_nonempty() {
  [[ -f $LIST ]] && grep -q '[^[:space:]]' "$LIST" 2>/dev/null
}

push_list() {
  mkdir -p "${LIST:h}"
  list_installed_ids >"$LIST"
  local n=$(wc -l <"$LIST" | tr -d ' ')
  echo "Wrote ${n} extension id(s) to ${LIST#$DOTFILES/}"
}

pull_list() {
  typeset -A want have
  local line id

  while IFS= read -r line || [[ -n $line ]]; do
    [[ -z "${line//[[:space:]]/}" ]] && continue
    want[$line]=1
  done <"$LIST"

  while IFS= read -r line; do
    [[ -z "${line//[[:space:]]/}" ]] && continue
    have[$line]=1
  done < <(list_installed_ids)

  typeset -a to_install to_uninstall
  for id in ${(k)want}; do
    [[ -z ${have[$id]} ]] && to_install+=("$id")
  done
  for id in ${(k)have}; do
    [[ -z ${want[$id]} ]] && to_uninstall+=("$id")
  done

  if (( ${#to_install} )); then
    local -a install_args
    for id in $to_install; do
      install_args+=(--install-extension "$id")
    done
    env NODE_NO_WARNINGS=1 "$cursor_bin" "${install_args[@]}"
  fi
  # Uninstall one at a time; batch uninstall can be buggy in Cursor.
  for id in $to_uninstall; do
    env NODE_NO_WARNINGS=1 "$cursor_bin" --uninstall-extension "$id"
  done

  if (( ${#to_install} == 0 && ${#to_uninstall} == 0 )); then
    echo "Cursor extensions already match the list."
  else
    echo "Installed ${#to_install}, uninstalled ${#to_uninstall}."
  fi
}

if ! list_nonempty; then
  echo "List missing or empty; exporting installed extensions to the repo list."
  push_list
  exit 0
fi

ext_ts=$(mtime "$EXT_JSON")
list_ts=$(mtime "$LIST")

if (( ext_ts > list_ts )); then
  echo "Local extensions metadata is newer than the list; updating cursor/extensions.txt."
  push_list
else
  echo "List is newer than (or same as) local metadata; syncing extensions from list."
  pull_list
fi
