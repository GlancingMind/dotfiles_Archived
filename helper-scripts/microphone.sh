#!/bin/sh

# You can call this script like this:
# $./microphone.sh toggle

function IsMute {
    amixer get Capture | awk '/Front Left: Capture/ {exit $7 == "[off]"}'
}

# Send the notification or replace notification with same ID
# $1 Body of notification
function SendNotification {
    local cache_file="${XDG_CACHE_HOME}/helper_scripts/dunst-microphone"
    mkdir -p $XDG_CACHE_HOME/helper_scripts
    #read prev notification ID from cache file
    read ID < $cache_file
    if [ $ID -gt 0 ]
    then
        # replace prev notification
        dunstify -t 2000 -p -r $ID "Microphone: $1" > /dev/null
    else
        dunstify -t 2000 -p "Microphone: $1" > $cache_file
    fi
}

case $1 in
    toggle)
        # Toggle Capture volume on/off
        amixer -q set Capture toggle
        if IsMute ; then
            # Send the muted notification
            SendNotification "Mute"
        else
            SendNotification "On"
        fi
        ;;
esac

