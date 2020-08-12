#!/bin/bash

#This is ChaoticGuru's Arch Linux Scripted Install.
#Visit "https://github.com/ChaoticHackingNetwork/BasicScripts" for more info
#This is for BIOS systems...

echo "ChaoticGuru's Arch Linux BIOS Install"

#Network Connections
read -p 'Are you connected to the Internet? [y/N]: ' connected
if ! [ $connected = 'y' ] && ! [ $connected = 'Y' ]
then
	echo "Please connect to the Internet to continue..."
	exit
fi

#Mounting the File System Warning!
echo "This script will create and format the following partitions:"
echo "/dev/sda1 - 512M will be mounted as /boot"
echo "/dev/sda2 - 16G will be used as SWAP"
echo "/dev/sda3 - rest of space will be /mnt"
read -p 'Continue? [y/N]: ' part
if ! [ $part = 'y' ] && ! [ $part = 'Y' ]
then
	echo "Please edit the script to continue..."
	exit
fi

#Create partitions thru fdisk...
#https://superuser.com/a/984637
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
	o # Clear the in-memory partition table
	n # New partition
	p # Primary partition
	1 # First partition
		# default - start at beginning of disk
	+512M # 512 MB Boot partition
	n 
	p
	2
		# default, start immediately after preceding partition
	+16GB # swap space
	n
	p
	3
		# default, start immediately after preceding partition
		# default, use rest of disk space
	p # print the in-memory table
	w # write changes to disk
	q # quit
EOF

#Format partitions
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda3

#Create swap space
mkswap /dev/sda2
swapon /dev/sda2

#Mount partitions
mount /dev/sda3 /mnt
mount /dev/sda1 /mnt/boot

#Display new tables and confirm
lsblk
echo "Are the mount points labled and correct?"
read -p 'Continue? [Y/n]' confirm
if ! [ $confirm = 'y' ] && ! [ $confirm = 'Y' ]
then 
	echo "Please edit the script to continue..."
	exit
fi

#Initialize Pacman
pacman-key --init
pacman-key --populate archlinux
pacman-key --refresh-keys

#Install base system
pacstrap /mnt base base-devel linux linux-firmware vi vim nano

#Generate fstab
genfstab -U -p /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

echo 0 > /proc/sys/kernel/hung_task_timeout_secs
echo "You will now chroot into your new system : arch-chroot /mnt"
echo "*** Ensure you download the chrootInstall.sh from https://raw.githubusercontent.com/ChaoticHackingNetwork ***"
echo "You can use wget or curl or whatever your prefer"
echo "Run the command: arch-chroot /mnt and then install the chrootInstall script"


exit
