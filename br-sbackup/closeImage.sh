#!/bin/sh

TARGET="cryptBR"
FILE="image.iso"
LOOP=7

umount /mnt/$TARGET
cryptsetup luksClose $TARGET
losetup -d /dev/loop$LOOP
