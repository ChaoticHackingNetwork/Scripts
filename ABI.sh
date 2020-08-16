#!/bin/bash

# Arch Bios Install (ABI)
# ---------------------------------------------------------------
# Author    : ChaoticGuru                                        |
# Github    : https://github.com/Chaotic-Lab                     |
#	      https://github.com/ChaoticHackingNetwork           |
# Discord   : https://discord.gg/nv445EX (ChaoticHackingNetwork) |
# ---------------------------------------------------------------

echo -e "\033[33;36mChaoticGuru's Arch Linux BIOS Install\033[0m"

#Network Connections
read -p 'Are you connected to the Internet? [y/N]: ' connected
if ! [ $connected = 'y' ] && ! [ $connected = 'Y' ]
then
	echo "Please connect to the Internet to continue..."
	exit
fi

#Mounting the File System Warning!
echo "This script will create and format the following partitions:"
echo
echo "--------- /dev/sda1 - 16G will be mounted as SWAP space ------------"
echo "--------- /dev/sda2 - Rest of space will be mounted as / -----------"
echo "Exit now if this is not correct!!!"
echo
read -p 'Continue? [y/N]: ' partition
if ! [ $partition = 'y' ] && ! [ $partition = 'Y' ]
then
	echo "Please edit the script to continue..."
	exit
fi

#Create partitions thru fdisk...
#https://superuser.com/a/984637
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda # CHANGE THIS IF NEEDED!!!
	o # Clear the in-memory partition table
	n # New partition
	p # Primary partition
	1 # First partition
		# SWAP - start at beginning of disk
	+16G # swap space
	n 
	p
	2
		# ROOT, start immediately after preceding partition
		# default, use rest of disk space
	p # print the in-memory table
	w # write changes to disk
	q # quit
		
EOF

#Format partitions
mkfs.ext4 /dev/sda2

#Mount partitions
mount /dev/sda2 /mnt

#Create swap space
mkswap /dev/sda1
swapon /dev/sda1

#Display new tables and confirm
lsblk
echo "Are the mount points correct?"
read -p 'Continue? [Y/n]' confirm
if ! [ $confirm = 'y' ] && ! [ $confirm = 'Y' ]
then 
	echo "Please edit the script to continue..."
	exit
fi

#Initialize Pacman
pacman-key --init
pacman-key --populate archlinux
#pacman-key --refresh-keys

#Install base system
pacstrap /mnt base base-devel linux linux-firmware

#Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

#Finish last minute setup
echo 0 > /proc/sys/kernel/hung_task_timeout_secs
wget https://raw.githubusercontent.com/Chaotic-Lab/Arch-Linux/master/ACBI.sh
mv ACBI.sh /mnt
echo "The next script (ACBI.sh) has been moved to your new root directory..."
echo "Run the following commands to finish setup..."
echo 
echo "	[1] arch-chroot /mnt /bin/bash"
echo "	[2] chmod +x ACBI.sh"
echo "  [3] ./ACBI.sh"

exit
