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

# install_vim_wrapper -- put a `vim` on PATH that runs neovim.
#
# This cannot be a mise shim. Mise picks the tool from the name it was invoked
# as, and no mise tool ships a `vim` binary, so a shim named vim finds nothing
# and falls through to /usr/bin/vim -- which on Arch is built -xterm_clipboard
# and drops every yank on the floor. Exec the shim by its own name instead, so
# `vim` is the mise-managed neovim even where mise was never activated.
install_vim_wrapper() {
    local wrapper="${HOME}/.local/bin/vim"
    local body='#!/bin/sh
exec "${HOME}/.local/share/mise/shims/nvim" "$@"'
    local reply

    mkdir -p "$(dirname "$wrapper")"

    if [[ -e "$wrapper" || -L "$wrapper" ]]; then
        if [[ -f "$wrapper" && ! -L "$wrapper" && "$(cat "$wrapper")" == "$body" ]]; then
            echo "[ok] ${wrapper} -> nvim"
            return 0
        fi

        # Same deal as safelink's `ln -i`: ask before overwriting whatever is
        # sitting there. A non-interactive run gets an empty read and declines.
        echo "[!!] ${wrapper} already exists:"
        ls -ld "$wrapper"
        read -r -p "replace it with the neovim wrapper? [y/N] " reply || reply=""

        if [[ ! "$reply" =~ ^[yY] ]]; then
            echo "[--] ${wrapper} left alone"
            return 0
        fi

        rm -f "$wrapper"
    fi

    printf '%s\n' "$body" > "$wrapper"
    chmod +x "$wrapper"
    echo "[++] ${wrapper} -> nvim"
}
