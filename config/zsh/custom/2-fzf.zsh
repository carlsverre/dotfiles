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

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# set the following keybindings to use fzf
# ctrl-t: search files and directories
# ctrl-r: search command history
# alt-c: cd into the selected directory
#
# **TAB: triggers smart search
#   default: files and directories
#   kill: processes
#   ssh: hostnames
#   unset/export/unalias: env variables
#
source <(fzf --zsh)
