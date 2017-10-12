#!/bin/bash

umount /sbackup/
cryptsetup -v close sbackup
