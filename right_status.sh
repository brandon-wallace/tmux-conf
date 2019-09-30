#!/bin/bash 


function forecast() {
    WEATHER=$(curl --silent
    "http://api.openweathermap.org/data/2.5/forecast?id=5110253&appid=<your-api-key>&units=imperial")

    RESPONSE=$(printf %s ${WEATHER} | jq -r '.cod')

    case $RESPONSE in
        200)
            FAHRENHEIT=$(printf "%s" ${WEATHER} | jq '.list[0].main.temp')
            COUNTRY=$(printf "%s" ${WEATHER} | jq -r '.city.country')
            CITY=$(printf "%s" ${WEATHER} | jq -r '.city.name')
            FORECAST=$(printf "%s %s" ${WEATHER} | jq -r '.list[0].weather[0].description')
            printf "%s %s %s %s %s %s" "${FAHRENHEIT:=""}°F" '/' "${CITY:=""}" "${COUNTRY:=""}" '/' "${FORECAST:=""}"
            ;;
        401)
            printf "%s %s %s %s %s %s" "${FAHRENHEIT:="??"}°F" '/' "${CITY:="Bronx"}" "${COUNTRY:="US"}" '/' "${FORECAST:="unknown"}"
            ;;
        *)
            printf "%s" "Error"
    esac
}


forecast
