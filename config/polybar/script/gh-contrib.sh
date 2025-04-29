#!/usr/bin/env bash

# check to see if the gh command is installed and logged in, otherwise exit silently
if ! command -v gh &>/dev/null; then
    echo "%{F#FD7D70}check gh auth%{F-}"
    exit 0
fi

# Wait until “gh auth status” succeeds (exit-code 0) – retry every 0.5 s.
while ! gh auth status &>/dev/null; do
    sleep 0.5
done

FROM=$(date -Iseconds -d "6 days ago")
TO=$(date -Iseconds)

QUERY=$(
    cat <<EOF
    { viewer {
        contributionsCollection(from:"${FROM}", to:"${TO}") {
            contributionCalendar {
                weeks {
                    contributionDays {
                        weekday
                        contributionCount
                        color
                    }
                }
            }
        }
    } }
EOF
)

DATA=""
while true; do
    DATA=$(gh api graphql -f query="${QUERY}" 2>/dev/null)
    if [[ $? -eq 0 ]]; then
        break
    else
        sleep 0.5
    fi
done

COMPLETE_ICON=""
INCOMPLETE_ICON=""

echo -n " "

JQ_QUERY='
    .data.viewer.contributionsCollection.contributionCalendar.weeks[].contributionDays[]
    | [.weekday, .color, .contributionCount]
    | @tsv
'

# this is a polybar script, output a colored circle for each day in $DATA
echo "${DATA}" | jq -r "${JQ_QUERY}" | while read -r weekday color contributionCount; do
    if [[ $contributionCount -gt 0 ]]; then
        echo -n "%{F${color}}${COMPLETE_ICON}%{F-}%{O2}"
    elif [[ ${weekday} != 0 && ${weekday} != 6 ]]; then # ignore missing contributions on weekends
        echo -n "%{F${color}}${INCOMPLETE_ICON}%{F-}%{O2}"
    fi
done
