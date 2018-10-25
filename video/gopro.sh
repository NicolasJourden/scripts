#!/bin/bash

FILES=($(ls -1 $1/*.MP4))
TIMESTAMP=$(stat -c %y ${FILES[0]})
TMP=$(mktemp -p $1)

for FILE in $(ls -1 $1/*.MP4); do
  FL=$(basename $FILE)
  echo "$FILE"
  echo "file $FL" >> $TMP
done

cd $1
ffmpeg -f concat -i $TMP -an -c copy $1/output_tmp.mp4
rm -v $TMP
touch --date="$TIMESTAMP" $1/output_tmp.mp4

# Compress:
ffmpeg -i "$1/output_tmp.mp4" -c:v h264 -strict -2 -crf 20 $1/$(basename $1)_crf20.mp4
ffmpeg -i "$1/output_tmp.mp4" -c:v h264 -strict -2 -crf 23 $1/$(basename $1)_crf23.mp4
ffmpeg -i "$1/output_tmp.mp4" -c:v h264 -strict -2 -crf 35 $1/$(basename $1)_crf35.mp4
ffmpeg -i "$1/output_tmp.mp4" -c:v h264 -strict -2 -crf 50 $1/$(basename $1)_crf50.mp4
touch --date="$TIMESTAMP" $1/$(basename $1)*.mp4
