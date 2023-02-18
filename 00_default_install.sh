#!/bin/bash

USING_DEFAULT_LAYOUT="y"

source ./01_set_keyboard_layout.sh
source ./02_format_and_mount_partitions.sh
source ./03_install_packages.sh
source ./04_configure.sh
source ./05_umount_partitions.sh

echo "Installation Done!"
echo "Maybe you will need to create an UEFI entry for GRUB, if GRUB didnt"
