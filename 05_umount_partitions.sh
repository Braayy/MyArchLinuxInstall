#!/bin/bash

if [ -z "$MOUNTED_ROOT_DIRECTORY" ]; then
	read -p "Mounted Root Directory: " MOUNTED_ROOT_DIRECTORY
fi

if [ -z "$EFI_CHROOT_DIRECTORY" ]; then
  read -p "EFI Chroot Directory: " EFI_CHROOT_DIRECTORY
fi

umount -R "$MOUNTED_ROOT_DIRECTORY/$EFI_CHROOT_DIRECTORY"
umount -R "$MOUNTED_ROOT_DIRECTORY"
