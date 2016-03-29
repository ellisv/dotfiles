#!/usr/bin/python
# -*- coding: utf-8 -*-

import dbus, sys

session_bus = dbus.SessionBus()
try:
    spotify_bus = session_bus.get_object('org.mpris.MediaPlayer2.spotify', '/org/mpris/MediaPlayer2')
except dbus.exceptions.DBusException:
    sys.exit(1)
spotify_properties = dbus.Interface(spotify_bus, 'org.freedesktop.DBus.Properties')
metadata = spotify_properties.Get('org.mpris.MediaPlayer2.Player', 'Metadata')

title = metadata['xesam:artist'][0] + ' - ' + metadata['xesam:title']
title = (title[:35] + '...') if len(title) > 38 else title

print '♫', title
