#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import dbus
import argparse

class SpotifyControl:
    def __init__(self):
        self.bus = dbus.SessionBus().get_object('org.mpris.MediaPlayer2.spotify', '/org/mpris/MediaPlayer2')

    def property(self, name):
        interface = dbus.Interface(self.bus, 'org.freedesktop.DBus.Properties')
        return interface.Get('org.mpris.MediaPlayer2.Player', name)

    def print_current(self):
        playing = self.property('PlaybackStatus') == 'Playing'
        if not playing:
            return

        metadata = self.property('Metadata')
        title = metadata['xesam:artist'][0] + ' - ' + metadata['xesam:title']
        trimmed_title = (title[:35] + '...') if len(title) > 38 else title

        print u'#[fg=black,bg=colour35] ♫ #[fg=white,bg=colour236] {} '.format(trimmed_title).encode('utf-8')

    def send(self, signal):
        player = dbus.Interface(self.bus, 'org.mpris.MediaPlayer2.Player')
        getattr(player, signal)()


def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(metavar='action')

    parser_current = subparsers.add_parser('current', help='Print out a current song')
    parser_current.set_defaults(func=SpotifyControl.print_current)

    parser_toggle = subparsers.add_parser('toggle', help='Toggle between Play/Pause')
    parser_toggle.set_defaults(func=lambda spotify: spotify.send('PlayPause'))

    parser_next = subparsers.add_parser('next', help='Play a next song')
    parser_next.set_defaults(func=lambda spotify: spotify.send('Next'))

    parser_previous = subparsers.add_parser('previous', help='Play a previous song')
    parser_previous.set_defaults(func=lambda spotify: spotify.send('Previous'))

    args = parser.parse_args()

    try:
        spotify = SpotifyControl()
        args.func(spotify)
    except dbus.exceptions.DBusException:
        sys.exit(1)


if __name__ == '__main__':
    main()
