#! /bin/sh

# This script notifies the user every two minutes when the battery discharges
# below 20% for two seconds and persistently when below 10%.
# This script also notifies the user when the battery is charged above 95%.
# You can call this script like this:
# $./battery.sh

GetCapacity() {
    if [ -r '/sys/class/power_supply/BAT0/capacity' ]
    then
        echo $(cat '/sys/class/power_supply/BAT0/capacity')
    else
        echo 0
    fi
}

IsPluggedIn() {
    if [ -r '/sys/class/power_supply/AC/online' ]
    then
        echo $(cat '/sys/class/power_supply/AC/online')
    else
        echo 0
    fi
}

ID=$(dunstify -t 1 -p "Battery: Init")

while :
do
    capacity=$(GetCapacity)
    if [ $(IsPluggedIn) == 0 ]
    then
        if [ "$capacity" -le 10 ]
        then
            ID=$(dunstify -r "$ID" -u c -p "Battery at $capacity%")
        elif [ "$capacity" -le 20 ]
        then
            ID=$(dunstify -r "$ID" -t 2000 -p "Battery at $capacity%")
        fi
    else
        if [ "$capacity" -ge 95 ]
        then
            ID=$(dunstify -r "$ID" -u c -p "Battery at $capacity%")
        fi
    fi
    sleep 120
done
