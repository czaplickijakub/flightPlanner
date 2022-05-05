#!/bin/bash

# Claude Batrouni & Jakub Czaplicki
# May 11 2022
# Flight Planning Software Solution

NOW=$(date +%b' '%d)
declare -a runwayList
FLAG=1

#command to use: 
#`curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | xmllint --xpath "/response/airport/name/text()" -`

echo "Hello! Thank you for using this flight planning software. Today is ${NOW}."
echo "Please enter the airport you are departing: "
read DEPART

echo "--------------------------------------------------------------------------------------------------"

echo "You are departing from `curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | xmllint --xpath "/response/airport/name/text()" -` Airport"

# echo "Please enter the airport you are arriving at: "
# read ARRIVE

echo "Please contact the tower at `curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | xmllint --xpath "/response/airport/frequencies/frequency[15]/frequency/text()" -`" 

runwayList=()
while IFS= read -r line; do
    runwayList+=( "$line" )
done < <( curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | grep -oP '(?<=<runway>).*?(?=</runway>)' | uniq )

RUNAMT=${#runwayList[@]}

echo "There are `curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | xmllint --xpath "/response/airport/runwayCount/text()" -` take off platforms available and ${RUNAMT} runways"

echo "The runways that are available are: ${runwayList[*]}"

