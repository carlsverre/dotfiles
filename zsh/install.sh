#!/usr/bin/env bash

set -eEuo pipefail

ZSH="${HOME}/.oh-my-zsh"
ZSH_CUSTOM="${HOME}/.config/zsh-custom"

echo "Installing oh-my-zsh"
if [ -d "${ZSH}" ]; then
    echo "oh-my-zsh is already installed"
else
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ln -sfn ${DOTFILES_LOCATION}/zsh/zshrc ${HOME}/.zshrc
ln -sfn ${DOTFILES_LOCATION}/zsh/custom ${ZSH_CUSTOM}