#!/bin/bash

LOGFILE=$(mktemp)
echo "Log to $LOGFILE ... "

rsync				\
	-rat			\
	--exclude ".recycle"	\
	--exclude "*tmp*"	\
	--exclude "*~"		\
	--delete		\
	--verbose		\
	/data/*			\
	/sbackup/ | tee "$LOGFILE"
echo "Rsync done ... "

cat "$LOGFILE" | mail -a "$LOGFILE" -s "sbackup - 2T" nicolas.jourden@laposte.net
echo "Email sent."
