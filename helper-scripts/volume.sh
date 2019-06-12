#!/bin/sh

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh toggle

function GetVolume {
    amixer -M get Master | awk '/Mono: Playback/ {print $4}' | tr -d []
}

function IsMute {
    amixer get Master | awk '/Mono: Playback/ {exit $6 == "[on]"}'
}

function GetBar {
    volume=$(GetVolume)
    bar=$(seq -s "─" $(($volume / 5)) | sed 's/[0-9]//g')
}

# Send the notification or replace notification with same ID
# $1 Body of notification
function SendNotification {
    local cache_file="${XDG_CACHE_HOME}/helper_scripts/dunst-volume"
    mkdir -p $XDG_CACHE_HOME/helper_scripts
    #read prev notification ID from cache file
    read ID < $cache_file
    if [ $ID -gt 0 ]
    then
        # replace prev notification
        dunstify -t 2000 -p -r $ID "Volume: $1" > /dev/null
    else
        dunstify -t 2000 -p "Volume: $1" > $cache_file
    fi
}

case $1 in
    up)
        # Increase the volume by 3%
        amixer -q -M set Master 3%+ unmute
        SendNotification $(GetVolume)
        ;;
    down)
        # Decrease the volume by 3%
        amixer -q -M set Master 3%- unmute
        SendNotification $(GetVolume)
        ;;
    toggle)
        # Toggle Master volume on/off
        amixer -q set Master toggle
        if IsMute ; then
            # Send the muted notification
            SendNotification "Mute"
        else
            SendNotification $(GetVolume)
        fi
        ;;
esac

