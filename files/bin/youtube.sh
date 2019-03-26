#! /bin/bash

FILENAME=$(youtube-dl -s --restrict-filenames --get-filename -o "~/Downloads/%(title)s.%(ext)s" $1)

youtube-dl --restrict-filenames -o "~/Downloads/%(title)s.%(ext)s" $1

mpv "$FILENAME"
rm "$FILENAME"
