#!/bin/bash

#This is ChaoticGuru's Arch Linux Scripted Install.
#Visit "https://github.com/ChaoticHackingNetwork/BasicScripts/" for more info
# BIOS systems install...

echo -e "\033[33;7mChaoticGuru's Arch Linux BIOS Install\033[0m"

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
echo "--------- /dev/sda1 - 512M will be mounted as /boot ------------"
echo "--------- /dev/sda2 - 16G will be used as SWAP space -----------"
echo "--------- /dev/sda3 - rest of space will be /mnt(root) ---------"
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
wget https://raw.githubusercontent.com/ChaoticHackingNetwork/BasicScripts/master/chrootInstallBIOS.sh
mv chrootInstallBIOS.sh /mnt
echo "The next script (chrootInstallBIOS.sh) has been moved to your new root directory..."
#echo "Run the following commands to finish setup..."
#echo 
#echo "	 [1] arch-chroot /mnt /bin/bash"
#echo "	 [2] chmod +x chrootInstallBIOS.sh"
#echo "  [3] ./chrootInstallBIOS.sh"

#Chroot
echo "We will now Chroot into your new system and finish up installation"
read -p 'Continue? [Y/n]' confirm
if ! [ $confirm = 'y' ] && ! [ $confirm = 'Y' ]
then 
	echo "Please edit the script to continue..."
	exit
fi
arch-chroot /mnt /bin/bash

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
read -p "Enter a new Username: " username
echo "Welcome to your new system $username!"
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
