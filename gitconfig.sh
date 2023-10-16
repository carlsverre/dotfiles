# configure gitconfig via a series of git commands to merge with any existing config
#
git config --global include.path "${ROOTDIR}/config/gitconfig"
git config --global --add include.path .gitconfig.local

log_info "[ok] setup gitconfig"
