useaws() {
  local p="${1:-default}"

  # creds
  eval "$(aws configure export-credentials --format env --profile "$p")"

  # region
  local r
  r="$(aws configure get region --profile "$p")"
  if [ -n "$r" ]; then
    export AWS_REGION="$r"
    export AWS_DEFAULT_REGION="$r"
  else
    unset AWS_REGION
    unset AWS_DEFAULT_REGION
  fi

  # endpoint
  local e
  e="$(aws configure get endpoint_url --profile "$p")"
  if [ -n "$e" ]; then
    export AWS_ENDPOINT_URL="$e"
  else
    unset AWS_ENDPOINT_URL
  fi

  echo "Loaded AWS profile: $p"
}
