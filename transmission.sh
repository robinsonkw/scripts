#!/bin/bash
#
# script to test cases for using arguments to control script behavior

# variable paths (set these as desired)
file_path=/files
movies=$file_path/movies/
tvshows=$file_path/tvshows/
music=$file_path/music/
games=$file_path/games/

# script variables
script_location=~/.scripts
file=$script_location/trackers.file

# test if transmission script has been run before


# script flags

while getopts "hm:t:mu:rlk:a:" flag
do
	case $flag in
		h) # handle the -h flag
		# Display script help information
			printf "This is the help line for the transmmission script.
				\nThis script works to simplify adding torrent links in the argument line to"
			printf "\nthe appropriate folder as its final destination."
			printf "\n\nThe following locations are defined:"
			printf "\n   movies default to:   \'$movies\'"
			printf "\n   tvshows default to:  \'$tvshows\'"
			printf "\n   music default to:    \'$music\'\n"
			printf "\nThe script accepts the following arguments:"
			printf "\n	-h 	displays this help file"
			printf "\n	-a	adds the torrent link like normal \'transmission-remote -a\' command"
			printf "\n		with the default destination folder"
			printf "\n	-m	adds the torrent link to transmission and sets the folder as movies"
			printf "\n	-t	adds the torrent link for a tvshow"
			printf "\n	-mu	adds the torrent link for a music-related link"
			printf "\n	-k	adds trackers to the numbered torrents"
			printf "\n	-l	lists the current torrent(s) status"
			printf "\n	-r	restarts the transmission-daemon.service if it is hanging"
			printf "\nThe script supports adding magnet links as long as they are enclosed in quotation marks\
				\n\"<hyperlink>\" to ensure proper processing."
			printf "\n\nNOTE: Some of these commands could conflict with actual transmission-remote commands.\
				\nso be careful and use at your own risk!\
				\n"
			;;
		m) # handle the -m flag with argument
			transmission-remote -a $OPTARG -w $movies
			;;
		t) # handle the -tv flag with arugument
			transmission-remote -a $OPTARG -w $tvshows
			;;
		a) # add link like normal
			transmission-remote -a $OPTARG
			;;
		k) # add trackers to the listed torrents
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

