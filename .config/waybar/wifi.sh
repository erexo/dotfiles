#!/bin/bash

networks=$(nmcli -f SSID,SECURITY device wifi list | tail -n +2 | awk '{print $1}')

selected_network=$(echo "$networks" | wofi --dmenu --prompt="Select Wi-Fi Network")
if [ -z "$selected_network" ]; then
    exit 1
fi

network_security=$(nmcli -f SSID,SECURITY device wifi list | grep "$selected_network" | awk '{print $2}')
if [[ "$network_security" == *"WPA"* || "$network_security" == *"WEP"* ]]; then
    wifi_password=$(zenity --entry --hide-text --title="Wi-Fi password" --text="Enter password for $selected_network")
    
    if [ -n "$wifi_password" ]; then
        nmcli device wifi connect "$selected_network" password "$wifi_password" || {
            zenity --error --text="Failed to connect. Please check your password and try again."
            exit 1
        }
        exit 0
    fi
fi

output=`nmcli device wifi connect "$selected_network" || {
    zenity --error --text="Failed to connect to open network."
    exit 1
}`
zenity --info --text="$output"
