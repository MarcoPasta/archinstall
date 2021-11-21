#!/bin/bash

# Ideen für todo
# fonts ändern, config .dotfiles kopieren

#get input for password
PASS="$1";
echo $PASS;
sleep 4; 


# creating partitions with stdin stream
#fdisk /dev/sda << EOF
#o
#n
#p
#
#
#
#a
#
#w
#EOF

# creating partitions for UEFI
sgdisk -Z --new=1:0:+300M --typecode=1:EF02 --new=2:0:0 --typecode=2:8300 /dev/sda


# creating ext4 format and mount;
# mkfs.ext4 /dev/sda1;
# mount /dev/sda1 /mnt;

# creating fs for UEFI
mkfs.fat -F 32 /dev/sda1 
mkfs.ext4 /dev/sda2 

# install base system;
pacstrap /mnt base base-devel linux linux-firmware dhcpcd nano networkmanager iwd << EOF
y
EOF

# creating fstab and chroot into new system
genfstab -U /mnt > /mnt/etc/fstab;
cp ./post_archinstall.sh /mnt/root/
arch-chroot /mnt /root/post_archinstall.sh $PASS

# nearly done
umount /mnt
echo "ready for reboot?"
sleep 4;
reboot


