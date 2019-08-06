#!/bin/bash
# Automatic instalation script of adamos - Arch linux based operation system with dwm, st, ranger ... for personal use of Adam Krivka
# IMPORTANT: Make sure you run this script as the root user.

echo "By now you should have done the following things:
- partitioned your hard drive
	/dev/sda1 bootable (512M)
	/dev/sda2 swap (around 2G)
	/dev/sda3 /mnt (around 30G)
	/dev/sda4 /mnt/home (the rest)
- formatted your partitions
	mkfs.ext3 /dev/sda3
	mkfs.ext4 /dev/sda4
	mkswap /dev/sda2
- mounted your partitions (/dev/sda3 to /mnt and /dev/sda4 to /mnt/home)
	swapon /dev/sda2
	mount /dev/sda3 /mnt
	mkdir /mnt/home
	mount /dev/sda4 /mnt/home
- connected to the internet
- be in root (not in /mnt root)
"

read -p "Continue?" yn
if [[ $yn == "Nn*" ]]; then
	exit
fi

read -p "Do the first part?" part
if [[ part == "y" ]]; then

echo "Setting up Arch Linux"

genfstab -U /mnt >> /mnt/etc/fstab

pacstrap /mnt base base-devel

arch-chroot /mnt

pacman -Syu grub git neovim kakoune wpa_supplicant
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

echo "Enter root password"
passwd

read -p "Enter normal user username: " username
useradd -m -g users -G wheel,storage,power,users -s /bin/bash $username
echo "Enter $username's password."
passwd $username

fi

# ----------
echo "Allowing user to run reboot, poweroff and shutdown without password."
cp -f sudoers /etc/sudoers

# ----------
echo "Disabling grub os prober and changing the splash screen."
cp -f grub /etc/default/grub
update-grub

# ----------
echo "Setting up automatic login."
cp autologin@.service /etc/systemd/system/autologin@.service
rm -f /etc/systemd/system/getty.target.wants/getty@tty1.service
ln -s /etc/systemd/system/autologin@.service /etc/systemd/system/getty.target.wants/getty@tty1.service

# ----------
echo "Timezones, clocks, locales, layouts, hostname"
ln -sf /usr/share/zoneinfo/Europe/Prague /etc/localtime
timedatectl set-ntp true
hwclock --systohc
sed "s/#en_US.UTF-8\sUTF-8\en_US.UTF-8 UTF-8//" /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF8" >> /etc/locale.conf
echo "KEYMAP=cz-qwertz" >> /etc/vconsole.conf
read -p "Add hostname: " hostname
hostnamectl set-hostname $hostname

# ----------
echo "Cloning dotfiles from github. (probably already done)"
cd /home/adam
rm -fr *
rm -fr .*
sudo -u adam git clone --depth 1 https://github.com/aidam38/adamos /home/adam

# ----------
echo "Creating some basic directories in the /home/adam folder"
cd /home/adam
sudo -u adam mkdir builds downloads

# ----------

# ----------
echo "Install yay (AUR wrapper)"

pacman -Sy base base-devel
cd builds
sudo -u adam git clone https://aur.archlinux.org/yay.git
cd yay 
sudo -u adam makepkg -si

echo "Synchronizing the package system and installing basic programs"
cd /home/adam
sudo -u adam yay -Syu
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
