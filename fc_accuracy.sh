#! /bin/bash

# Extract yesterday's forecasted temperature
yesterday_fc=$(tail -2 rx_poc.log | sed -n '1p' | cut -f5)

# Extract today's observed temperature
today_temp=$(tail -2 rx_poc.log | sed -n '2p' | cut -f4)

# Data validation on extracted temperatures
is_integer() {
    [[ $1 =~ ^[+-]?[0-9]+$ ]]
}
if ! is_integer "$today_temp" || ! is_integer "$yesterday_fc"; then
    echo "ERROR: Invalid temperature data" >> error.log
    exit 1
fi

# Calculate accuracy
accuracy_temp=$(( today_temp-yesterday_fc ))
abs_accuracy=${accuracy_temp#-}
echo "Temperature accuracy: +/- $abs_accuracy"

# Assign accuracy label
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
