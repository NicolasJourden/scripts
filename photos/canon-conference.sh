#!/bin/bash -x

OPTIONS="-define jpeg:extent=2MB -strip"

for FL in $(ls -1 "$1/"*.jpeg); do
  FILE=$(basename "$FL" .jpeg)
  DIR=$(dirname "$FL")

  convert "$FL" $OPTIONS "$DIR/${FILE}_$FOCAL.2MB.jpeg"
done

