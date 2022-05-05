#!/bin/bash

# Claude Batrouni & Jakub Czaplicki
# May 11 2022
# Flight Planning Software Solution

NOW=$(date +%b' '%d)
declare -a runwayList
FLAG=1

echo "Hello! Thank you for using this flight planning software. Today is ${NOW}."
echo "Please enter the airport you are departing: "
read DEPART

DEPCMD=`curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART}`

echo "--------------------------------------------------------------------------------------------------"

echo  `curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | xmllint --xpath "/response/airport/name/text()" -`


# echo "Please enter the airport you are arriving at: "
# read ARRIVE

