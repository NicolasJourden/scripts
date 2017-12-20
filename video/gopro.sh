#!/bin/bash

TMP=$(mktemp -p $1)
for FILE in $(ls -1 $1/*.MP4); do
  FL=$(basename $FILE)
  echo "$FILE"
  echo "file $FL" >> $TMP
done

cd $1
ffmpeg -f concat -i $TMP -c copy $1/output.mp4

