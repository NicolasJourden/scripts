#!/bin/bash

OPTIONS="-auto-level -auto-gamma -verbose -quality 92"

for FL in $(ls -1 "$1/"*.JPG); do
  FILE=$(basename "$FL" .JPG)
  DIR=$(dirname "$FL")
  FOCAL_T=$(exiv2 -pa "$FL" | grep Exif.Canon.FocalLength | awk '{print $4}' )
  LENS=$(exiv2 -pa "$FL" | grep "Exif.Photo.LensModel")
  FOCAL=${FOCAL_T%".0"}
  echo $FILE
  BAREL="0.0 0.0 0.0"

  # 10-18
  if [[ $LENS == *"10-18"* ]]; then
    case "$FOCAL" in
      10)
        BAREL="0.00949 -0.05893 0.07285"
      ;;
      11)
        BAREL="-0.00564 0.00351 0.00207"
      ;;
      12|13|14)
        BAREL="-0.00356 -0.00048 0.0094"
      ;;
      15|16|17)
        BAREL="0.0 0.00056 0.0"
      ;;
      18)
        BAREL="0.0 0.00148 0.0"
      ;;
      *)
        echo "Unknow: $FOCAL for $LENS"
      ;;
    esac
  fi

  # 18 - 55
  if [[ $LENS == *"18-55"* ]]; then
    case "$FOCAL" in
      18|19|20)
      BAREL="0.0 0.003658 -0.04063"
      ;;
      21|22|23)
        BAREL="0.0 0.004255 -0.038513"
      ;;
      24|25|26)
        BAREL="0.0 -0.00096 -0.01979"
      ;;
      27|28|29)
        BAREL="0.0 0.001701 -0.014516"
      ;;
      30|31|32)
        BAREL="0.0 0.003199 -0.012047"
      ;;
      33|34|35|36)
        BAREL="0.0 3.4e-05 -0.005236"
      ;;
      37|38|39|40)
        BAREL="0.0 0.00556 -0.016032"
      ;;
      41|42|43|44)
        BAREL="0.0 0.001585 -0.007594"
      ;;
      45|46|47)
        BAREL="0.0 0.00577 -0.015688"
      ;;
      48|49|50|51|52)
        BAREL="0.0 0.001543 -0.003821"
      ;;
      53|54)
        BAREL="0.0 -0.001301 0.001515"
      ;;
      55)
        BAREL="0.0 0.000426 -0.001817"
      ;;
      *)
        echo "Unknow: $FOCAL for $LENS"
      ;;
    esac
  fi

  echo "Focal/lens: $FOCAL for $LENS"
  echo "convert \"$FL\" $OPTIONS -distort barrel \"$BAREL\" \"$DIR/${FILE}_$FOCAL.jpg\""
  convert "$FL" $OPTIONS -distort barrel "$BAREL" "$DIR/${FILE}_$FOCAL.jpg"
  #$CMR

done

