#!/bin/bash

DIR="$1"
FILES=($(ls -1 $DIR/*.MP4))
TIMESTAMP=$(stat -c %y ${FILES[0]})
TMP=$(mktemp -p $DIR)

for FILE in $(ls -1 $DIR/*.MP4); do
  FL=$(basename $FILE)
  echo "$FILE"
  echo "file $FL" >> $TMP
done

cd $DIR
ffmpeg -f concat -i $TMP -an -c copy $DIR/output_tmp.mp4
rm -v $TMP

# Compress:
ffmpeg -i "$DIR/output_tmp.mp4" -c:v h264 -strict -2 -crf 23 $DIR/$(basename $DIR)_crf23.mp4
exiftool -TagsFromFile $DIR/GOPR0*.MP4 $DIR/$(basename $DIR)_crf23.mp4
rm -v $DIR/output_tmp.mp4
touch --date="$TIMESTAMP" $DIR/$(basename $DIR)*.mp4

