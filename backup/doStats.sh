#!/bin/bash

find $1 -type d -print0 | while read -d $'\0' f
do
	echo -n "'$f',"
	echo $(ls -1 "$f" | wc -l)
done

