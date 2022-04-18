#!/usr/bin/env bash

set -eEuo pipefail

export OS="$(uname)"
export ROOTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export LOCALBIN="$HOME/.local/bin"

# load helper functions
source ${ROOTDIR}/lib.sh