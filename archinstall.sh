#!/bin/sh
echo "#\n#\n#creating partition\n#\n#\n";
fdisk /dev/sda << EOF
n
p



a

w
EOF;
sleep 10;
echo "#\n#\n#creating ext4 format\n#\n#\n"
mkfs.ext4 /dev/sda1 << y;
sleep 10;
echo "#\n#\n#mounting system\n#\n#\n"
mount /dev/sda /mnt;
sleep 10;
echo "#\n#\n#calling pacstrap to install base system\n#\n#\n";
pacstrap /mnt base base-devel linux linux-firmware dhcpcd nano vim networkmanager intel-ucode iwd;

