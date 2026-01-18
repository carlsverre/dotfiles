ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}(%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[yellow]%}✗%{$fg_bold[cyan]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[cyan]%})"

_custom_vcs_info_async() {
  _jj() {
    jj --at-op=@ --no-pager --color=never "${@}"
  }

  # if we aren't in jj, fall back to git
  if ! _jj root &>/dev/null; then
    git_prompt_info
    return
  fi

  # commit the working tree
  jj debug snapshot

  # load current revision
  eval `_jj log --no-graph --limit 1 -r @ -T 'separate(" ",
    "rev_prefix=\"" ++ change_id.shortest(6).prefix() ++ "\"",
    "rev_rest=\"" ++ change_id.shortest(6).rest() ++ "\"",
  )'`

  # load closest bookmark
  bookmark=`_jj log --no-graph --limit 1 -r 'coalesce(
    heads(::@ & bookmarks()),
    heads(::@ & remote_bookmarks()),
  )' -T 'separate(" ", bookmarks, remote_bookmarks)' | cut -d ' ' -f 1`

  # color 8 is apparently gray
  fg_gray="\e[38;5;8m"

  JJ_INFO="%{$fg_bold[cyan]%}(%{$fg_bold[red]%}"
  JJ_INFO+="$bookmark "
  JJ_INFO+="%{$fg_bold[magenta]%}$rev_prefix%{$reset_color%}"
  JJ_INFO+="%{$fg_gray%}$rev_rest%{$reset_color%}"
  JJ_INFO+="%{$fg_bold[cyan]%})%{$reset_color%}"

  # echo metadata
  echo $JJ_INFO
}
_omz_register_handler _custom_vcs_info_async

custom_vcs_info() {
  echo -n $_OMZ_ASYNC_OUTPUT[_custom_vcs_info_async]
}

__zsh_prompt() {
    PROMPT=""
    if [[ -n "${SSH_CLIENT}" ]]; then
        PROMPT+='%{$fg_bold[red]%}('
        PROMPT+="$(hostname)"
        PROMPT+=')%{$reset_color%} '
    fi
    PROMPT+='%{$fg_bold[blue]%}%(5~|%-1~/…/%3~|%4~)%{$reset_color%} ' # cwd
    PROMPT+='%(?:%{$reset_color%}➜ :%{$fg_bold[red]%}➜ )' # User/exit code arrow
    PROMPT+='%{$reset_color%}'

    RPROMPT=""
    RPROMPT+='%(?..%{$fg_bold[red]%}$? )'
    RPROMPT+='%{$reset_color%}$(custom_vcs_info)'

    unset -f __zsh_prompt
}
__zsh_prompt
