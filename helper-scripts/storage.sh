#! /bin/sh

# This script notifies the user about every storage which is up t 90% taken.

while :
do
    df -P -h | awk '
    NR != 1 {
        if($5 > 90){
            cmd=sprintf("dunstify -t 4000 -p \"%s: %s taken (%s remaining)\"", $6,
            $5, $4)
            system(cmd)
        }
    }'
    sleep 120
done
