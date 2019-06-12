#! /bin/sh

ID=$(dunstify -u c -t 1 -p "Memory: Init ID")
isDisplayed=false
#if available memory is lower then 1000MB send notification
memBoundary=1000

while :; do
    available=$(free -m -w | awk 'NR==2 {print $8}')
    if [ $available -lt $memBoundary ] && [ $isDisplayed == false ]
    then
        # send and replace previous notification
        ID=$(dunstify -u c -r $ID -p "Memory: Low")
        isDisplayed=true
    elif [ $available -ge $memBoundary ] && [ $isDisplayed == true ]
    then
        #remove displayed notification if memory is no longer exhauseted
        ID=$(dunstify -u c -t 1 -r $ID -p "Memory: Low")
        isDisplayed=false
    fi
    sleep 5
done

