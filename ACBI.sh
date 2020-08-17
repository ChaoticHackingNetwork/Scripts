#!/bin/bash

# Arch Chroot BIOS Install (ACBI)
# ---------------------------------------------------------------
# Author    : Chaotic_Guru                                       |
# Github    : https://github.com/Chaotic-Lab                     |
#	            https://github.com/ChaoticHackingNetwork           |
# Discord   : https://discord.gg/nv445EX (ChaoticHackingNetwork) |
# ---------------------------------------------------------------

# Set locale to en_US.UTF-8 UTF-8
sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

#Set time & clock
timedatectl set-ntp true
hwclock --systohc --utc

#Change localtime *Note this script has it set too Chicago*
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime #CHANGE THIS TO YOUR TIMEZONE

#Install some needed packages
pacman -Syyu
pacman -S net-tools dhcpcd mlocate dnsutils zip ntfs-3g dialog wpa_supplicant sudo man-db vlc firefox gedit gedit-plugins flashplugin aria2 python3 python2 git wget curl grub netctl neofetch os-prober reflector rsync tar p7zip --noconfirm

#Set root password
echo -e "\033[33;36mPlease set ROOT password!!!\033[0m"
passwd

#Create a new user
read -p "Enter a new Username: " username
echo "Welcome to your new system $username!"
useradd -mg users -G wheel,power,storage,uucp,network -s /bin/bash $username
echo "Please set your password now!"
passwd $username

#Install MATE Desktop env and LightDM after reboot
pacman -S mate mate-extra mate-utils lightdm-gkt-greeter
systemctl enable lightdm-gtk-greeter

#Install bootloader
grub-install --target=i386-pc /dev/sda --recheck
grub-mkconfig -o /boot/grub/grub.cfg

#Successfully Installed
neofetch
echo "Arch Linux BIOS base has been successfully installed on your system..."
echo "A reboot should now take place"
echo "Run the following commands to reboot properly!"
echo
echo "  [1]: exit "
echo "  [2]: umount -a "
echo "  [3]: telinit 6 "

exit 
