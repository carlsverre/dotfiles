# Wiring this repo's gitconfig into the global one.

# git_include -- add $path to the global gitconfig's include.path list, once.
#
# ~/.gitconfig has to stay writable -- `git config --global` and credential
# helpers both write to it -- so it cannot be a symlink to the repo. Including
# our file instead leaves whatever else is in there alone.
git_include() {
    local include="$1"

    # -x -F: an include for "foo" must not count as an include for "foobar".
    if git config --global --get-all include.path 2>/dev/null | grep -qxF "$include"; then
        echo "[ok] gitconfig includes ${include}"
        return 0
    fi

    git config --global --add include.path "$include"
    echo "[++] gitconfig includes ${include}"
}
