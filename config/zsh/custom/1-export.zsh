export LANG=en_US.UTF-8
export WEBI_WELCOME=0
export PAGER="less -FXRS -x4"

if [[ "${REMOTE_CONTAINERS}" = "true" ]]; then
    export EDITOR="code"
else
    export EDITOR="${EDITOR:-vim}"
fi
