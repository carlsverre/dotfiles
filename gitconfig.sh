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

log_info "[ok] setup gitconfig"