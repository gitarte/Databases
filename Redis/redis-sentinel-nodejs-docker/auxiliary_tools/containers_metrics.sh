#!/bin/bash
trap "exit" INT
clear
START=1

while true
do 
	salt 'node*' cmd.run 'docker stats $(docker ps --format={{.Names}} | sort) --no-stream' > values

	END=$(cat values | wc -l)
	for (( c=$START; c<=$END; c++ ))
	do
		tput cuu1 # move cursor up by one line
		tput el # clear the line
	done
	cat values
done
