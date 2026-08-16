# git
alias gil='git log --ext-diff --graph --abbrev-commit --stat -C --decorate --date=local'
alias gils="git log --graph --abbrev-commit --pretty=format:'%C(red)%h%C(reset) -%C(yellow)%d%C(reset) %s %C(green)(%cr) %C(bold blue)<%an>%C(reset)' -C --decorate --date=local"
alias gis='git status'
alias gid='git diff -C --date=local'
alias giw='git show --ext-diff -C --date=local --decorate'
alias gic='git checkout'

# rg
alias s='rg -S'

# clipboard
alias copy="xclip -selection clipboard -in"
alias paste="xclip -selection clipboard -out"

# docker
alias docker-ip="docker inspect -f '{{ .NetworkSettings.IPAddress }}'"

# feh
alias feh="feh --scale-down --auto-zoom --draw-filename --draw-tinted"

# wm
alias hc="herbstclient"
