#!/bin/bash# Automatic instalation script of $USERos - Void linux based operation system with dwm, st, ranger ... for personal use of Adam Krivka
# IMPORTANT: Make sure you run this script as the default user (you) and as 'sudo'

# ----------
echo "Cloning dotfiles from github. (probably already done)"
cd /home/$USER
sudo -u $USER git clone --depth 1 https://github.com/aidam38/$USERos_void /home/$USER &>/dev/null

# ----------
echo "Disabling services for obsolete ttys." 
cd /var/service
rm -f agetty-tty3 & rm -f agetty-tty4 & rm -f agetty-tty5 & rm -f agetty-tty6 &>/dev/null

# ----------
echo "Setting up automatic login, disabling grub os prober and changin the splash screen."
cp -R /home/$USER/.scripts/install/agetty-autologin-tty1 /etc/sv/ &>/dev/null
ln -s /etc/sv/agetty-autologin-tty1 /var/service 
rm /var/service/agetty-tty1 &>/dev/null

cp -f /home/$USER/.scripts/install/grub /etc/default/grub
update-grub &>/dev/null

# ----------
echo "Creating some basic directories in the /home/$USER folder"
cd /home/$USER
sudo -u $USER mkdir builds downloads

# ----------
echo "Allowing user to run reboot, poweroff and shutdown without password."
cp -f /home/$USER/.scripts/install/sudoers /etc/sudoers

# ----------
echo "Synchronizing the package system and installing basic programs"
cd /home/$USER
xbps-install -Suv &>/dev/null
while IFS=, read -r -u ';' program; do
	echo "(xbps) Installing " $program
	xbps-install -Sy $program &>/dev/null
done < /home/$USER/.scripts/install/programs;

# Installing dwm, st and dmenu from git repositories (some programs are my own forks)

echo "Installing Dynamic Window Manager (dwm) from https://github.com/aidam38/dwm.git"
sudo -u $USER git clone https://github.com/aidam38/dwm.git
cd dwm
sudo make clean install

cd ..

echo "Installing Simple Terminal (st) from https://github.com/aidam38/st.git"
sudo -u $USER git clone https://github.com/aidam38/st.git
cd st
sudo make clean install

cd ..

echo "Installing dmenu from git.suckless.org/dmenu"
sudo -u $USER git clone git://git.suckless.org/dmenu
cd dmenu
sudo make clean install

echo "Installing suckless pomodoro timer (spt) from https://github.com/pickfire/spt.git"
sudo -u $USER git clone https://github.com/pickfire/spt.git
cd spt
sudo make clean install

# ----------
echo "Linking user configs of bash, lf and vim to system-wide configs, so when run as root, you get the same keybinds and stuff."
rm -f /root/.bashrc
sudo ln -sf /home/$USER/.bashrc /root/.bashrc
sudo ln -sf /home/$USER/.config/nvim/init.vim /usr/share/nvim sysinit.vim
sudo ln -sf /home/$USER/.config/nvim/autoload/pathogen.vim /usr/share/nvim/autoload
sudo ln -sf /home/$USER/.config/lf /etc

cd /home/$USER
echo -e "%%%%%%%% \n ---Done!--- \n %%%%%%%%"
echo -e "You probably need to resolve following issues yourself: \n Graphics drivers"
