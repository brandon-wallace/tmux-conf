#!/bin/bash 


function load_average() {

    local fgcolor='#[fg=colour40]'

    printf "%s " "${fgcolor}$(uptime | awk -F: '{printf $NF}' | tr -d ',')"

}

function date_time() {

    local fgcolor='#[fg=colour202]'

    printf "%s" "${fgcolor}$(date +'%Y-%m-%d %H:%M:%S %Z')"

}

function main() {

    display_temperature
    #battery_meter
    load_average
    date_time

}

# Calling the main function which will call the other functions.
main

