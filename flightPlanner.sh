#!/bin/bash

# Claude Batrouni & Jakub Czaplicki
# May 11 2022
# Flight Planning Software Solution

NOW=$(date +%b' '%d)
URL=
declare -a runwayList
$flag=1

echo "Hello! Thank you for using this flight planning software. Today is ${NOW}."
echo "Please enter the airport you are departing: "
read DEPART

# echo "Please enter the airport you are arriving at: "
# read ARRIVE

echo "--------------------------------------------------------------------------------------------------"

echo "You are departing from `curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | grep -oP '(?<=<name>).*?(?=</name>)' | head -1`."

echo "Please tune into the departure frequency at `curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | grep -oP '(?<=<frequency>).*?(?=</frequency>)' | head -22 | tail -1`"

runwayList=()
while IFS= read -r line; do
    runwayList+=( "$line" )
done < <( curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | grep -oP '(?<=<runway>).*?(?=</runway>)' | uniq )

RUNAMT=${#runwayList[@]}

echo "There are `curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART}| grep -oP '(?<=<runwayCount>).*?(?=</runwayCount>)'` takeoff platforms available and ${RUNAMT} runways"

echo "The runways that are available are: ${runwayList[*]}"

echo "Please select your departing runway:"
read RUNWAY

for i in "${runwayList[@]}"
do
    if [ "$i" = "$RUNWAY" ]
    then
        flag=0
    fi
done

if [ $flag -eq 1 ]
then
    echo "Invalid Runway. Please input a valid runway."
else
    echo "Valid Runway!"
fi
#curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/kjfk | sed 's/<runway>\(.*\)<\/runway>/\1/g'

#xmllint --xpath '/response/airport/name/text()' airportData