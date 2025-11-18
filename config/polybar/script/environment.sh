#!/usr/bin/env bash

# wait for internet to come up
until ping -c1 www.google.com >/dev/null 2>&1; do sleep 0.1; done

URL=$(cat ~/.co2-click-api)
DATA=$(curl -s ${URL})
CO2=$(echo "${DATA}" | jq  -r .lastSampleCo2)
HUMIDITY=$(echo "${DATA}" | jq  -r .lastSampleHumidity)

BAD_CO2_ICON="靈"
GOOD_CO2_ICON=""
HUMIDITY_ICON=""

CO2_ICON="${GOOD_CO2_ICON}"
if [[ ${CO2} -ge 1000 ]]; then
    CO2_ICON="${BAD_CO2_ICON}"
fi

echo "${CO2_ICON}%{O12}${CO2} CO2 %{O15}${HUMIDITY_ICON}%{O7}${HUMIDITY}%"
