#! /bin/bash
echo "Statistics on weekly temperature forecasting accuracies:"

# Store last week's accuracies into an array
weekly_fc=($(tail -7 synthetic_historical_fc_accuracy.tsv | cut -f6))

# Validate array
for i in {0..6}; do
    echo ${weekly_fc[i]}
done
