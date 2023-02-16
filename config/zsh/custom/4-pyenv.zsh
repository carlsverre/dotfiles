export PYENV_VIRTUALENV_DISABLE_PROMPT=1
if command -v pyenv >/dev/null; then
    eval "$(pyenv init -)"
elif [[ -x "${HOME}/.pyenv/bin/pyenv" ]]; then
    eval "$(${HOME}/.pyenv/bin/pyenv init -)"
fi
