#!/bin/sh

TARGET="cryptBR"
FILE="image.iso"
LOOP=7

# Prepare image:
truncate -s 23500M $FILE
ls -alh $FILE
losetup /dev/loop$LOOP $FILE
echo "Creating the luks file system ... "
cryptsetup luksFormat /dev/loop$LOOP

# Open the image:
cryptsetup luksOpen /dev/loop$LOOP $TARGET

# Create the FS:
mkfs.ext4 /dev/mapper/$TARGET

# Mount:
mkdir -p /mnt/$TARGET
mount -t ext4 /dev/mapper/volume1 /mnt/$TARGET
