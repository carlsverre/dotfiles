#!/usr/bin/env bash

set -eEuo pipefail

export ROOTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# load helper functions
source ${ROOTDIR}/lib.sh

webinstall pathman
webinstall go

webinstall go-essentials@stable &
webinstall node@lts &

wait

# rust
if ! should_update && [[ -d "${HOME}/.cargo" ]]; then
    log_info "[ok] rust already installed"
elif command -v rustup >/dev/null; then
    rustup update
    log_info "[++] rust updated"
else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    log_info "[++] rust installed"
fi

# install plug.vim
PLUG_VIM_PATH="${HOME}/.local/share/nvim/site/autoload/plug.vim"
PLUG_VIM_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
if [[ -f "${PLUG_VIM_PATH}" ]]; then
    log_info "[ok] plug.vim already installed"
else
    curl -sfLo "${PLUG_VIM_PATH}" --create-dirs "${PLUG_VIM_URL}"
    log_info "[++] plug.vim installed"
fi

# install neovim
# NEOVIM_VERSION="v0.9.1"
# NEOVIM_URL="https://github.com/neovim/neovim/releases/download/${NEOVIM_VERSION}/nvim-linux64.tar.gz"
# install_from_tar_gz ${NEOVIM_URL} "nvim-linux64/bin/nvim"

# install neovim plugins
nvim -es -u "${HOME}/.config/nvim/init.vim" -i NONE -c "PlugUpgrade" -c "PlugInstall" -c "PlugUpdate" -c "qa" && log_info "updated nvim plugins"

# install neovim alias to vim
# (don't use a bash alias because we want vim to be picked up by programs like fzf)
safelink "${LOCALBIN}/vim" $(which nvim)

# create neovim scratch spaces
mkdir -p "${HOME}/.local/share/nvim/swp/"
mkdir -p "${HOME}/.local/share/nvim/undo/"
