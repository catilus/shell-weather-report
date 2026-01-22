#! /bin/bash

# City variable declaration
city="casablanca"

# Downloading weather data without formatting into weather_report file
curl wttr.in/$city?T -o weather_report
