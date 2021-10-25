#!/bin/sh
echo "creating partition";
sleep 2;
fdisk /dev/sda << EOF
o
n
p



a

w
EOF
sleep 4;
echo "creating ext4 format";
mkfs.ext4 /dev/sda1;
sleep 4;
echo "mounting system";
mount /dev/sda1 /mnt;
echo "mounting successful";
sleep 4;
echo "calling pacstrap to install base system";
pacstrap /mnt base base-devel linux linux-firmware dhcpcd nano vim networkmanager iwd << EOF
y
EOF
sleep 2;
echo "generating fstab file";
sleep 1;
genfstab -U /mnt > /mnt/etc/fstab;
sleep 1;
echo "chrooting into new system";
arch-chroot /mnt << "EOT"
echo arch > /etc/hostname;
echo LANG=de_DE.UTF-8 > /etc/locale.conf;
sed --in-place=.bak 's/^#de_DE\.UTF-8/de_DE\.UTF-8/' /etc/locale.gen;
locale-gen;
echo KEYMAP=de-latin1 > /etc/vconsole.conf;
echo FONT=lat9w-16 >> /etc/vconsole.conf;
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime;
mkinitcpio -p linux;
pacman -S --noconfirm grub;
grub-install --recheck /dev/sda;
grub-mkconfig -o /boot/grub/grub.cfg;
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers;
EOT
umount /mnt
echo "ready for reboot?"
sleep 4;
reboot


