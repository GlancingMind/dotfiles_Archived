#!/bin/sh

#Dmenu multi montitor configurator.
#Inspired from Luke, the Smith of this masterpiece.
#   https://github.com/LukeSmithxyz/voidrice/blob/master/.scripts/i3cmds/displayselect
#
#Provide a wizard to configure multiple connected monitors.
#Feature request:
#- automaticaly detect monitors and suggest the last used profile for this specific setup (via EDID get from --query --verbose)
#   the same what autorandr is supposed to do


SetRotation() {
    display=$1
    rotation=$(printf "normal\nleft\nright\ninverted" | dmenu -i -p "Select rotation:")
    xrandr --output "$display" --auto --rotation $rotation
}

SetMode() {
    display=$1
    mode=$(printf "left-of\nright-of\nabove\nbelow\nmirror\noff" | dmenu -i -p "Select mode:")
    case "$mode" in
        'off') 
            xrandr --output "$display" --off
            ;;
        'mirror')
            output=$(echo "$connected" | grep -v $display | dmenu -i -p "Mirror to:")
            xrandr --output "$display" --auto --same-as "$output"
            ;;
        'left-of'|'right-of'|'above'|'below')
            output=$(echo "$connected" | grep -v $display | dmenu -i -p "Select display:")
            xrandr --output "$display" --auto --"$mode" "$output"
            ;;
    esac
}

LoadSetup() {
    savedsetups=$(awk -F "=" '{ print $1 }' $XDG_CONFIG_HOME/monitor-setups/monitor-setups.sh)
    #get name of setup which will be loaded
    name=$(printf "$savedsetups" | dmenu -i -p "Load:")
    xrandrcmd=$(awk -F "=" -v name="$name" '$1 == name { print $2 }' $XDG_CONFIG_HOME/monitor-setups/monitor-setups.sh)
    if [ -n "$xrandrcmd" ]; then 
        $($xrandrcmd)
    fi
}

SaveSetup() {
    savedsetups=$(awk -F "=" '{ print $1 }' $XDG_CONFIG_HOME/monitor-setups/monitor-setups.sh)
    #get name under which the setup should be saved
    name=$(printf "$savedsetups" | dmenu -i -p "Save as:")
    if [ -z $name ]; then 
        exit 
    fi
    #check if name already in use => ask for override permission
    contains=$(echo "$savedsetups" | grep "$name")
    awkcommand='
        $2 == "connected" && $3 == "primary" && $4 ~ /[0-9]+x[0-9]+\+[0-9]+\+[0-9]+/ {
            split($4, ary, "+")
            mode = ary[1]
            pos = ary[2]"x"ary[3]
            rotation = "normal"
            if ($4 ~ /(left|right|inverted)/) {
                rotation = $4
            }
            cmd = cmd " --output " $1 " --primary " " --mode " mode " --pos " pos " --rotation " rotation
        }
        $2 == "connected" && $3 ~ /[0-9]+x[0-9]+\+[0-9]+\+[0-9]+/  { 
            split($3, ary, "+")
            mode = ary[1]
            pos = ary[2]"x"ary[3]
            rotation = "normal"
            if ($4 ~ /(left|right|inverted)/) {
                rotation = $4
            }
            cmd = cmd " --output " $1 " --mode " mode " --pos " pos " --rotation " rotation
        }
        $2 == "connected" && $3 == "primary" && $4 !~ /[0-9]+x[0-9]+\+[0-9]+\+[0-9]+/  { 
            cmd = cmd " --output " $1 " --off "
        }
        $2 == "connected" && $3 != "primary" && $3 !~ /[0-9]+x[0-9]+\+[0-9]+\+[0-9]+/  { 
            cmd = cmd " --output " $1 " --off "
        }
        END {
            print "xrandr", cmd
        }
    '
    #get xrandrcmd
    xrandrcmd=$(echo "$displays" | awk "$awkcommand")
    if [ $contains ]; then
        echo "override with $xrandrcmd"
        $(sed -i --posix s/"$name"=.*/"$name"="$xrandrcmd"/ $XDG_CONFIG_HOME/monitor-setups/monitor-setups.sh)
    else
        echo "save"
        echo "$name=$xrandrcmd" >> "$XDG_CONFIG_HOME/monitor-setups/monitor-setups.sh"
    fi
}

ConfigureSetup() {
    primary=$(printf "$connected" | dmenu -i -p "Configure display:")
    option=$(printf "mode\nrotation" | dmenu -i -p "Select option:")
    case "$option" in 
        'mode') SetMode $primary;;
        'rotation') SetRotation $primary;;
    esac
}

WorkspaceSetup() {
    option=$(printf "edit\nload\nsave" | dmenu -i -p "Workspace setup:")
    case "$option" in 
        'edit') ConfigureSetup;;
        'load') LoadSetup;;
        'save') SaveSetup;;
    esac
}

#get all displays from xrandr
displays=$(xrandr -q | grep "connected")
#get all connected displays
connected=$(echo "$displays" | awk '$2 == "connected" { print $1}')

if [ $(echo "$connected" | wc -l) -gt 1 ]; then
    WorkspaceSetup
    #fix background image
    sh ~/.config/feh/feh-bg.sh
else 
    $(dmenu -p "No monitor connected")
fi
