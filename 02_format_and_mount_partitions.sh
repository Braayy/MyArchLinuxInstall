#!/bin/bash

read -p "Device: " DEVICE_PATH

fdisk $DEVICE_PATH

if [ -z "$USING_DEFAULT_LAYOUT" ]; then
	read -p "Default Layout? (y/n)" USING_DEFAULT_LAYOUT
fi

if [ $USING_DEFAULT_LAYOUT = "y" ]; then
  read -p "EFI Partition: " EFI_PARTITION
  read -p "Swap Partition: " SWAP_PARTITION
  read -p "Root Partition: " ROOT_PARTITION

	echo "Formatting EFI Partition"
	mkfs.fat -F 32 $EFI_PARTITION
	echo "Formatting Swap Partition"
	mkswap $SWAP_PARTITION
	echo "Formatting Root Partition"
	mkfs.ext4 $ROOT_PARTITION

	MOUNTED_ROOT_DIRECTORY="/mnt"
	EFI_CHROOT_DIRECTORY="/boot"

	echo "Mounting partitions"
	mount --mkdir $ROOT_PARTITION "$MOUNTED_ROOT_DIRECTORY"
	mount --mkdir $EFI_PARTITION "$MOUNTED_ROOT_DIRECTORY/$EFI_CHROOT_DIRECTORY"
	swapon $SWAP_PARTITION
else
	echo "Exiting current script so you can format the partitions!"
	echo "After formatting and mounting them, execute ./install_packages.sh"
	exit
fi