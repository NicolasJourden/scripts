#!/bin/bash

for FL in $(ls -1 "$1/"*.CR2); do
  FILE=$(basename $FL .CR2)
  DIR=$(dirname $FL)
  
  if [ -e "$DIR/../$FILE"* ]; then
    echo "$FILE ok in $DIR."
  else
    echo "$FILE ko in $DIR."
    rm -v "$FL"
  fi

done

