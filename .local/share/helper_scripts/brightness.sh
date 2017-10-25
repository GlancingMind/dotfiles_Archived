#!/bin/bash

# You can call this script like this:
# $./brightness.sh up
# $./brightness.sh down

function send_notification {
    # requests current screen brightness from xbacklight
    brightness=$(xbacklight -get)
    # remove fraction from brightness value
    # divide brightness by bar steps
    # generate bar with seq e.g. 1-2-3-4
    # remove numbers from seq
    bar=$(seq -s "─" $((${brightness%.*}/10)) | sed 's/[0-9]//g')
    # Send the notification
    dunstify -i moon-phase-icon -t 3 -u low -r 2593 " $bar"

    # debug information
    # echo $((${brightness%.*}/10))
    # echo ${brightness%.*}
    # seq -s "-" $((${brightness%.*}/10))
    # seq -s "-" $((${brightness%.*}/10)) | sed 's/[0-9]//g'
}

case $1 in
    up)
	# Increase the brightness by 10
    xbacklight +10
	send_notification
	;;
    down)
	# Decrease the brightness by 10
    xbacklight -10
	send_notification
	;;
esac

