# mise owns the CLI tools this repo installs; see config/mise/config.toml.
#
# Position matters both ways. It has to run after 2-path.zsh, because the mise
# binary lives in ~/.local/bin, and before 4-fzf.zsh, which calls fzf while the
# shell is still starting. Activating here rather than alongside the zinit
# plugins further down in zshrc is what buys that second half.
if (( $+commands[mise] )); then
  eval "$(mise activate zsh)"

  # Leave the completion where compinit -- which zshrc runs after this file --
  # already looks, and generate it only once so startup stays fast.
  if [[ -n "$ZSH_CACHE_DIR" && ! -f "$ZSH_CACHE_DIR/completions/_mise" ]]; then
    mkdir -p "$ZSH_CACHE_DIR/completions"
    mise completion zsh >"$ZSH_CACHE_DIR/completions/_mise"
  fi
fi
