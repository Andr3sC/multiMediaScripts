#!/bin/bash

if [ $# -lt 1 ]
then
        echo "No command?"
	echo "$0 play|stop|next|prev|getTitle|getArtist|getAlbum|getStatus|getArtUrl"
        exit 2
fi

if [ "$(pgrep -c -f /usr/bin/gmusicbrowser)" = "0" ]
then
  echo "Gmusicbrowser is not running"
  exit 1
fi

case $1 in
    "stop")
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.gmusicbrowser /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop
        ;;
    "play")
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.gmusicbrowser /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
        ;;
    "next")
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.gmusicbrowser /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next
        ;;
    "prev")
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.gmusicbrowser /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous
        ;;
    "getTitle")
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.gmusicbrowser /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|egrep -A 1 "title"|egrep -v "title"|cut -b 44-|cut -d '"' -f 1|egrep -v ^$
        ;;
    "getArtist")
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.gmusicbrowser /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|egrep -A 2 "artist"|egrep -v "artist"|egrep -v "array"|cut -b 27-|cut -d '"' -f 1|egrep -v ^$
        ;;
    "getAlbum")
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.gmusicbrowser /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|egrep -A 2 "album"|egrep -v "album"|egrep -v "array"|cut -b 44-|cut -d '"' -f 1|egrep -v ^$
        ;;
    "getStatus")
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.gmusicbrowser /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus'|grep 'string "[^"]*"'|sed 's/.*"\(.*\)"[^"]*$/\1/'
        ;;
    "getArtUrl")
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.gmusicbrowser /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|egrep -A 2 "artUrl"|egrep -v "artUrl"|egrep -v "array"|cut -b 44-|cut -d '"' -f 1|egrep -v ^$
        ;;
    *)
        echo "Unknown command: " $1
	echo "$0 play|stop|next|prev|getTitle|getArtist|getAlbum|getStatus|getArtUrl"
        exit 2
        ;;
esac
exit 0
