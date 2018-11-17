#!/bin/bash

IFS=$'\n'

TEMPDIR=$(mktemp --directory)
#TEMPDIR="tmp"
#rm -rf $TEMPDIR/dvd
mkdir -p $TEMPDIR/dl
mkdir -p $TEMPDIR/dvd/videos
mkdir -p $TEMPDIR/dvd/vob

cd $TEMPDIR/dl
#youtube-dl -f 'bestvideo,bestaudio' $1
cd -

# Transcode the videos:
echo "<dvdauthor><vmgm /><titleset><titles><pgc>" > "$TEMPDIR/dvd/dvd.xml"
for FL in $(ls -1 "$TEMPDIR/dl/"*); do
  TARGET="$TEMPDIR/dvd/videos/"$(basename $FL)".mpeg"
  echo "$FL to $TARGET"
  ffmpeg -i "$FL" -target pal-dvd -aspect 16:9 $TARGET
  echo "<vob file=\"$TARGET\" />" >> "$TEMPDIR/dvd/dvd.xml"
done
echo "<post>jump chapter 1;</post></pgc></titles></titleset></dvdauthor>" >> "$TEMPDIR/dvd/dvd.xml"

# Make the DVD:
VIDEO_FORMAT=PAL dvdauthor -x "$TEMPDIR/dvd/dvd.xml" -o "$TEMPDIR/dvd/vob"

# Make a nice DVD:
genisoimage -dvd-video -V $(date +"YDL_%d%m%y_%H") -o $TEMPDIR/dvd/dvd_$(date +"YDL_%d%m%y_%H").iso $TEMPDIR/dvd/vob
