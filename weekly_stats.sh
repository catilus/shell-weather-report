#! /bin/bash
echo "Statistics on weekly temperature forecasting accuracies:"

# Store last week's accuracies into an array
weekly_fc=($(tail -7 synthetic_historical_fc_accuracy.tsv | cut -f6)) # --> change filename to 'historical_fc_accuracy.tsv' once we have at least a week of data.

# Convert negative values to positive values
for i in {0..6}; do
    weekly_fc[$i]=${weekly_fc[$i]#-}
done

# Find min and max temperature accuracies
min=${weekly_fc[0]}
max=${weekly_fc[0]}

for i in {1..6}; do
    if (( weekly_fc[i] < min )); then
        min=${weekly_fc[$i]} 
    fi
    if (( weekly_fc[i] > max )); then
        max=${weekly_fc[$i]}
    fi
done

# Validate data
#for i in {0..6}; do
#    echo ${weekly_fc[$i]}
#done

#for i in {0..6}; do
#    echo ${weekly_fc[$i]}
#done

echo "Min: $min, and Max: $max."
