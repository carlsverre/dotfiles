# fe [query] - Open fzf, initialized with query
#   - Bypasses fzf if there is one match
fe() {
  local target
  target=$(fzf --query="$1" --select-1)
  [ -n "$target" ] && ${EDITOR:-code} "$target"
}