#!/bin/bash
# Automatic instalation script of adamos - Void linux based operation system with dwm, st, ranger ... for personal use of Adam Krivka
# IMPORTANT: Make sure you run this script as the default user (you) and as 'sudo'

# ----------
echo "Cloning dotfiles from github. (probably already done)"
cd /home/adam
sudo -u adam git clone --depth 1 https://github.com/aidam38/adamos_void /home/adam &>/dev/null

# ----------
echo "Creating some basic directories in the /home/adam folder"
cd /home/adam
sudo -u adam mkdir builds downloads

# ----------
echo "Synchronizing the package system and installing basic programs"
cd /home/adam
xbps-install -Suv &>/dev/null
while IFS=, read -r line; do
	program=($line)
	if [ -z "${program[1]}" ]; then 
		echo "(xbps) Installing $program"
		xbps-install -Sy $program &>/dev/null
	elif [ -n "${program[1]}" ]; then
		cd /home/adam/builds
		echo "(git) Installing ${program[0]} from ${program[1]}"
		sudo -u adam git clone ${program[1]}
		cd ${program[0]}
		sudo make clean install
	fi
done < /home/adam/.scripts/install/programs;

# ----------
echo "Linking user configs of bash, lf and vim to system-wide configs, so when run as root, you get the same keybinds and stuff."
rm -f /root/.bashrc
sudo ln -sf /home/adam/.bashrc /root/.bashrc
sudo ln -sf /home/adam/.config/nvim/init.vim /usr/share/nvim/sysinit.vim
sudo ln -sf /home/adam/.config/nvim/autoload/pathogen.vim /usr/share/nvim/autoload
sudo ln -sf /home/adam/.config/lf /etc

# ----------
echo "Disabling services for obsolete ttys." 
cd /var/service
rm -f agetty-tty3 & rm -f agetty-tty4 & rm -f agetty-tty5 & rm -f agetty-tty6 &>/dev/null

# ----------
echo "Allowing user to run reboot, poweroff and shutdown without password."
cp -f /home/adam/.scripts/install/sudoers /etc/sudoers

# ----------
echo "Disabling grub os prober and changing the splash screen."
cp -f /home/adam/.scripts/install/grub /etc/default/grub
update-grub &>/dev/null

# ----------
echo "Setting up automatic login."
cp -R /home/adam/.scripts/install/agetty-autologin-tty1 /etc/sv/ &>/dev/null
ln -s /etc/sv/agetty-autologin-tty1 /var/service 
rm /var/service/agetty-tty1 &>/dev/null

# ----------
cd /home/adam
echo -e "%%%%%%%% \n ---Done!--- \n %%%%%%%%"
echo -e "You probably need to resolve following issues yourself: \n Graphics drivers"
