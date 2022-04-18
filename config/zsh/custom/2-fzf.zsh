# fe [query] - Open fzf, initialized with query
#   - Bypasses fzf if there is one match
fe() {
  local target=$(fzf --query="$1" --select-1)
  local editor="${EDITOR:-nvim}"
  if ! command -v "${editor}" >/dev/null; then
    editor=code
  fi
  [ -n "${target}" ] && ${editor} "${target}"
}