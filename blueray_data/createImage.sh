#!/bin/sh

TARGET="dataBR"
FILE="image.udf"

# Prepare image:
rm -v $FILE
truncate -s 25G $FILE
ls -alh $FILE
mkudffs $FILE

# Mount:
mkdir -p /mnt/$TARGET
mount -oloop,rw $FILE /mnt/$TARGET

