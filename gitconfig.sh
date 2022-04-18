# configure gitconfig via a series of git commands to merge with any existing config

git config --global user.name "Carl Sverre"
git config --global user.useConfigOnly true
git config --global merge.defaultToUpstream true
git config --global push.default simple
git config --global pull.default simple
git config --global pull.ff only
git config --global rerere.enabled true
git config --global include.path .gitconfig.local
git config --global init.defaultBranch main
git config --global core.pager "less -FXRS -x4"
git config --global core.preloadIndex true
git config --global core.excludesFile ~/.gitignore
git config --global core.excludesFile ~/.gitignore
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
git config --global color.interactive auto
git config --global pager.color true

log_info "[ok] setup gitconfig"