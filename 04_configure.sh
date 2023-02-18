#!/bin/bash

if [ -z "$MOUNTED_ROOT_DIRECTORY" ]; then
	read -p "Mounted Root Directory: " MOUNTED_ROOT_DIRECTORY
fi

if [ -z "$EFI_CHROOT_DIRECTORY" ]; then
	read -p "EFI Chroot Directory: " EFI_CHROOT_DIRECTORY
fi

read -p "Network Hostname: " NETWORK_HOSTNAME
read -p "AUR Packages: " AUR_PACKAGES
read -p "Username: " USERNAME
read -p "Password: " PASSWORD

echo "Generating /etc/fstab to $MOUNTED_ROOT_DIRECTORY/etc/fstab"
genfstab -U "$MOUNTED_ROOT_DIRECTORY" >> "$MOUNTED_ROOT_DIRECTORY/etc/fstab"

chroot() {
	echo "$1"
}

aur() {
	echo "git clone https://aur.archlinux.org/$1.git && cd $1 && makepkg -sirc --noconfirm"
	echo "cd .."
	echo "rm -rdf $1"
}

{
	chroot "systemctl enable gdm"
	chroot "systemctl enable NetworkManager"
	chroot "systemctl enable cups"
	chroot "systemctl enable bluetooth"

	chroot "ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime"
	chroot "hwclock --systohc"

	chroot "echo \"pt_BR.UTF-8 UTF-8\" >> /etc/locale.gen"
	chroot "echo \"LANG=pt_BR.UTF-8\" > /etc/locale.conf"
	chroot "locale-gen"

	chroot "echo \"KEYMAP=br-abnt2\" > /etc/vconsole.conf"

	chroot "echo \"$NETWORK_HOSTNAME\" > /etc/hostname"

	chroot "useradd -m -G wheel \"$USERNAME\""

	chroot "echo \"permit persist :wheel\" > /etc/doas.conf"
	chroot "chmod -c 0400 /etc/doas.conf"
	chroot "echo \"PACMAN_AUTH=(doas)\" >> /etc/makepkg.conf"

	chroot "su \"$USERNAME\""
	chroot "cd ~"
	aur "libpamac-aur"
	aur "pamac-aur"
	aur "yay"
	aur "adw-gtk3"
	for package in $AUR_PACKAGES; do
		aur "$package"
	done
	chroot "exit"

	chroot "grub-install --target=x86_64-efi --efi-directory=\"$EFI_CHROOT_DIRECTORY\" --bootloader-id=GRUB"
	chroot "grub-mkconfig -o \"$EFI_CHROOT_DIRECTORY/grub/grub.cfg\""
} | arch-chroot "$MOUNTED_ROOT_DIRECTORY"

cat ".bashrc" > "$MOUNTED_ROOT_DIRECTORY/home/$USERNAME/.bashrc"

PASSWD_INPUT=$(echo -e "$PASSWORD\n$PASSWORD\n")
passwd -R "$MOUNTED_ROOT_DIRECTORY" "$USERNAME" <<< "$PASSWD_INPUT"
