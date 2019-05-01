#!/usr/bin/python3
import subprocess
import sys
import os
import json


def is_connected():
    status = subprocess.check_output(["nordvpn", "status"])
    if "Status: Connected" in status.decode("utf-8"):
        return True
    else:
        return False

def nordvpn():
    connected = is_connected()

    clicked = False

    if os.environ.get("BLOCK_BUTTON"):
        if os.environ["BLOCK_BUTTON"] == "1":
            clicked = True

    if clicked:
        FNULL = open(os.devnull, "w")
        if connected:
            subprocess.check_call(["nordvpn", "disconnect"], stdout=FNULL, stderr=FNULL)
        else:
            subprocess.check_call(["nordvpn", "connect"], stdout=FNULL, stderr=FNULL)

        connected = is_connected()

    if not connected:
        print("<span color='red'></span>")
    else:
        print("<span color='green'></span>")

if __name__ == "__main__":
    nordvpn()
