#! /bin/bash

## This script performs statistics on temperature forecasting accuracies of the last seven days.

## ----- SCRIPT -----

# Store last seven days' accuracies into an array
weekly_acc=($(tail -7 historical_fc_accuracy.tsv | cut -f5))
#for i in {0..6}; do
#    weekly_acc[$i]=${weekly_acc[$i]#-}
#done

# Find best (minimum) and worst (maximum) temperature accuracies
min=${weekly_acc[0]}
max=${weekly_acc[0]}

for i in {1..6}; do
    if (( weekly_acc[i] < min )); then
        min=${weekly_acc[$i]} 
    fi
    if (( weekly_acc[i] > max )); then
        max=${weekly_acc[$i]}
    fi
done

echo "Best accuracy: $min, and worst accuracy: $max."
