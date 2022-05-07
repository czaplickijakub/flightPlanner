#!/bin/bash

# Claude Batrouni & Jakub Czaplicki
# May 11 2022
# Flight Planning Software Solution

NOW=$(date +%b' '%d)
declare -a runwayList

#the api used: https://flightplandatabase.com/dev/api#endpoint-weather
#command to use: 
#`curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | xmllint --xpath "/response/airport/name/text()" -`
# use this website to get path locations: https://xmltoolbox.appspot.com/xpath_generator.html

echo "Hello! Thank you for using this flight planning software. Today is ${NOW}."

echo "Please enter the airport you are departing: "
read DEPART

echo "Please enter the airport you are arriving at: "
read ARRIVE

echo ""
echo "--------------------------------------------------------------------------------------------------"
echo "DEPARTURE"
echo "--------------------------------------------------------------------------------------------------"

echo "You are departing from `curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | xmllint --xpath "//*/airport/name/text()" -` Airport"

echo "Please contact the tower at frequency `curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | xmllint --xpath "//*[type = 'DEP']/." - | grep -oP '(?<=<frequency>).*?(?=</frequency>)' | head -1`" 

runwayList=()
while IFS= read -r line; do
    runwayList+=( "$line" )
done < <( curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | grep -oP '(?<=<runway>).*?(?=</runway>)' | uniq )

RUNAMT=${#runwayList[@]}

echo "There are `curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | xmllint --xpath "/response/airport/runwayCount/text()" -` take off platforms available and ${RUNAMT} runways"

echo "The runways that are available are: ${runwayList[*]}"

echo ""
echo "--------------------------------------------------------------------------------------------------"
echo "ARRIVAL"
echo "--------------------------------------------------------------------------------------------------"

echo "You are arriving at `curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${ARRIVE} | xmllint --xpath "//*/airport/name/text()" -` Airport"

echo "Please contact the tower at frequency `curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${ARRIVE} | xmllint --xpath "//*[type = 'APP']/." - | grep -oP '(?<=<frequency>).*?(?=</frequency>)' | head -1`" 

runwayList=()
while IFS= read -r line; do
    runwayList+=( "$line" )
done < <( curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${ARRIVE} | grep -oP '(?<=<runway>).*?(?=</runway>)' | uniq )

RUNAMT=${#runwayList[@]}

echo "There are `curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${ARRIVE} | xmllint --xpath "/response/airport/runwayCount/text()" -` take off platforms available and ${RUNAMT} runways"

echo "The runways that are available are: ${runwayList[*]}"

echo ""
echo "--------------------------------------------------------------------------------------------------"
echo "Have a nice flight!"
echo "--------------------------------------------------------------------------------------------------"