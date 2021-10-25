#!/bin/sh

echo "creating partition";
fdisk /dev/sda << EOF
o
n
p



a

w
EOF


echo "creating ext4 format";
mkfs.ext4 /dev/sda1;

echo "mounting system";
mount /dev/sda1 /mnt;

echo "mounting successful";

echo "calling pacstrap to install base system";
pacstrap /mnt base base-devel linux linux-firmware dhcpcd nano vim networkmanager iwd << EOF
y
EOF

echo "generating fstab file";
genfstab -U /mnt > /mnt/etc/fstab;

echo "chrooting into new system";
arch-chroot /mnt << "EOT"
PASS=""
echo arch > /etc/hostname;
echo LANG=de_DE.UTF-8 > /etc/locale.conf;
sed --in-place=.bak 's/^#de_DE\.UTF-8/de_DE\.UTF-8/' /etc/locale.gen;
locale-gen;
echo KEYMAP=de-latin1 > /etc/vconsole.conf;
echo FONT=lat9w-16 >> /etc/vconsole.conf;
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime;
sleep 1;
echo "root:$PASS" | chpasswd;
useradd -mG wheel -s /bin/bash luca;
sleep 1;
echo "luca:$PASS" | chpasswd;
mkinitcpio -p linux;
pacman -S --noconfirm grub;
grub-install --recheck /dev/sda;
grub-mkconfig -o /boot/grub/grub.cfg;
#echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers;
pacman -S --noconfirm cinnamon gdm gedit alacritty git wget vim okular vlc geeqie flameshot network-manager-applet
systemctl enable gdm;
systemctl enable NetworkManager;

EOT

# nearly done
umount /mnt
echo "ready for reboot?"
sleep 4;
reboot


