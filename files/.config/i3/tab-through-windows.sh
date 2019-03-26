#! /bin/bash

WHICH=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

i3-msg -t get_tree | jq 'to_entries | map(select(.name=="'$WHICH'")) | from_entries'

#i3-msg -t run_command "focus right"
