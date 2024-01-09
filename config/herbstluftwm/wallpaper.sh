#!/usr/bin/env bash
PRIMARY_RESOLUTION=$(xrandr | awk -F'[ +]' '/primary/{print $4}')
if [[ -d ~/.wallpapers/${PRIMARY_RESOLUTION} ]]; then
    feh --randomize --bg-fill ~/.wallpapers/${PRIMARY_RESOLUTION}
else
    feh --randomize --bg-fill ~/.wallpapers
fi
