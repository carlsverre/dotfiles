# use webinstall to get some useful tools
# index available here: https://github.com/webinstall/webi-installers
webinstall rg
webinstall fzf
webinstall zoxide
command -v jq >/dev/null || webinstall jq

# install direnv
DIRENV_VERSION="v2.31.0"
DIRENV_URL="https://github.com/direnv/direnv/releases/download/${DIRENV_VERSION}/direnv.linux-amd64"
install_binary "${DIRENV_URL}" direnv