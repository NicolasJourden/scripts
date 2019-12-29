#!/bin/bash

# Travail:
rsync	--delete 		\
	-vrat			\
	--progress		\
	--exclude ".recycle"	\
	--exclude "*tmp*"	\
	--exclude "*~"		\
	--exclude ".Trash*"	\
	--no-group --no-perms	\
	/data/Travail/		\
	nicolas@aktarus:/data/Travail/
echo "Rsync travail done ... "

# Project:
rsync				\
	--delete		\
	-vrat			\
	--progress		\
	--exclude ".recycle"	\
	--exclude "*tmp*"	\
	--exclude "*~"		\
	--exclude ".Trash*"	\
	--no-group --no-perms	\
	/data/project/		\
	nicolas@aktarus:/data/project/
echo "Rsync project done ... "

# Divers:
rsync				\
	--delete		\
	-vrat			\
	--progress		\
	--exclude ".recycle"	\
	--exclude "*tmp*"	\
	--exclude "*~"		\
	--exclude ".Trash*"	\
	--no-group --no-perms	\
	/data/Divers/		\
	nicolas@aktarus:/data/Divers/
echo "Rsync divers done ... "

# All:
rsync				\
	-vrat			\
	--progress		\
	--exclude ".recycle"	\
	--exclude "*tmp*"	\
	--exclude "*~"		\
	--exclude ".Trash*"	\
	--no-group --no-perms	\
	/data/*			\
	nicolas@aktarus:/data/
echo "Rsync done ... "

