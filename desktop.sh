#!/usr/bin/env bash

set -eEuo pipefail

export OS="$(uname)"
export ROOTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# load helper functions
source ${ROOTDIR}/lib.sh

# install apt packages
log_info "Updating apt packages"
sudo apt update
xargs sudo apt install -y <<EOF
    build-essential
    zlib1g-dev
    libssl-dev

    arandr
    autorandr
    feh
    neofetch
    playerctl
EOF

# install language sdks
webinstall pathman

webinstall node@lts &
webinstall go-essentials@stable go &
webinstall deno@stable &

wait

# rust
if ! should_update && [[ -d "${HOME}/.cargo" ]]; then
    log_info "[ok] rust already installed"
else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    log_info "[++] rust installed"
fi

# python
if [[ ! -d "${HOME}/.pyenv" ]]; then
    curl https://pyenv.run | bash
    eval "$(${HOME}/.pyenv/bin/pyenv init -)"
    git clone https://github.com/pyenv/pyenv-update.git $(pyenv root)/plugins/pyenv-update
    log_info "[++] pyenv installed"
elif should_update; then
    pyenv update
else
    log_info "[ok] pyenv already installed"
fi

if should_update || ! command -v "python" >/dev/null; then
    log_info "installing python"

    eval "$(${HOME}/.pyenv/bin/pyenv init -)"

    py2_version=2.7.18
    py3_version=3.11.5

    pyenv install -s ${py2_version}
    pyenv install -s ${py3_version}
    pyenv global ${py3_version} ${py2_version}

    pip install --upgrade pip
    pip2 install --upgrade pip

    log_info "[++] python installed"
else
    log_info "[ok] python already installed"
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
NEOVIM_VERSION="v0.9.1"
NEOVIM_URL="https://github.com/neovim/neovim/releases/download/${NEOVIM_VERSION}/nvim-linux64.tar.gz"
install_from_tar_gz ${NEOVIM_URL} "nvim-linux64/bin/nvim"

# install neovim plugins
nvim -es -u "${HOME}/.config/nvim/init.vim" -i NONE -c "PlugUpgrade" -c "PlugInstall" -c "PlugUpdate" -c "qa" && log_info "updated nvim plugins"

# install neovim alias to vim
# (don't use a bash alias because we want vim to be picked up by programs like fzf)
safelink "${LOCALBIN}/vim" "${LOCALBIN}/nvim"

# create neovim scratch spaces
mkdir -p "${HOME}/.local/share/nvim/swp/"
mkdir -p "${HOME}/.local/share/nvim/undo/"
