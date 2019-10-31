#!/bin/bash -


function temperature_levels() {
    sensors -f | awk '/Core 0/{printf "/ c0: %s ", $3} /Core 1/{printf "c1: %s ", $3}'
}


function battery_levels() {

        fgdefault='#[fg=brightblue]'

        if [ "$(cat /sys/class/power_supply/AC/online)" == 1 ] ; then
            charging='+' 
        else
            charging='-'
        fi

        # Check for existence of a battery.
        if [ -x /sys/class/power_supply/BAT0 ] ; then

            batt0=$(acpi -b 2> /dev/null | awk '/Battery 0/{print $4}' | cut -d, -f1)

            case $batt0 in
                100%|[5-9][0-9]%) fgcolor='#[fg=brightblue]' 
                    ;;
                2[5-9]%|3[0-9]%|4[0-9]%) fgcolor='#[fg=brightgreen]' 
                    ;;
                0%|1[0-9]%|2[0-4]%) fgcolor='#[fg=brightred]' 
                    ;;
            esac

            # Display the percentage of charge the battery has.
            printf "/ ${fgcolor}${charging}%s $fgdefault" "$batt0"
        fi

        # Check for existence of a second battery.
        if [ -x /sys/class/power_supply/BAT1 ] ; then

            batt1=$(acpi -b 2> /dev/null | awk '/Battery 1/{print $4}' | cut -d, -f1)

            case $batt1 in
                100%|[5-9][0-9]%) fgcolor='#[fg=brightblue]' 
                    ;;
                2[5-9]%|3[0-9]%|4[0-9]%) fgcolor='#[fg=brightyellow]' 
                    ;;
                0%|1[0-9]%|2[0-4]%) fgcolor='#[fg=brightred]' 
                    ;;
            esac

            # Display the percentage of charge the battery has.
            printf "/ ${fgcolor}${charging}%s $fgdefault" "$batt1"
        fi

}


function vpn_connection() {

    # Check for tun0 interface.
    [ -d /sys/class/net/tun0 ] && printf "/ %s " 'VPN*'

}


function tmux_left_status() {


    # Check to see if enp0s25 is up.
    if [ "$(cat /sys/class/net/enp0s25/operstate)" == "up" ] ; then
        # Display the IP address.
        printf "%s " "$(ip addr show enp0s25 | awk '/inet /{print $2}')" 

        battery_levels
        temperature_levels
        vpn_connection

    # Check to see if wlp3s0 is up.
    elif [ "$(cat /sys/class/net/wlp3s0/operstate)" == "up" ] ; then
        # Display the IP address.
        printf "%s " "$(ip addr show wlp3s0 | awk '/inet /{print $2}')" 
        battery_levels
        temperature_levels
        vpn_connection

    else

        # Print "None" if ip address is not configured.
        printf "%s " "None"
        battery_levels

    fi

}


tmux_left_status
