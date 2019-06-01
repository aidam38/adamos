#!/bin/bash
while IFS=, read -r line; do
	program=($line)
	if [ -z "${program[1]}" ]; then 
		echo "(yay) Installing $program"
		yay -S --noconfirm $program 
		read
	elif [ -n "${program[1]}" ]; then
		cd /home/adam/builds
		echo "(git) Installing ${program[0]} from ${program[1]}"
		sudo -u adam git clone ${program[1]}
		cd ${program[0]}
		sudo make clean install
	fi
done < /home/adam/.install/programs;
