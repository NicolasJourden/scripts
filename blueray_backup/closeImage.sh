#!/bin/sh

TARGET="cryptBR"
FILE="image.iso"
LOOP=7

umount /mnt/$TARGET
losetup -d /dev/loop$LOOP
