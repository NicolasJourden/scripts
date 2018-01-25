#!/bin/sh

TARGET="cryptBR"
FILE="image.iso"
LOOP=7

losetup /dev/loop$LOOP $FILE
cryptsetup -r luksOpen /dev/loop$LOOP $TARGET
mkdir -p /mnt/$TARGET
mount -t ext4 -o ro /dev/mapper/volume1 /mnt/$TARGET
