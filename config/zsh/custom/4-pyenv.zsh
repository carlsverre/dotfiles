export PYENV_VIRTUALENV_DISABLE_PROMPT=1
if [[ -d "${HOME}/.pyenv" ]]; then
    eval "$(${HOME}/.pyenv/bin/pyenv init -)"
    eval "$(${HOME}/.pyenv/bin/pyenv virtualenv-init -)"
fi