function log {
    echo "[${1}] ${2}"
}

function log_info {
    log "INFO" "$@"
}
function log_warn {
    log "WARN" "$@"
}
function log_error {
    log "ERROR" "$@"
}

# verify ROOTDIR is set
if [ -z "$ROOTDIR" ]; then
    log_error "Must set ROOTDIR before sourcing lib"
    return 1
fi

export LOCALBIN="$HOME/.local/bin"
export LOCALOPT="$HOME/.local/opt"
export WEBI_WELCOME=0

function is_mac {
    test $(uname -s) = "Darwin"
}

function canonical_path {
    local path="$1"
    if is_mac; then
        python -c "import os;print(os.path.realpath('$path'))"
    else
        readlink -f "$path"
    fi
}

# Sets up a simlink at $pointer pointing at $target
function safelink {
    local pointer="$1"
    local target="${2}"

    # verify args are non-empty
    if [ -z "$pointer" ]; then
        log_error "safelink: pointer is empty"
        return 1
    fi
    if [ -z "$target" ]; then
        log_error "safelink: target is empty"
        return 1
    fi

    # make sure that the pointer's directory exists
    mkdir -p $(dirname "$pointer")

    # check to see if the pointer exists
    if [[ -e "$pointer" ]]; then
        # if it exists, figure out its canonical path
        # if its not a symlink this will just return the abspath to $pointer
        local current_target="$(canonical_path "$pointer")"

        # if its pointing at the right spot, we are done
        if [[ "$current_target" == "$target" ]]; then
            log_info "[ok] ${pointer} -> ${target}"
            return 0
        fi

        # otherwise, we need to warn the user
        log_warn "[warning] ${pointer} already exists, it looks like:"
        ls -l "$pointer"
    else
        log_info "[++] ${pointer} -> ${target}"
    fi

    # setup the symlink, -i will ask the user before overwriting a symlink
    ln -i -s "$target" "$pointer"
    return $?
}

should_update() {
    return $(test ${UPDATE:-false} = "true")
}

install_from_tar_gz() {
    local url="$1"
    local binpath="$2"
    local binname="${3:-$(basename "$binpath")}"

    if ! should_update && [[ -e "${LOCALBIN}/${binname}" ]]; then
        log_info "[ok] ${binname} already installed"
        return 0
    fi

    mkdir -p "${LOCALOPT}/${binname}"
    curl -Ls "${url}" | tar xzf - -C "${LOCALOPT}/${binname}"
    safelink "${LOCALBIN}/${binname}" "${LOCALOPT}/${binname}/${binpath}"

    log_info "[++] ${binname} installed"
}

install_binary() {
    local url="$1"
    local binname="$2"

    if ! should_update && [[ -e "${LOCALBIN}/${binname}" ]]; then
        log_info "[ok] ${binname} already installed"
        return 0
    fi

    curl -Ls "${url}" > "${LOCALBIN}/${binname}"
    chmod +x "${LOCALBIN}/${binname}"
    log_info "[++] ${binname} installed"
}

webinstall() {
    local name="$1"
    local binname="${2:-${name}}"
    binname="${binname%@*}"

    # install webi if missing
    if [[ ! -e "${LOCALBIN}/webi" ]]; then
        curl -sS https://webinstall.dev/webi | bash >/dev/null
        log_info "[++] webi installed"
    fi

    if should_update || ! command -v "${binname}" >/dev/null; then
        log_info "installing ${binname}"
        webi "${name}"
    else
        log_info "[ok] ${binname} already installed"
    fi
}
