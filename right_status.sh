#!/bin/bash -


OWM_API_KEY=<your_api_key>


function forecast_weather() {

    WEATHER=$(curl --silent "http://api.openweathermap.org/data/2.5/forecast?id=5110253&appid=${OWM_API_KEY}&units=imperial")

    FAHRENHEIT=$(printf "%s" ${WEATHER} | jq '.list[0].main.temp')
    CITY=$(printf "%s" ${WEATHER} | jq -r '.city.name')
    COUNTRY=$(printf "%s" ${WEATHER} | jq -r '.city.country')
    FORECAST=$(printf "%s %s" ${WEATHER} | jq -r '.list[0].weather[0].description')

    printf "%s %s %s %s %s %s" "${CITY}" "${COUNTRY}" "/" "${FAHRENHEIT}°F" "/" "${FORECAST}"

}


forecast_weather
