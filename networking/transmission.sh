#!/bin/bash
#
# script to test cases for using arguments to control script behavior

# variable paths (set these as desired)
file_path=/files
movies=$file_path/movies/
tvshows=$file_path/tvshows/
music=$file_path/music/
games=$file_path/games/
bones=Bones\ \(2005\)\ \[720p\]/

# script variables
script_location=~/.scripts
file=$script_location/trackers.file

# test if transmission script has been run before


# script flags

while getopts "hm:t:u:rlk:a:g:zv:b:d" flag
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
			printf "\n   music default to:    \'$music\'"
			printf "\n   games default to:    \'$games\'\n"
			printf "\nThe script accepts the following arguments:"
			printf "\n	-h 	displays this help file"
			printf "\n	-a	adds the torrent link like normal \'transmission-remote -a\' command"
			printf "\n		with the default destination folder"
			printf "\n	-m	adds the torrent link to transmission and sets the folder as movies"
			printf "\n	-t	adds the torrent link for a tvshow"
			printf "\n	-u	adds the torrent link for a music-related link"
			printf "\n	-g	adds the torrent link for a game-related file"
			printf "\n	-k	adds trackers to the numbered torrents; i.e., 2; 1-5; 1,3,4"
			printf "\n	-l	lists the current torrent(s) status"
			printf "\n	-r	restarts the transmission-daemon.service if it is hanging"
			printf "\n	-z	displays the tranmission-remote help page"
			printf "\n	-v	verifies the torrent numbers specified; i.e., 2; 1-5; 1,3,4"
			printf "\n	-d	display downloading torrent status"
			printf "\nThe script supports adding magnet links as long as they are enclosed in quotation marks\
				\n	e.g. format: tr -flag \"<hyperlink>\"" 
			printf "\nto ensure proper processing.  [For best results enclose non-magnet links as well.]"
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
		u) # handle the -u flag with argument
			transmission-remote -a $OPTARG -w $music
			;;
		r)
			sudo systemctl restart transmission-daemon.service
			;;
		l)
			transmission-remote -l
			;;
		g) # handle the game flag
			transmission-remote -a $OPTARG -w $games
			;;
		z) # display transmission-remote help file
			transmission-remote -h | less
			;;
		v) # verifies torrents specified
			transmission-remote -t$OPTARG -v
			;;
		b) # argument for Bones tvshow torrents
			transmission-remote -a $OPTARG -w $tvshows$bones
			;;
		d) # display downloads shortcut
			transmission-remote -l | grep --color=auto 'Downloading'
			printf "TOTAL: " transmission-remote -l | grep 'Downloading' | wc -l
			;;
		\?) # handle invalid options
			echo "That option is not valid.  Please try again."
			;;
	esac
done	

