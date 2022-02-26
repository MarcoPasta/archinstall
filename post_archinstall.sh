#!/bin/bash

#get password from the other file 
PASS="$1";
echo $PASS;
# sleep 4;

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
# BIOS 
pacman -S --noconfirm grub;
# UEFI
# pacman -S --noconfirm grub efibootmgr;

# mkdir -p /boot/efi

# install grub for BIOS 
grub-install --recheck /dev/sda;
sleep 4;
# install grub for UEFI
# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removable;


# make config 
grub-mkconfig -o /boot/grub/grub.cfg;

# automatically put user into the sudoers file 
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers;

# install for T540p with Cinnamon
#pacman -S --noconfirm cinnamon gdm gedit alacritty kitty git wget vim okular vlc geeqie \
#flameshot vivaldi vivaldi-ffmpeg-codecs firefox bluez blueberry \
#chromium pcmanfm thunderbird libreoffice bitwarden xournalpp neofetch redshift \
#intel-ucode ufw

# install for T540p with Gnome
pacman -S --noconfirm gnome gnome-extras gdm alacritty kitty git wget vim vlc flameshot \
vivaldi vivaldi-ffmpeg-codecs firefox chromium thunderbird libreoffice bitwarden neofetch redshift \
i# ntel-ucode ufw

# install for workstation with Plasma
# pacman -S --noconfirm alacritty kitty git wget vim okular vlc geeqie \
# flameshot vivaldi vivaldi-ffmpeg-codecs firefox chromium thunderbird \
# bitwarden xournalpp neofetch redshift intel-ucode plasma-meta sddm \
# nautilus konsole ;



# enable system services on boot 
systemctl enable gdm;     
# systemctl enable sddm;
systemctl enable NetworkManager;
# systemctl enable bluetooth;
sleep 4;
