#!/bin/bash

if [ ! -e .sh-toolbox ]; then
	echo "le dossier .sh-toolbox n'existe pas"
	exit 1
fi 

if [ ! -e .sh-toolbox/archives ]; then
	echo "le fichier archives n'existe pas"
	exit 2
fi 

cat .sh-toolbox/archives | sed -s "1d" .sh-toolbox/archives
