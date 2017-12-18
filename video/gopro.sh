#!/bin/bash

CONVS=""
for FILE in $(ls -1 "$1/"*.MP4); do
  FL=$(basename $FILE .MP4)
  echo "$FILE -> $TARGET"
  CONVS="$CONVS|$FILE"
done

echo ${CONVS%?}

ffmpeg -i "concat:/dev/null$CONVS" -c copy $1/output.mp4

