#!/bin/bash

# Define the options
options="⏻ Shutdown\n⟳ Restart\n☾ Hibernate\n⏹ Suspend"

# Show the options in Wofi
selected=$(echo -e "$options" | wofi --no-actions --dmenu --insensitive --prompt "Power Menu" --lines=8)

# Execute the selected command
case "$selected" in
    "⏻ Shutdown")
        systemctl poweroff
        ;;
    "⟳ Restart")
        systemctl reboot
        ;;
    "☾ Hibernate")
        systemctl hibernate
        ;;
    "⏹ Suspend")
        systemctl suspend
        ;;
    *)
        exit 1
        ;;
esac
