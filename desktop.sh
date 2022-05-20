#!/usr/bin/env bash

set -eEuo pipefail

export OS="$(uname)"
export ROOTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# load helper functions
source ${ROOTDIR}/lib.sh

# install apt packages
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
webinstall golang@stable go &
webinstall deno@stable &
webinstall zig@stable &

wait

# rust
if ! should_update && [[ -d "${HOME}/.cargo" ]]; then
    log_info "[ok] rust already installed"
else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    log_info "[++] rust installed"
fi

# python
if [[ -d "${HOME}/.pyenv" ]]; then
    log_info "[ok] pyenv already installed"
else
    curl https://pyenv.run | bash
    log_info "[++] pyenv already installed"
fi

if should_update || ! command -v "python" >/dev/null; then
    log_info "installing python"

    eval "$(${HOME}/.pyenv/bin/pyenv init -)"
    eval "$(${HOME}/.pyenv/bin/pyenv virtualenv-init -)"

    py2_version=2.7.18
    py3_version=3.10.4

    pyenv install ${py2_version}
    pyenv install ${py3_version}
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
NEOVIM_VERSION="v0.7.0"
NEOVIM_URL="https://github.com/neovim/neovim/releases/download/${NEOVIM_VERSION}/nvim-linux64.tar.gz"
install_from_tar_gz ${NEOVIM_URL} "nvim-linux64/bin/nvim"

# install neovim plugins
nvim -es -u "${HOME}/.config/nvim/init.vim" -i NONE -c "PlugInstall" -c "qa"

# install neovim alias to vim
# (don't use a bash alias because we want vim to be picked up by programs like fzf)
safelink "${LOCALBIN}/vim" "${LOCALBIN}/nvim"

# create neovim scratch spaces
mkdir -p "${HOME}/.local/share/nvim/swp/"
mkdir -p "${HOME}/.local/share/nvim/undo/"
