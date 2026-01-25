#! /bin/bash

## Script is run every day at 12PM local time

## ----- FUNCTIONS -----

# Validation of extracted temperatures
is_temperature() {
    [[ $1 =~ ^[+-]?[0-9]+$ ]]
}

## ----- SCRIPT -----

# City and country variable declaration
city="Casablanca"
country="Morocco"

## Download weather data (without formatting) into weather_report file
curl -s wttr.in/$city?T -o weather_report

## Find lines that contain temperature data
# Store temperature (T) unit into a variable for stdout formatting
temp_unit=$(grep -oE '°C|°F' weather_report | sed -n '1p')

## Extract Ts of interest and store in an array
# Observed is at line 4 - only one value
# Next day forecasted is at line 13 - second value for Noon
# Two day forecasted is at line 23 - ditto
# Three day forecasted is at line 33 - ditto
declare -a temp_array
temp_array[0]=$(sed -n '4p' weather_report | grep -oE '[+-]?[0-9]+\([0-9]+\)|[+-]?[0-9]+' | grep -oE '^[+-]?[0-9]+')

if ! is_temperature "${temp_array[0]}"; then
    echo "ERROR: Invalid temperature data extracted at line4." >> error.log
    exit 1
fi


line=13

# Extract temperature and validate extracted data before continuing
for (( i=1; i<=3; i++ )); do
    temp_array[i]=$(sed -n "${line}p" weather_report | 
    grep -oE '[+-]?[0-9]+\([0-9]+\)|[+-]?[0-9]+' | 
    sed -n '2p' | 
    grep -oE '^[+-]?[0-9]+')
        
    if ! is_temperature "${temp_array[i]}"; then
        echo "ERROR: Invalid temperature data extracted at line$line." >> error.log
        exit 1
    fi
    
    (( line+=10 ))
done

# Send temperatures to stdout
echo "Observed temperature: ${temp_array[0]}$temp_unit"
echo "Next-day forecasted temperature (12PM): ${temp_array[1]}$temp_unit"
echo "2-day forecasted temperature (12PM): ${temp_array[2]}$temp_unit"
echo "3-day forecasted temperature (12PM): ${temp_array[3]}$temp_unit"

## Add year, month, day, time, and temperatures to report
year=$(TZ='$country/$city' date +%Y)
month=$(TZ='$country/$city' date +%m)
day=$(TZ='$country/$city' date +%e)
#echo "$day/$month/$year"

# 4. Merge extracted variables into the report
echo -e "$year\t$month\t$day\t${temp_array[0]}\t${temp_array[1]}\t${temp_array[2]}\t${temp_array[3]}" >> rx_poc.log



