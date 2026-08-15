# Bootstrapping mise, which installs everything else.

# install_mise -- put the mise binary in ~/.local/bin if it is not there yet.
#
# This is the one tool that cannot come from mise, and the only thing install.sh
# runs off the internet. The installer honours MISE_INSTALL_PATH, so we choose
# the destination rather than letting it guess from PATH.
install_mise() {
    local dest="${HOME}/.local/bin/mise"

    if [[ -x "$dest" ]]; then
        echo "[ok] mise already installed"
        return 0
    fi

    mkdir -p "$(dirname "$dest")"
    curl -fsSL https://mise.run | MISE_INSTALL_PATH="$dest" sh
    echo "[++] mise installed"
}
