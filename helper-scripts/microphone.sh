#!/bin/bash

# You can call this script like this:
# $./microphone.sh up
# $./microphone.sh down
# $./microphone.sh toggle

function get_volume {
    amixer get Capture | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
    amixer get Capture | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
    volume=`get_volume`
    bar=$(seq -s "─" $(($volume / 5)) | sed 's/[0-9]//g')
    # Send the notification
    dunstify -i audio-volume-muted-blocking -t 3 -u low -r 2593 " $bar"
}

case $1 in
    up)
	# Increase the volume by 3%
	amixer -q -M set Capture 3%+
	send_notification
	;;
    down)
	# Decrease the volume by 3%
	amixer -q -M set Capture 3%-
	send_notification
	;;
    toggle)
    # Toggle Capture volume on/off
	amixer -q set Capture toggle
	if is_mute ; then
        # Send the muted notification
	    dunstify -i audio-volume-muted -t 3 -u low -r 2593 "Mute"
	else
	    send_notification
	fi
	;;
esac

