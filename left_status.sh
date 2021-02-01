#!/bin/bash -


function install_dependencies() {

    # Check to make sure dependencies are installed.
    for a in 'bc' 'sensors' 'acpi'; do

        [ "(which $a)" ] || printf "%sPlease install ${a}."

    done

}


function temperature_levels() {

    # Display temperature of the CPU cores.
    sensors -f | awk '/Core 0/{printf $3" "}/Core 1/{printf $3" "}'

    # Display memory amount used / total memory and percentage.
    read used total <<< $(free -m | awk '/Mem/{printf $2" "$3}')

    percent=$(bc -l <<< "100 * $total / $used")

    awk -v u=$used -v t=$total -v p=$percent 'BEGIN {printf "%s/%s %.1f%", t, u, p}'

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

                100%|9[0-9]%|8[0-9]%|7[5-9]%) fgcolor='#[fg=brightblue]'
                    ;;
                7[0-4]%|6[0-9]%|5[0-9]%) fgcolor='#[fg=brightgreen]'
                    ;;
                4[0-9]%|3[0-9]%|2[5-9]%) fgcolor='#[fg=brightyellow]'
                    ;;
                2[0-4]%|1[0-9]%|[0-9]%) fgcolor='#[fg=brightred]'
                    ;;

            esac

            # Display the percentage of charge the battery has.
            printf "/ ${fgcolor}${charging}%s $fgdefault" "$batt0"

        fi

        # Check for existence of a second battery.
        if [ -x /sys/class/power_supply/BAT1 ] ; then

            batt1=$(acpi -b 2> /dev/null | awk '/Battery 1/{print $4}' | cut -d, -f1)

            case $batt1 in

                100%|9[0-9]%|8[0-9]%|7[5-9]%) fgcolor='#[fg=brightblue]'
                    ;;
                7[0-4]%|6[0-9]%|5[0-9]%) fgcolor='#[fg=brightgreen]'
                    ;;
                4[0-9]%|3[0-9]%|2[5-9]%) fgcolor='#[fg=brightyellow]'
                    ;;
                2[0-4]%|1[0-9]%|[0-9]%) fgcolor='#[fg=brightred]'
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

    # Create an empty array.
    interface_arr=()

    # Check available interfaces.
    for i in $(ls -1 /sys/class/net/); do

        # Add every interface to the array except for the loopback device.
        if [ "$i" != 'lo' ]; then

            interface_arr+=($i)

        fi

    done

    # Check for interfaces that are up.
    for j in ${interface_arr[@]}; do

        if [ "$(cat /sys/class/net/${j}/operstate)" == "up" ]; then

            iface="${j}"

        else

            iface=""

        fi

    done

    # Print the ip address of the interface.
    if [ ! -z "$iface" ]; then

        printf "%s " "$(ip addr show $iface | awk '/inet /{print $2}')" 

    fi

    cpu_memory_levels
    vpn_connection
    battery_levels

}

install_dependencies
tmux_left_status
