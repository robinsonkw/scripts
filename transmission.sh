#!/bin/bash
#
# script to test cases for using arguments to control script behavior

# variable paths (set these as desired)
movies=/files/movies/
tvshows=/files/tvshows/
music=/files/music/
games=/files/games/

# script variables
script_location=~/.scripts
file=$script_location/trackers.file

# test if transmission script has been run before


# script flags

while getopts "hm:tv:mu:rlt:" flag
do
	case $flag in
		h) # handle the -h flag
		# Display script help information
			printf "\nThis is the help line for the transmmission script.  This script works to simplify adding\
				\ntorrent links in the argument line to the appropriate folder as its final destination."
			printf "\nThe script accepts the following arguments:"
			printf "\n	-h = displays this help file"
			printf "\n	-m = adds the torrent link to transmission and sets the folder as movies"
			printf "\n	-tv = does the same for a tvshow"
			printf "\n	-mu = does the same for the music-related link"
			printf "\n	-t = adds trackers to the numbered torrents"
			printf "\n	-l = lists the current torrent(s) status"
			printf "\n	-r = restarts the transmission-daemon.service if it is hanging"
			printf "\nThe script supports adding magnet links as long as they are encloses in quotation marks\
				\nto ensure proper processing."
			printf "\n\nNOTE: Some of these commands could conflict with actual transmission-remote commands.\
				\nso be careful and use at your own risk!\
				\n"
			;;
		m) # handle the -m flag with argument
			transmission-remote -a $OPTARG -w $movies
			;;
		tv) # handle the -tv flag with arugument
			transmission-remote -a $OPTARG -w $tvshows
			;;
		t) # add trackers to the listed torrents
			while read f
			do
				transmission-remote -t[$OPTARG] -td "$f"
			done <$file
			clear
			;;
		mu) # handle the -mu flag with argument
			transmission-remote -a $OPTARG -w $music
			;;
		r)
			sudo systemctl restart transmission-daemon.service
			;;
		l)
			transmission-remote -l
			;;
		\?) # handle invaalid options
			echo "That option is not valid.  Please try again."
			;;
	esac
done	

