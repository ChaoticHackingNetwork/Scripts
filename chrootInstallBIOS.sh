#!/bin/bash

#Chroot Install - ChaoticGuru
#Quick installation of key components 

#Set time & clock
timedatectl set-ntp true
hwclock --systohc --utc

#Change localtime *Note this script has it set too Chicago*
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime

# Set locale to en_US.UTF-8 UTF-8
sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

#Install some needed packages
pacman -Syyu
pacman -S net-tools dhcpcd mlocate dnsutils zip ntfs-3g dialog wpa_supplicant sudo python3 python2 git wget curl grub efibootmgr dosfstools mtools os-prober reflector --noconfirm

#Set root password
echo "Please set ROOT password!!!"
passwd

#Create a new user
echo -n "Enter a new Username: "
read username
useradd -mg users -G wheel,power,storage,uucp,network -s /bin/bash $username
echo "Please set your password now!"
passwd $username

#Install bootloader
grub-install --target=i386-pc /dev/sda --recheck
grub-mkconfig -o /boot/grub/grub.cfg

#Successfully Installed
echo "Arch Linux UEFI base has been successfully installed on your system..."
echo "A reboot should now take place"
echo "Run the following commands to reboot properly!"
echo
echo "  [1]: exit "
echo "  [2]: umount -a "
echo "  [3]: telinit 6 "

exit
