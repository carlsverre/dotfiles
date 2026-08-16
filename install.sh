#!/usr/bin/env bash
#
# install.sh -- link this repo into the homedir and install the tools it wants.
#
#   ./install.sh            link everything, install whatever is missing
#   ./install.sh --update   the same, plus upgrade mise, the tools and the
#                           neovim plugins, then delete the tool versions
#                           nothing points at any more
#
# Every step is idempotent, so running this twice is the normal case and the
# second run should print nothing but [ok] lines.

set -eEuo pipefail

ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${ROOTDIR}/lib/link.sh"
source "${ROOTDIR}/lib/mise.sh"
source "${ROOTDIR}/lib/git.sh"
source "${ROOTDIR}/lib/neovim.sh"

update=false
case "${1-}" in
    "")          ;;
    -u|--update) update=true ;;
    -h|--help)   sed -n '3,11p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)           echo "usage: $0 [--update]" >&2; exit 1 ;;
esac

echo "==> links"

safelink "${HOME}/bin"        "${ROOTDIR}/bin"
safelink "${HOME}/.zshrc"     "${ROOTDIR}/config/zsh/zshrc"
safelink "${HOME}/.tmux.conf" "${ROOTDIR}/config/tmux.conf"
safelink "${HOME}/.dircolors" "${ROOTDIR}/config/dircolors"

safelink_children "${ROOTDIR}/config" "${HOME}/.config"

if [[ "$(uname -s)" != "Darwin" ]]; then
    safelink "${HOME}/.Xresources" "${ROOTDIR}/config/xresources"
    safelink "${HOME}/.xsessionrc" "${ROOTDIR}/config/xsessionrc"
    safelink "${HOME}/.wallpapers" "${ROOTDIR}/wallpapers"
fi

echo "==> git"

git_include "${ROOTDIR}/config/gitconfig"
git_include ".gitconfig.local"

echo "==> tools"

# mise resolves nearly every tool through the GitHub API, where an anonymous
# caller gets 60 requests an hour and a token gets 5000. A token already in the
# environment wins; otherwise borrow gh's for the length of this run. On a
# machine with neither, this falls through to anonymous and the first install
# still fits in 60.
if [[ -z "${GITHUB_API_TOKEN:-}" && -z "${GITHUB_TOKEN:-}" ]] &&
    command -v gh >/dev/null && gh auth status >/dev/null 2>&1; then
    export GITHUB_API_TOKEN="$(gh auth token)"
fi

install_mise

# Nothing here is on PATH yet on a fresh machine: ~/.local/bin holds the mise
# binary itself, and the shims directory is how the rest of this script reaches
# neovim and node without an interactive shell to activate mise for it. Shims
# come first so a mise-managed tool wins over an older copy in ~/.local/bin.
export PATH="${HOME}/.local/share/mise/shims:${HOME}/.local/bin:${PATH}"

if ${update}; then
    mise self-update --yes

    # Re-resolve the "latest" and "lts" selectors in the config and move the
    # already-installed tools up to whatever they point at now.
    mise upgrade --yes
fi

# Reads ~/.config/mise/config.toml -- the copy linked from this repo above --
# and installs whatever it asks for that is missing. Tools already installed are
# left where they are, so a plain run does not move anything.
mise install --yes

if ${update}; then
    mise prune --yes --tools
fi

# Normally automatic after an install, but the neovim step below depends on the
# shims existing, so make it explicit rather than a race we lose once a year.
mise reshim

echo "==> neovim"

# Link the shim rather than the binary: a link into ~/.local/share/mise/installs
# would break the next time neovim is upgraded. $EDITOR is vim and programs
# like fzf exec it directly, so the zsh alias is not enough on its own.
safelink "${HOME}/.local/bin/vim" "${HOME}/.local/share/mise/shims/nvim"

mkdir -p "${HOME}/.local/share/nvim/swp" "${HOME}/.local/share/nvim/undo"

install_vim_plug

if ${update}; then
    nvim_headless PlugUpgrade PlugUpdate CocUpdateSync
else
    nvim_headless PlugInstall CocUpdateSync
fi

echo "==> python"

# uv owns the interpreters, not mise. --default is what puts python and python3
# in ~/.local/bin, ahead of homebrew's on PATH, so a fresh machine has a python
# without one. Everything else uv manages lives in ~/.local/share/uv.
#
# The minor version is spelled out because uv has no way to ask for "the latest
# stable": every looser request -- no argument at all, "3", ">=3.14" -- is
# considered satisfied by any managed python already installed, so on this
# machine they would all quietly settle for the oldest one lying around. Bump
# the line by hand; --update only moves the patch version.
#
# --default is still behind a preview flag, and naming the feature is how you
# opt in without uv warning about it on every run. Drop the flag once uv
# stabilises it.
uv python install --default --preview-features python-install-default 3.14

if ${update}; then
    uv python upgrade
fi

echo "==> done"
