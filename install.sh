#!/usr/bin/env bash

set -eEuo pipefail

export OS="$(uname)"
export ROOTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# load helper functions
source ${ROOTDIR}/lib.sh

# create localbin
mkdir -p "${LOCALBIN}"

# setup simple links
safelink "${HOME}/bin" "${ROOTDIR}/bin"

# link .config dirs
for x in ${ROOTDIR}/config/*; do
    if [[ -d "${x}" ]]; then
        safelink "${HOME}/.config/$(basename ${x})" "${x}"
    fi
done

# install dotfiles
safelink "${HOME}/.Xresources" "${ROOTDIR}/config/xresources"
safelink "${HOME}/.xsessionrc" "${ROOTDIR}/config/xsessionrc"
safelink "${HOME}/.zshrc" "${ROOTDIR}/config/zsh/zshrc"

# install tools
source tools.sh

# setup gitconfig
source ${ROOTDIR}/gitconfig.sh

# install wallpapers
safelink "${HOME}/.wallpapers" "${ROOTDIR}/wallpapers"