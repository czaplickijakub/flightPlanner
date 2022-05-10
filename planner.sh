#!/bin/bash

# Claude Batrouni & Jakub Czaplicki
# May 11 2022
# Flight Planning Software Solution

NOW=$(date +%b' '%d)
declare -a runwayList

correctInput1="false"
correctInput2="false"

#the api used: https://flightplandatabase.com/dev/api#endpoint-weather
#command to use: 
#`curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | xmllint --xpath "/response/airport/name/text()" -`
# use this website to get path locations: https://xmltoolbox.appspot.com/xpath_generator.html

clear
echo ""
echo "--------------------------------------------------------------------------------------------------"
echo "Hello! Thank you for using this flight planning software. Today is ${NOW}."
echo "--------------------------------------------------------------------------------------------------"

while [ $correctInput1 = "false" ]
do
    echo "Please enter the airport you are departing: "
    read DEPART
    airportCheck="$( wc -m <<< "$DEPART" )"
    if [ $((airportCheck-1)) -ne 4 ];then
        echo
        echo "Airport does not exist. Please input a correct airport"
        echo
    else
        correctInput1="true"
        echo
    fi
done

while [ $correctInput2 = "false" ]
do
    echo "Please enter the airport you are arriving at: "
    read ARRIVE
    airportCheck="$( wc -m <<< "$ARRIVE" )"
    if [ $((airportCheck-1)) -ne 4 ];then
        echo
        echo "Airport does not exist. Please input a correct airport"
        echo
    else
        correctInput2="true"
        echo
    fi
done

echo ""
echo "--------------------------------------------------------------------------------------------------"
echo "DEPARTURE"
echo "--------------------------------------------------------------------------------------------------"

echo "You are departing from `curl -s -H "Authorization: Basic Y4e6Zj34PHGmHRxQwW8sHVkrBA76B5x0YCDQw82w" -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | xmllint --xpath "//*/airport/name/text()" -` Airport"

echo "Please contact the tower at frequency `curl -s -H "Authorization: Basic Y4e6Zj34PHGmHRxQwW8sHVkrBA76B5x0YCDQw82w" -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | xmllint --xpath "//*[type = 'DEP']/." - | grep -oP '(?<=<frequency>).*?(?=</frequency>)' | head -1`" 

runwayList=()
while IFS= read -r line; do
    runwayList+=( "$line" )
done < <( curl -s -H "Authorization: Basic Y4e6Zj34PHGmHRxQwW8sHVkrBA76B5x0YCDQw82w" -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | grep -oP '(?<=<runway>).*?(?=</runway>)' | uniq )

RUNAMT=${#runwayList[@]}

echo "There are `curl -s -H "Authorization: Basic Y4e6Zj34PHGmHRxQwW8sHVkrBA76B5x0YCDQw82w" -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | xmllint --xpath "/response/airport/runwayCount/text()" -` take off platforms available and ${RUNAMT} runways"

echo "The runways that are available are: ${runwayList[*]}"


echo
echo "Current visbility report at `curl -s -H "Authorization: Basic Y4e6Zj34PHGmHRxQwW8sHVkrBA76B5x0YCDQw82w" -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | xmllint --xpath "//*/airport/name/text()" -` Airport is: "
echo "`curl -s -H "Authorization: Basic Y4e6Zj34PHGmHRxQwW8sHVkrBA76B5x0YCDQw82w" -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | grep -oP '(?<=<METAR>).*?(?=</METAR>)' | awk '{print substr($4,0,5);}' ` "
echo
echo "Wind report:"
echo "Direction: `curl -s -H "Authorization: Basic Y4e6Zj34PHGmHRxQwW8sHVkrBA76B5x0YCDQw82w" -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | grep METAR | awk '{print substr($3,0,3);}'` Degrees"
echo "Speed: `curl -s -H "Authorization: Basic Y4e6Zj34PHGmHRxQwW8sHVkrBA76B5x0YCDQw82w" -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | grep METAR | awk '{print substr($3,4,2);}'` Knots"

echo ""
echo "--------------------------------------------------------------------------------------------------"
echo "ARRIVAL"
echo "--------------------------------------------------------------------------------------------------"

echo "You are arriving at `curl -s -H "Authorization: Basic Y4e6Zj34PHGmHRxQwW8sHVkrBA76B5x0YCDQw82w" -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${ARRIVE} | xmllint --xpath "//*/airport/name/text()" -` Airport"

echo "Please contact the tower at frequency `curl -s -H "Authorization: Basic Y4e6Zj34PHGmHRxQwW8sHVkrBA76B5x0YCDQw82w" -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${ARRIVE} | xmllint --xpath "//*[type = 'APP']/." - | grep -oP '(?<=<frequency>).*?(?=</frequency>)' | head -1`" 

runwayList=()
while IFS= read -r line; do
    runwayList+=( "$line" )
done < <( curl -s -H "Authorization: Basic Y4e6Zj34PHGmHRxQwW8sHVkrBA76B5x0YCDQw82w" -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${ARRIVE} | grep -oP '(?<=<runway>).*?(?=</runway>)' | uniq )

RUNAMT=${#runwayList[@]}

echo "There are `curl -s -H "Authorization: Basic Y4e6Zj34PHGmHRxQwW8sHVkrBA76B5x0YCDQw82w" -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${ARRIVE} | xmllint --xpath "/response/airport/runwayCount/text()" -` take off platforms available and ${RUNAMT} runways"

echo "The runways that are available are: ${runwayList[*]}"

echo
echo "Current visbility report at `curl -s -H "Authorization: Basic Y4e6Zj34PHGmHRxQwW8sHVkrBA76B5x0YCDQw82w" -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${ARRIVE} | xmllint --xpath "//*/airport/name/text()" -` Airport is: "
echo "`curl -s -H "Authorization: Basic Y4e6Zj34PHGmHRxQwW8sHVkrBA76B5x0YCDQw82w" -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${ARRIVE} | grep -oP '(?<=<METAR>).*?(?=</METAR>)' | awk '{print substr($4,0,5);}' `"
echo
echo "Wind report:"
echo "Direction: `curl -s -H "Authorization: Basic Y4e6Zj34PHGmHRxQwW8sHVkrBA76B5x0YCDQw82w" -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${ARRIVE} | grep METAR | awk '{print substr($3,1,3);}'` Degrees"
echo "Speed: `curl -s -H "Authorization: Basic Y4e6Zj34PHGmHRxQwW8sHVkrBA76B5x0YCDQw82w" -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${ARRIVE} | grep METAR | awk '{print substr($3,4,2);}'` Knots"

echo ""
echo "--------------------------------------------------------------------------------------------------"
echo "Have a nice flight!"
echo "--------------------------------------------------------------------------------------------------"