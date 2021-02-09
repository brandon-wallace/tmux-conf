#!/bin/bash -


function ip_address() {

    interface_array=()

    # Loop through the interfaces available.
    for i in $(ls -1 /sys/class/net/); do

        # Add every interface to the array except for the loopback device.
        if [ "$i" != 'lo' ]; then

            interface_array+=($i)

        fi

    done

    # Check to see which interface is up.
    for j in ${interface_array[@]}; do

        if [ "$(cat /sys/class/net/${j}/operstate)" == "up" ]; then

            iface="${j}"

        else

            iface=""

        fi

    done

    if [ ! -z "$iface" ]; then

        # Display the IP address.
        printf "%s " "$(ip addr show $iface | awk '/inet /{print $2}')" 

    fi

}


function memory_levels() {

    # Display memory amount used / total memory and percentage.
    read used total <<< $(free -m | awk '/Mem/{printf $2" "$3}')

    fgcolor=''
    percent=''

    # If bc is installed calculate the percentage of memory used.
    if [ "$(which bc)" ]; then
    
        percent=$(bc -l <<< "100 * $total / $used")

        case $percent in

            # Warn user if memory is consuming more than 75%!
            7[5-9].*|8[0-9].*|9[0-9].*) fgcolor='#[fg=brightred]'
                ;;

        esac

    fi

    awk -v u=$used -v t=$total -v fg=$fgcolor -v p=$percent 'BEGIN {printf "%s/%sMB%s %.1f%", t, u, fg, p}'

}


function cpu_temperature() {

    # If sensors program is installed check the CPU core temperature.
    if [ "$(which sensors)" ]; then

        # Display temperature of the CPU cores.
        sensors -f | awk '/Core 0/{printf $3" "}/Core 1/{printf $3" "}'

    fi

}


function battery_levels() {

    # If acpi program is installed check the battery levels.
    if [ "$(which acpi)" ]; then

        # Show a plus sign if the battery is charging otherwise show a minus sign.
        if [ "$(cat /sys/class/power_supply/AC/online)" == 1 ] ; then

            charging='+' 

        else

            charging='-'

        fi

        # Check for existence of a battery.
        if [ -x /sys/class/power_supply/BAT0 ] ; then

            batt0=$(acpi -b 2> /dev/null | awk '/Battery 0/{print $4}' | cut -d, -f1)

            case $batt0 in

                # 100% - 75% => blue
                100%|9[0-9]%|8[0-9]%|7[5-9]%) fgcolor='#[fg=brightblue]' 
                    ;;
                # 74% - 50% => green
                7[0-4]%|6[0-9]%|5[0-9]%) fgcolor='#[fg=brightgreen]' 
                    ;;
                # 49% - 25% => yellow
                4[0-9]%|3[0-9]%|2[5-9]%) fgcolor='#[fg=brightyellow]' 
                    ;;
                # 24% - 0% => red
                2[0-4]%|1[0-9]%|[0-9]%) fgcolor='#[fg=brightred]' 
                    ;;

            esac

            # Display the percentage of charge the battery has.
            printf " ${fgcolor}${charging}%s $fgdefault" "$batt0"

        fi

        # Check for existence of a second battery. Some laptops have two batteries.
        if [ -x /sys/class/power_supply/BAT1 ] ; then

            batt1=$(acpi -b 2> /dev/null | awk '/Battery 1/{print $4}' | cut -d, -f1)

            case $batt1 in
               
                # 100% - 75% => blue
                100%|9[0-9]%|8[0-9]%|7[5-9]%) fgcolor=>'#[fg=>brightblue]' 
                    ;;
                # 74% - 50% => green
                7[0-4]%|6[0-9]%|5[0-9]%) fgcolor=>'#[fg=>brightgreen]' 
                    ;;
                # 49% - 25% => yellow
                4[0-9]%|3[0-9]%|2[5-9]%) fgcolor=>'#[fg=>brightyellow]' 
                    ;;
                # 24% - 0% => red
                2[0-4]%|1[0-9]%|[0-9]%) fgcolor=>'#[fg=>brightred]' 
                    ;;

            esac

            # Display the percentage of charge the battery has.
            printf " ${fgcolor}${charging}%s $fgdefault" "$batt1"

        fi

    fi

}


function is_vpn_enabled() {

    # Check for tun0 interface.
    [ -d /sys/class/net/tun0 ] && printf " %s" 'VPN*'

}


function main() {

    # Comment out any of the functions not needed.
    # If running this on a desktop computer battery level is not needed.
    ip_address
    battery_levels
    cpu_temperature
    memory_levels
    is_vpn_enabled

}


main
