#!/bin/bash

threshold=80

usage=$(df -H /|awk 'NR==2 {print $5}' | tr -d '%')


if (( usage > threshold )); then
    echo "Warning: Disk usage($usage%) is above $threshold%!"
else
    echo "Normal: Disk usage($usage%) is below $threshold%!"
fi
