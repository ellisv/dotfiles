#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import dbus

def busaware(func):
    try:
        bus = dbus.SessionBus().get_object('org.mpris.MediaPlayer2.spotify', '/org/mpris/MediaPlayer2')
    except dbus.exceptions.DBusException:
        sys.exit(1)

    return lambda *args: func(bus, *args)

@busaware
def get_player(bus):
    return dbus.Interface(bus, 'org.mpris.MediaPlayer2.Player')

@busaware
def get_property(bus, name):
    interface = dbus.Interface(bus, 'org.freedesktop.DBus.Properties')
    return interface.Get('org.mpris.MediaPlayer2.Player', name)


if __name__ == '__main__':
    try:
        arg = sys.argv[1]
    except IndexError:
        print('Command was not specified')
        sys.exit(2)

    if arg == 'current':
        playing = get_property('PlaybackStatus') == 'Playing'
        if not playing:
            sys.exit(0)

        metadata = get_property('Metadata')
        title = metadata['xesam:artist'][0] + ' - ' + metadata['xesam:title']
        trimmed_title = (title[:35] + '...') if len(title) > 38 else title

        print '♫', trimmed_title
    elif arg == 'play':
        get_player().Play()
    elif arg == 'pause':
        get_player().Pause()
    elif arg == 'toggle':
        get_player().PlayPause()
    elif arg == 'next':
        get_player().Next()
    elif arg == 'previous':
        get_player().Previous()
    elif arg == 'stop':
        get_player().Stop()
    else:
        print 'Unknown command'
        sys.exit(3)
