#! /bin/bash

ACTIVE=$(i3-msg -t get_workspaces | jq ".[] | select(.focused==true).name" | cut -d"\"" -f2)

echo $ACTIVE
if [ "$ACTIVE" -ne "1" ]; then
 i3-msg "workspace "1: 
fi
