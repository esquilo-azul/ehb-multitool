#!/bin/bash

time=$(avprobe "$1" 2>&1 | grep -o 'Duration:[^,]\+' | grep -o '[0-9]\+')
hours=$(echo "$time" | sed '1q;d')
minutes=$(echo "$time" | sed '2q;d')
seconds=$(echo "$time" | sed '3q;d')
miliseconds=$(echo "$time" | sed '4q;d')
calculated=$[$hours*3600 + $minutes*60 + $seconds]".$miliseconds"
echo $calculated
