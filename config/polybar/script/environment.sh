#!/usr/bin/env bash
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

echo "${CO2_ICON} ${CO2} CO₂   ${HUMIDITY_ICON} ${HUMIDITY}%"
