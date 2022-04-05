#!/usr/bin/env bash

set -eEuo pipefail

ZSH_HOME="${HOME}/.config/zsh"

ln -sfn ${DOTFILES_LOCATION}/zsh/zshrc ${HOME}/.zshrc
ln -sfn ${DOTFILES_LOCATION}/zsh/zimrc ${HOME}/.zimrc
ln -sfn ${DOTFILES_LOCATION}/zsh ${ZSH_HOME}