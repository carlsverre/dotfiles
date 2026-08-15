# Symlinking the repo into the homedir.

# safelink -- point $pointer at $target without clobbering anything unexpected.
#
# The link is only rewritten when it is missing or aimed somewhere else, and
# even then ln asks first, so a file you put in the homedir by hand survives a
# careless run of install.sh.
safelink() {
    local pointer="$1"
    # `local` always exits 0, which is what keeps `set -e` from killing the
    # script here: an unreadable target leaves this empty and the check below
    # reports it properly.
    local target="$(readlink -f "$2")"

    if [[ -z "$pointer" || -z "$target" ]]; then
        echo "safelink: need a pointer and a target that exists" >&2
        return 1
    fi

    mkdir -p "$(dirname "$pointer")"

    # -L as well as -e, so a link left dangling by an uninstall still counts as
    # something already sitting in the way.
    if [[ -L "$pointer" || -e "$pointer" ]]; then
        # On a plain file readlink -f hands back the file's own path, so this
        # compares equal exactly when the link is already correct.
        if [[ "$(readlink -f "$pointer")" == "$target" ]]; then
            echo "[ok] ${pointer} -> ${target}"
            return 0
        fi

        echo "[!!] ${pointer} already exists:"
        ls -ld "$pointer"
    fi

    if ln -i -s "$target" "$pointer"; then
        echo "[++] ${pointer} -> ${target}"
    else
        echo "[--] ${pointer} left alone"
    fi
}

# safelink_children -- link every subdirectory of $src into $dst under its own
# name, so config/nvim shows up as ~/.config/nvim.
#
# Loose files in $src are skipped on purpose: those are the ones that land in
# the homedir under a different name (config/tmux.conf -> ~/.tmux.conf) and
# install.sh spells each of them out.
safelink_children() {
    local src="$1"
    local dst="$2"
    local child

    for child in "${src}"/*; do
        if [[ -d "$child" ]]; then
            safelink "${dst}/$(basename "$child")" "$child"
        fi
    done
}
