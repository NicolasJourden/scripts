#!/bin/bash -x

find $1 -name '*.MOV' -exec bash -c 'ffmpeg -i "$0" -c:v h264 -c:a aac -b:a 160k -strict -2 -crf 20 "${0/MOV/mp4}"' {} \;


