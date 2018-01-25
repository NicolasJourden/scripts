#!/bin/sh

TARGET="cryptBR"
FILE="image.iso"
LOOP=7

# Mount the image on the drive:
cryptsetup -r luksOpen /dev/sr0 $TARGET
mkdir -p /mnt/$TARGET
mount -t ext4 -o ro /dev/mapper/$TARGET /mnt/$TARGET

