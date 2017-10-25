#!/bin/sh

############################
#Base by ebrnd.
#http://ebrnd.de/?p=501
#https://github.com/eBrnd
############################

i3-nagbar -m "Output to" -t warning \
    -b "Project (Left)" "xrandr --output VGA1 --auto --left-of LVDS1" \
    -b "Project (Right)" "xrandr --output VGA1 --auto --right-of LVDS1" \
    -b "Mirror" "xrandr --output VGA1 --auto --same-as LVDS1" \
    -b "Reset" "xrandr --output VGA1 --off --output LVDS1 --auto"

sh ~/.fehbg
