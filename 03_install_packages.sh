#!/bin/bash

MIRROR_COUNTRIES="AR,AU,BR,CA,CO,EC,DE,JP,MX,PY,KR,GB,US,"
MIRROR_COUNT=50

echo "Fetching and sorting known arch linux mirrors"
reflector --completion-percent 100 -p "https,http,ftp" --threads 4 -f $MIRROR_COUNT -c $MIRROR_COUNTRIES --save /etc/pacman.d/mirrorlist

if [ -z "$MOUNTED_ROOT_DIRECTORY" ]; then
	read -p "Mounted Root Directory: " MOUNTED_ROOT_DIRECTORY
fi

echo "Installing packages at $MOUNTED_ROOT_DIRECTORY"
pacstrap -K $MOUNTED_ROOT_DIRECTORY \
base \
linux \
linux-zen \
linux-firmware \
helix \
firefox \
keepassxc \
pipewire \
pipewire-alsa \
pipewire-pulse \
pipewire-jack \
networkmanager \
gnome \
gnome-tweaks \
libreoffice-fresh \
homebank \
rclone \
vlc \
variety \
dconf-editor \
grub \
grub-customizer \
efibootmgr \
doas \
which \
wget \
openbsd-netcat \
git \
cups \
bluez \
fakeroot \
make