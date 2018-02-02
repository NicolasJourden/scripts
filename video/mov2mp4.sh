#!/bin/bash

find $1 -name '*.MOV' -print0 | while IFS= read -r -d $'\0' FILE; do 
  echo " --- $FILE --- "
  ffmpeg -i "$FILE" -c:v h264 -c:a aac -b:a 160k -strict -2 -preset veryslow -crf 20 "${FILE/MOV/mp4}"
done

