#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sh

POWER_PLUG             = u"\uf1e6"
BATTERY_EMPTY          = u"\uf244"
BATTERY_QUARTER        = u"\uf243"
BATTERY_HALF           = u"\uf242"
BATTERY_THREE_QUARTERS = u"\uf241"
BATTERY_FULL           = u"\uf240"

class BatteryStats(object):
    def __init__(self):
        self.stats = []
        self._parse()

    def _parse(self):
        lines = self._batterylines()

        for line in lines:
            self._parseline(line)


    def _add(self, status, percentage, time):
        self.stats.append({
            'status': self._parse_status(status),
            'percentage': self._parse_percentage(percentage),
            'time': self._parse_time(time),
            })

    def _parse_status(self, status):
        status = status.split(',')[0].lower()
        return None if status == 'unknown' else status

    def _parse_percentage(self, percentage):
        return int(percentage.split('%')[0])

    def _parse_time(self, time):
        return None if time == 'until' else time

    def _get_icon(self, stat):
        if stat['status'] == 'charging':
            icon = POWER_PLUG
            colour = 'green'
        else:
            if 100 >= stat['percentage'] >= 81:
                icon = BATTERY_FULL
                colour = 'green'
            elif 80 >= stat['percentage'] >= 61:
                icon = BATTERY_THREE_QUARTERS
                colour = 'green'
            elif 60 >= stat['percentage'] >= 41:
                icon = BATTERY_HALF
                colour = 'orange'
            elif 40 >= stat['percentage'] >= 11:
                icon = BATTERY_QUARTER
                colour = 'orange'
            else:
                icon = BATTERY_EMPTY
                colour = 'red'
        return "<span color='%s'>%s</span>" % (colour, icon,)

    def display(self):
        output = []
        time = None

        for stat in self.stats:
            output.append(self._get_icon(stat))
            if stat['time']:
                time = stat['time']

        if time:
            output.append(time)

        print '  '.join(output).encode('utf-8')

    def _batterylines(self):
        return sh.acpi('-b').splitlines()

    def _parseline(self, line):
        values = line.split()

        status = values[2]
        percentage = values[3]
        time = values[4] if len(values) > 4 else None

        self._add(status, percentage, time)

def main():
    stats = BatteryStats()
    stats.display()

if __name__ == '__main__':
    main()
