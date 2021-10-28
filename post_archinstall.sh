#!/bin/bash

#get password from the other file 
PASS="$1";
echo $PASS;
sleep 4;

# create locales
echo arch > /etc/hostname;
echo LANG=de_DE.UTF-8 > /etc/locale.conf;
sed --in-place=.bak 's/^#de_DE\.UTF-8/de_DE\.UTF-8/' /etc/locale.gen;
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime;
locale-gen;

# set keyboard layout
echo KEYMAP=de-latin1 > /etc/vconsole.conf;
echo FONT=lat9w-16 >> /etc/vconsole.conf;

# create root pw, user and user pw
echo "root:$PASS" | chpasswd;
useradd -mG wheel -s /bin/bash luca;
echo "luca:$PASS" | chpasswd;

# create init system / kernel & install grub 
mkinitcpio -p linux;
pacman -S --noconfirm grub;
grub-install --recheck /dev/sda;
grub-mkconfig -o /boot/grub/grub.cfg;

# automatically put user into the sudoers file 
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers;

# install additional packages
pacman -S --noconfirm cinnamon gdm gedit alacritty git wget vim okular vlc geeqie \
flameshot network-manager-applet vivaldi vivaldi-ffmpeg-codecs bluez blueberry \
chromium pcmanfm thunderbird libreoffice bitwarden xournalpp neofetch redshift \
intel-ucode ufw

# enable system services on boot 
systemctl enable gdm;
systemctl enable NetworkManager;
systemctl enable bluetooth;
ufw enable 
ufw status 
sleep 4;