#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh toggle


function get_volume {
    amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function get_bar {
    volume=`get_volume`
    bar=$(seq -s "─" $(($volume / 5)) | sed 's/[0-9]//g')
}

# Send the notification or replace notification with same ID
# $1 Icon to be displayed
# $2 Body of notification
function send_notification {
    local cache_file="${XDG_CACHE_HOME}/helper_scripts/dunst-volume"
    mkdir -p $XDG_CACHE_HOME/helper_scripts
    #read prev notification ID from cache file
    read ID < $cache_file 
	if [ $ID -gt 0 ]
	then
	    # replace prev notification
        dunstify -p -r $ID -i $1 "Volume: $2" > $cache_file
    else
        dunstify -p -i $1 "Volume: $2" > $cache_file
	fi
}

case $1 in
    up)
	# Increase the volume by 3%
	amixer -q -M set Master 3%+ unmute
	get_bar
	send_notification ICON $bar
	;;
    down)
	# Decrease the volume by 3%
	amixer -q -M set Master 3%- unmute
	get_bar
	send_notification ICON $bar
	;;
    toggle)
    # Toggle Master volume on/off
	amixer -q set Master toggle
	if is_mute ; then
        # Send the muted notification
	    send_notification ICON "Mute"
	else
	    get_bar
	    send_notification ICON $bar
	fi
	;;
esac

