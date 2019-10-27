#!/bin/bash

LOGFILE=$(mktemp)
echo "Log to $LOGFILE ... "

rsync				\
	--progress		\
	-vrat			\
	--no-group		\
	--include="*/"		\
	--include "*JPG"	\
	--include "*jpeg"	\
	--include "*jpg"	\
	--include "*mp4"	\
	--include "*MP4"	\
	--include "*png"	\
	--include "*MOV"	\
	--include "*mov"	\
	--include "*PDF"	\
	--include "*pdf"	\
	--include "*amr"	\
	--exclude ".thumbnails" \
	--exclude "*"		\
	/run/user/1000/gvfs/mtp*/Mémoire\ de\ stockage\ interne/* \
	/SData/Media/Perso/Cellphone/ArchosV2/All | tee "$LOGFILE"
echo "Rsync done ... "

cat "$LOGFILE" | mail -a "$LOGFILE" -s "sbackup - archos" nicolas.jourden@laposte.net
echo "Email sent."
