#! /bin/bash

## This script evaluates 1-day temperature forecast accuracy 
## by comparing today's temperature (at 12PM) with yesterday's temperature (at 12PM).

## ----- FUNCTIONS -----

# Validation of extracted temperatures
is_temperature() {
    [[ $1 =~ ^[+-]?[0-9]+$ ]]
}

## ----- SCRIPT -----

## Extract temperatures from log file
# Store temperature (T) unit into a variable for stdout formatting
temp_unit=$(grep -oE '°C|°F' weather_report | sed -n '1p')

# Today's temperature
today_temp=$(tail -2 rx_poc.log | sed -n '2p' | cut -f4)

# Yesterday's forecasted temperature
yesterday_fc=$(tail -2 rx_poc.log | sed -n '1p' | cut -f5)

# Data validation on extracted temperatures
if ! is_temperature "$today_temp" || ! is_temperature "$yesterday_fc"; then
    echo "ERROR: Invalid temperature data" >> error.log
    exit 1
fi

## Calculate temperature accuracy
accuracy_temp=$(( today_temp-yesterday_fc ))

# Return the absolute of temperature accuracy for when we are dealing with + or - signs
abs_accuracy=${accuracy_temp#[+-]}

echo "Temperature accuracy: +/- $abs_accuracy$temp_unit"

# Assign label to temperature accuracy
if (( abs_accuracy <= 1 )); then
    accuracy_label='excellent'	
elif (( abs_accuracy <= 2 )); then
    accuracy_label='good'
elif (( abs_accuracy <= 3 )); then
    accuracy_label='fair'
else
    accuracy_label='poor'
fi

echo "Accuracy range: $accuracy_label"

# Extract current Year, Month and Day into variables for country/city being queried
city="Casablanca"
country="Morocco"
year=$(TZ='$country/$city' date +%Y)
month=$(TZ='$country/$city' date +%m)
day=$(TZ='$country/$city' date +%e)

# Append data to report of historical accuracies
echo -e "$year\t$month\t$day\t$today_temp\t$abs_accuracy\t$accuracy_label" >> historical_fc_accuracy.tsv

