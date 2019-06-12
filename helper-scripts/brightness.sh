#!/bin/bash

# You can call this script like this:
# $./brightness.sh up
# $./brightness.sh down

# Send the notification or replace notification with same ID
# $1 Body of notification
function SendNotification {
    local cache_file="${XDG_CACHE_HOME}/helper_scripts/dunst-brightness"
    mkdir -p $XDG_CACHE_HOME/helper_scripts
    #read prev notification ID from cache file
    read ID < $cache_file
    if [ $ID -gt 0 ]
    then
        # replace prev notification
        dunstify -t 2000 -p -r $ID "Brightness: $1" > /dev/null
    else
        dunstify -t 2000 -p "Brightness: $1" > $cache_file
    fi
}

case $1 in
    up)
        xbacklight +10
        SendNotification $(xbacklight -get | cut -d"." -f1)
        ;;
    down)
        xbacklight -10
        SendNotification $(xbacklight -get | cut -d"." -f1)
        ;;
esac

