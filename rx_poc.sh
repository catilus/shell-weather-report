#! /bin/bash

## Script is run every day at 12PM local time

# City and country variable declaration
city="Casablanca"
country="Morocco"

#Downloading weather data without formatting into weather_report file
curl -s wttr.in/$city?T -o weather_report

# Extracting temperatures regardless of format
# Prints lines and line numbers in file that contain temperatures: 
# grep -nE '°C|°F' weather_report

# Returns only line numbers of the previous match
# grep -oE '^[0-9]+'

# Stores temperature unit into a variable

# Extracts observed temperature and into a variable (at line 4)
obs_temp=$(sed -n '4p' weather_report | grep -oE '[+-]?[0-9]+\([0-9]+\)|[+-]?[0-9]+' | sed -n '1p' | grep -oE '^[+-]?[0-9]+')
echo "Observed temperature: $obs_temp"

# 2. Extract forecasted T for next day at noon into a variable (at line 13)
# Selects line #13 in file --> extracts only the temperature based on format --> extracts for noon (2nd match) --> extracts only the actual temperature --> adds a + sign when temperature does not have one  
# sed -n '13p' weather_report | grep -oE '[+-]?[0-9]+\([0-9]+\)|[+-]?[0-9]+' | sed -n '3p' | grep -oE '^[+-]?[0-9]+' | sed -nE 's/(^[0-9]+)/+\1/p'
fc_temp=$(sed -n '13p' weather_report | grep -oE '[+-]?[0-9]+\([0-9]+\)|[+-]?[0-9]+' | sed -n '3p' | grep -oE '^[+-]?[0-9]+')
echo "Forecasted temperature: $fc_temp"

# 3. Extract current Year, Month and Day into variables
year=$(TZ='$country/$city' date +%Y)
month=$(TZ='$country/$city' date +%m)
day=$(TZ='$country/$city' date +%e)
#echo "$day/$month/$year"

# 4. Merge extracted variables into the report
echo -e "$year\t$month\t$day\t$obs_temp\t$fc_temp" >> rx_poc.log

