#!/usr/bin/env bash

# check to see if the gh command is installed and logged in, otherwise exit silently
if ! command -v gh &>/dev/null || ! gh auth status &>/dev/null; then
    echo "%{F#FD7D70}check gh auth%{F-}"
    exit 0
fi

FROM=$(date -Iseconds -d "7 days ago")
TO=$(date -Iseconds)

QUERY=$(
    cat <<EOF
    { viewer {
        contributionsCollection(from:"${FROM}", to:"${TO}") {
            contributionCalendar {
                weeks {
                    contributionDays {
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

# this is a polybar script, output a colored circle for each day in $DATA
echo "${DATA}" | jq -r '.data.viewer.contributionsCollection.contributionCalendar.weeks[].contributionDays[] | [.color, .contributionCount] | @tsv' | while read -r color contributionCount; do
    if [[ $contributionCount -gt 0 ]]; then
        echo -n "%{F${color}}${COMPLETE_ICON}%{F-}%{O2}"
    else
        echo -n "%{F${color}}${INCOMPLETE_ICON}%{F-}%{O2}"
    fi
done
