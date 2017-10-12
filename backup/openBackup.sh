#!/bin/bash

cryptsetup -v open $1 sbackup

mount -v /dev/mapper/sbackup /sbackup
