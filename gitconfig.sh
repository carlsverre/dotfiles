# configure gitconfig via a series of git commands to merge with any existing config
#

# read existing includes
INCLUDES=$(git config --global --get-all include.path || echo "")

# new includes to add
NEW_INCLUDES="
${ROOTDIR}/config/gitconfig
.gitconfig.local
"

# merge and update
for INCLUDE in ${NEW_INCLUDES}; do
  if [[ ! "${INCLUDES}" =~ "${INCLUDE}" ]]; then
    git config --global --add include.path "${INCLUDE}"
  fi
done

log_info "[ok] setup gitconfig"
