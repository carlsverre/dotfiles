# Neovim's out-of-band setup: the plugin manager, and driving it.

# install_vim_plug -- fetch the plugin manager that config/nvim/init.vim
# sources on startup. Every other plugin is vim-plug's problem after this.
install_vim_plug() {
    local dest="${HOME}/.local/share/nvim/site/autoload/plug.vim"
    local url="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

    if [[ -f "$dest" ]]; then
        echo "[ok] plug.vim already installed"
        return 0
    fi

    curl -fsSL --create-dirs -o "$dest" "$url"
    echo "[++] plug.vim installed"
}

# nvim_headless -- run ex commands in a throwaway neovim, then quit.
#
#   nvim_headless PlugInstall CocUpdateSync
#
# -es is silent ex mode, so nothing draws and nothing waits for a keypress, and
# -i NONE keeps the shada file out of it: a plugin sync should not rewrite your
# jumplist. A plugin that fails to update is worth saying out loud but is not
# worth failing the install over, so this always returns 0.
nvim_headless() {
    local args=(-es -u "${HOME}/.config/nvim/init.vim" -i NONE)
    local cmd

    for cmd in "$@"; do
        args+=(-c "$cmd")
    done
    args+=(-c qa)

    if nvim "${args[@]}"; then
        echo "[++] nvim: $*"
    else
        echo "[!!] nvim: $* exited $?" >&2
    fi
}
