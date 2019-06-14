#!/bin/bash
# Automatic instalation script of adamos - Void linux based operation system with dwm, st, ranger ... for personal use of Adam Krivka
# IMPORTANT: Make sure you run this script as the default user (you) and as 'sudo'

echo "By now you should have done the following things: 
- formatted your partitions
- mounted your partitions (/dev/sda3 to /mnt and /dev/sda4 to /mnt/home)
- be in root (not in /mnt root)
"

read -p "Continue?" yn
if [[ $yn == "Nn*" ]]; then
	exit
fi

echo "Setting up Arch Linux"
pacstrap /mnt base
timedatectl set-ntp true
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
ln -sf /usr/share/zoneinfo/Europe/Prague /etc/localtime
hwclock --systohc
sed "s/#en_US.UTF-8\sUTF-8\en_US.UTF-8 UTF-8/" /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF8" >> /etc/locale.conf
echo "KEYMAP=cz-qwert" >> /etc/vconsole.conf
read -p "Add hostname: " hostname
hostnamectl set-hostname $hostname
echo "Enter root password"
passwd
read -p "Enter normal user username: " username
useradd -m -g users -G wheel,storage,power,users -s /bin/bash $username
echo "Enter $username's password."
passwd $username

# ----------
echo "Cloning dotfiles from github. (probably already done)"
cd /home/adam
sudo -u adam git clone --depth 1 https://github.com/aidam38/adamos /home/adam &>/dev/null

# ----------
echo "Creating some basic directories in the /home/adam folder"
cd /home/adam
sudo -u adam mkdir builds downloads

# ----------

# ----------
echo "Install yay (AUR wrapper)"

pacman -Sy base base-devel
cd builds
git clone https://aur.archlinux.org/yay.git
cd yay 
makepkg -si

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
done < /home/adam/.install/programs;

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
cp -f /home/adam/.install/sudoers /etc/sudoers

# ----------
echo "Disabling grub os prober and changing the splash screen."
cp -f /home/adam/.install/grub /etc/default/grub
update-grub &>/dev/null

# ----------
echo "Setting up automatic login."
cp -R /home/adam/.install/agetty-autologin-tty1 /etc/sv/ &>/dev/null
ln -s /etc/sv/agetty-autologin-tty1 /var/service 
rm /var/service/agetty-tty1 &>/dev/null

# ----------
cd /home/adam
echo -e "%%%%%%%% \n ---Done!--- \n %%%%%%%%"
echo -e "You probably need to resolve following issues yourself: \n Graphics drivers"
