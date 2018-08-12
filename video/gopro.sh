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
ffmpeg -f concat -i $TMP -c copy $1/output.mp4
rm -v $TMP

touch --date="$TIMESTAMP" $1/output.mp4
