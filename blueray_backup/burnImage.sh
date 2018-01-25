#!/bin/sh

FILE="image.iso"

growisofs -dvd-compat -Z /dev/sr0=$FILE
