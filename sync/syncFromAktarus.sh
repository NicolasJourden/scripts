#!/bin/bash

# All:
rsync				\
	-vrat			\
	--progress		\
	--exclude ".recycle"	\
	--exclude "*tmp*"	\
	--exclude "*~"		\
	--exclude ".Trash*"	\
	--exclude "HTPC"	\
	--exclude "PIrec"	\
	--no-group --no-perms	\
	/data/*			\
	nicolas@aktarus:/data/
echo "Rsync done ... "

