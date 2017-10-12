#!/bin/bash

OPTIONS="-auto-level -auto-gamma -verbose -quality 92"

for FL in $(ls -1 "$1/"*.jpg); do
  FILE=$(basename $FL .jpg)
  DIR=$(dirname $FL)
  echo $FILE

  convert "$FL" $OPTIONS "$DIR/${FILE}_$FOCAL.jpeg"

done

