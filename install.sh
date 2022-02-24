#!/usr/bin/env bash

set -eEuo pipefail

export DOTFILES_LOCATION="$(pwd)"

export LOCALBIN="$HOME/localbin"
mkdir -p "${LOCALBIN}"

mkdir -p "${HOME}/.config"

ln -sfn "${DOTFILES_LOCATION}/bin" "${HOME}/bin"

${DOTFILES_LOCATION}/zsh/install.sh

RIPGREP_VERSION=13.0.0
RIPGREP_URL=https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep-${RIPGREP_VERSION}-x86_64-unknown-linux-musl.tar.gz
if [ -f "${LOCALBIN}/rg" ]; then
    echo "ripgrep is already installed"
else
    curl -fsSL "${RIPGREP_URL}" | tar -xzf - -C "${LOCALBIN}" --strip-components=1 ripgrep-${RIPGREP_VERSION}-x86_64-unknown-linux-musl/rg
fi