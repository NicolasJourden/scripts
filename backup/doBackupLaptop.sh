#!/bin/bash

LOGFILE=$(mktemp)
echo "Log to $LOGFILE ... "

# Finding what other luks is mounted now...
DRIVE=$(mount | grep luks | cut -d " " -f3 | grep -v 7a)
echo "Target: $DRIVE"

rsync				\
	--progress		\
	-vrat			\
	--no-group		\
	--exclude ".recycle"	\
	--exclude "*tmp*"	\
	--exclude "*~"		\
	/SData/* \
	$DRIVE/ | tee "$LOGFILE"
echo "Rsync done ..."

cat "$LOGFILE" | mail -a "$LOGFILE" -s "sbackup - laptop" nicolas.jourden@laposte.net
echo "Email sent!"
