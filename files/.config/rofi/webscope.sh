#!/bin/bash

LAUNCHER='rofi -width 30 -dmenu -i -p Work'
OPTIONS="gb github.com/build.snapcraft.io\ngs github.com/snapcraft.io\ngv
github.com/vanilla-framework\nls 0.0.0.0:8004\ns snapcraft.io\nss staging.snapcraft.io\ndv
docs.vanillaframework.io"

# Show exit wm option if exit command is provided as an argument
if [ ${#1} -gt 0 ]; then
    OPTIONS="Exit window manager\n$OPTIONS"
fi

MOVETOWORKSPACE="/home/luke/.config/i3/switch-to-workspace.sh"

#option=`echo -e $OPTIONS | $LAUNCHER | awk '{print $1}' | tr -d '\r\n'`
option=`echo -e $OPTIONS | $LAUNCHER`
if [ ${#option} -gt 0 ]
then
    case $option in
        "gb github.com/build.snapcraft.io")
            firefox github.com/canonical-websites/build.snapcraft.io; eval $MOVETOWORKSPACE
            ;;
        "gs github.com/snapcraft.io")
            firefox github.com/canonical-websites/snapcraft.io; eval $MOVETOWORKSPACE
            ;;
        "gv github.com/vanilla-framework")
            firefox github.com/vanilla-framework/vanilla-framework; eval $MOVETOWORKSPACE
            ;;
        "ls 0.0.0.0:8004")
            firefox 0.0.0.0:8004; eval $MOVETOWORKSPACE
            ;;
        "s snapcraft.io")
            firefox snapcraft.io; eval $MOVETOWORKSPACE
            ;;
        "ss staging.snapcraft.io")
            firefox staging.snapcraft.io; eval $MOVETOWORKSPACE
            ;;
        "dv docs.vanillaframework.io")
            firefox docs.vanillaframework.io; eval $MOVETOWORKSPACE
            ;;
        *)
            ;;
    esac
fi
