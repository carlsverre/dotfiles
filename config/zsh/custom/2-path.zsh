# Keep PATH free of duplicates. zsh ties the `path` array to the `PATH` string,
# and -U keeps only the first occurrence of each entry -- so the prepends below
# still win, they just stop stacking up a second copy of a directory that is
# already there. It holds for the life of the shell, so it also dedupes entries
# added after this file runs (~/.cargo/env, mise, ~/.localrc, ~/.zshenv).
typeset -U path PATH

export PATH="/snap/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/localbin:$PATH"
