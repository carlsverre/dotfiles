#!/usr/bin/env bash

LEVEL=$(dunstctl get-pause-level)

if [[ $LEVEL -eq 0 ]]; then
  # printf ''
  printf '%s\n' '%{O2}'
else
  printf '%s\n' '%{F#FF5555}%{O2}%{F-}'
fi
