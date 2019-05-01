#!/bin/bash

button=$1
clicked=false

if [ -z ${button+x} ]; then
  clicked=true
fi

RED="\033[0;31m"
GREEN="\033[0;32m"
NORMAL="\033[0m"
output=$(nordvpn status)

if [[ "$output" == *"Status: Disconnected"* ]]; then
  echo "<span color='red'>${clicked}</span>"
elif [[ "$output" == *"Status: Connected"* ]]; then
  echo "<span color='green'>${clicked}</span>"
else
  echo "?"
fi
