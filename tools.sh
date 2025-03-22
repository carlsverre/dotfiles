# use webinstall to get some useful tools
# index available here: https://github.com/webinstall/webi-installers
webinstall pathman

if ! is_mac; then
  webinstall rg &
  webinstall jq &
fi

webinstall fd &
webinstall fzf &
webinstall zoxide &
webinstall sqlpkg &

# install direnv
DIRENV_VERSION="v2.34.0"
if is_mac; then
  DIRENV_URL="https://github.com/direnv/direnv/releases/download/${DIRENV_VERSION}/direnv.darwin-arm64"
else
  DIRENV_URL="https://github.com/direnv/direnv/releases/download/${DIRENV_VERSION}/direnv.linux-amd64"
fi
install_binary "${DIRENV_URL}" direnv

wait
