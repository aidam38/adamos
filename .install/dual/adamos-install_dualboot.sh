#!/bin/bash
# Automatic instalation script of adamos - Arch linux based operation system with dwm, st, ranger ... for personal use of Adam Krivka
# IMPORTANT: Make sure you run this script as the root user.


# ----------
echo "Creating some basic directories in the /home/adam folder"
cd /home/adam
sudo -u adam mkdir builds downloads mount mount/usb mount/harddrive mount/android

# ----------
echo "Install yay (AUR wrapper)"

echo "Synchronizing the package system and installing basic programs"
cd /home/adam
sudo -u adam yay -Syu
while IFS=, read -r line; do
	program=($line)
	if [ -z "${program[1]}" ]; then 
		echo "----- (yay) Installing $program -----"
		yay -S --noconfirm $program
	elif [ -n "${program[1]}" ]; then
		cd /home/adam/builds
		echo "(git) Installing ${program[0]} from ${program[1]}"
		sudo -u adam git clone ${program[1]}
		cd ${program[0]}
		sudo make clean install
	fi
done < /home/adam/.install/dual/programs;


# ----------
echo "Linking user configs of bash, lf and vim to system-wide configs, so when run as root, you get the same keybinds and stuff."
rm -f /root/.bashrc
sudo ln -sf /home/adam/.bashrc /root/.bashrc
sudo ln -sf /home/adam/.config/nvim/init.vim /usr/share/nvim/sysinit.vim
sudo ln -sf /home/adam/.config/nvim/autoload/pathogen.vim /usr/share/nvim/autoload
sudo ln -sf /home/adam/.config/lf /etc

# ----------
cd /home/adam
echo -e "%%%%%%%% \n ---Done!--- \n %%%%%%%%"
echo -e "You probably need to resolve following issues yourself: \n Graphics drivers"
