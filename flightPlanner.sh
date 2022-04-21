# Jakub Czaplicki
# May 11 2022
# Flight Planning Software Solution

NOW=$(date +%b' '%d)

echo "Hello! Thank you for using this flight planning software. Today is ${NOW}."

echo "Please enter the airport you are departing: "
read DEPART

echo "Please enter the airport you are arriving at: "
read ARRIVE

echo "--------------------------------------------------------------------------------------------------"

echo "You are departing from `curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART} | grep -oP '(?<=<name>).*?(?=</name>)' | head -1`. "

echo "There are `curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/${DEPART}| grep -oP '(?<=<runwayCount>).*?(?=</runwayCount>)'` runways available"

echo "Please tune into the departure frequency at `curl -s -H "Accept: application/xml" https://api.flightplandatabase.com/nav/airport/KJFK | grep -oP '(?<=<frequency>).*?(?=</frequency>)' | head -22 | tail -1`"