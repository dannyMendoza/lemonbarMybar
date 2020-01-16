#!/usr/bin/env python3

import gi,time
gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl, GLib
from subprocess import Popen

player = Playerctl.Player()

def listen():
    songList = []
    songList.append('{artist} - {title}'.format(artist=player.get_artist(),title=player.get_title()))
    print(songList[0])
    while True:
        #time.sleep(0.1)
        songList.append('{artist} - {title}'.format(artist=player.get_artist(),title=player.get_title()))
        if songList[0] == songList[1]:
            del songList[1]
            break
        else:
            songList[0] = songList[1]
            del songList[1]
            print(songList[0])
            break

listen()


