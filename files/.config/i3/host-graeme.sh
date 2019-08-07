#!/bin/bash

## remap keys
setxkbmap -option ctrl:nocaps # caps = ctrl

## Sort out the touchpad etc.
~/.config/i3/input-devices.sh
