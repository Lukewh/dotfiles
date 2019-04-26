#!/usr/bin/python

import dbus
import os
import sys

def run(is_main):
    try:
        bus = dbus.SessionBus()
        spotify = bus.get_object("org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2")


        if os.environ.get('BLOCK_BUTTON'):
            control_iface = dbus.Interface(spotify, 'org.mpris.MediaPlayer2.Player')
            if (os.environ['BLOCK_BUTTON'] == '1'):
                control_iface.Previous()
            elif (os.environ['BLOCK_BUTTON'] == '2'):
                control_iface.PlayPause()
            elif (os.environ['BLOCK_BUTTON'] == '3'):
                control_iface.Next()

        spotify_iface = dbus.Interface(spotify, 'org.freedesktop.DBus.Properties')
        props = spotify_iface.Get('org.mpris.MediaPlayer2.Player', 'Metadata')

        if (sys.version_info > (3, 0)):
            return_str = str(props['xesam:artist'][0]) + " - " + str(props['xesam:title'])
            if is_main:
                print(return_str)
            else:
                return return_str
        else:
            return_str = props['xesam:artist'][0] + " - " + props['xesam:title']
            if is_main:
                print(return_str).encode('utf-8')
            else:
                return return_str
        if is_main:
            exit
        else:
            return
    except dbus.exceptions.DBusException:
        if is_main:
            exit
        else:
            return

if __name__ == "__main__":
    run(True)
