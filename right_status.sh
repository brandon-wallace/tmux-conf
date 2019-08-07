#!/bin/bash 


function forcast() {
    WEATHER=$(curl --silent
    "http://api.openweathermap.org/data/2.5/forecast?id=5110253&appid=<your_api_key>&units=imperial")
    FAHRENHEIT=$(printf "%s" ${WEATHER} | jq '.list[0].main.temp')
    COUNTRY=$(printf "%s" ${WEATHER} | jq -r '.city.country')
    CITY=$(printf "%s" ${WEATHER} | jq -r '.city.name')
    FORECAST=$(printf "%s %s" ${WEATHER} | jq -r '.list[0].weather[0].description')
    printf "%s %s %s %s %s %s" "${FAHRENHEIT:=""}°F" '/' "${CITY:=""}" "${COUNTRY:=""}" '/' "${FORECAST:=""}"
}


forcast
