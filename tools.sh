# use webinstall to get some useful tools
# index available here: https://github.com/webinstall/webi-installers
webinstall pathman

webinstall rg &
webinstall fd &
webinstall fzf &
webinstall zoxide &
webinstall jq &

# install direnv
DIRENV_VERSION="v2.32.2"
DIRENV_URL="https://github.com/direnv/direnv/releases/download/${DIRENV_VERSION}/direnv.linux-amd64"
install_binary "${DIRENV_URL}" direnv &

wait

