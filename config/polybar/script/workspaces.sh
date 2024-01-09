#!/usr/bin/env bash

C_ACT="#D4A989"
C_WRN="#FD7D70"

ICON_VIEWED="%{F${C_ACT}}●%{F-}"
ICON_ACTIVE="%{F${C_ACT}}◍%{F-}"
ICON_WARN="%{F${C_WRN}}◍%{F-}"
ICON_EMPTY="%{F-}○"

herbstclient --idle "tag_*" 2>/dev/null | {

    while true; do
        # Read tags into $tags as array
        IFS=$'\t' read -ra tags <<< "$(herbstclient tag_status)"
        {
            for i in "${tags[@]}" ; do
                ICON="${ICON_EMPTY}"
                # Read the prefix from each tag and render them according to that prefix
                case ${i:0:1} in
                    '#')
                        # the tag is viewed on the focused monitor
                        ICON="${ICON_VIEWED}"
                        ;;
                    ':')
                        # : the tag is not empty
                        ICON="${ICON_ACTIVE}"
                        ;;
                    '!')
                        # ! the tag contains an urgent window
                        ICON="${ICON_WARN}"
                        ;;
                    '-')
                        # - the tag is viewed on a monitor that is not focused
                        ICON="${ICON_ACTIVE}"
                        ;;
                    *)
                        # . the tag is empty
                        # There are also other possible prefixes but they won't appear here
                        ;;
                esac

                echo "%{A1:herbstclient use ${i:1}:} ${ICON} %{A -u -o}"
            done

            echo "%{F-}%{B-}"
        } | tr -d "\n"

        echo

        # wait for next event from herbstclient --idle
        read -r || break
    done
} 2>/dev/null
