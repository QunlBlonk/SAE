#!/bin/bash

	#test si l'un des fichiers sources existent pas
	if [ ! -e ./src/statique.c ] || [ ! -e ./src/findkey.c ] || [ ! -e ./src/makefile ] || [ ! -e ./src/decipher.c ] || [ ! -e ./src/statique.h ];then
		echo "l'un des fichiers sources existent pas"
		exit 10
	fi

	#si on ne trouve pas le dossier ou est stoqués gcc ou make alors on suppose qu'il existe pas
	gcc=`which gcc`
	makes=`which make`
	if [ -z $gcc ] || [ -z $makes ]; then
		echo "le compilateur n'a pas était trouver"
		exit 11
	fi

	#si findkey existe pas dans . il est mit dans . idem pour decipher
        if [ ! -e ./findkey ] || [ ! -e ./decipher ]; then
		cd ./src
                make
		if [ $? -ne 0 ]; then
			echo "problème de compilation"
			exit 12
		fi
		cd ..
		if [ ! -e ./decipher ]; then
			mv ./src/decipher .
		else
			rm ./src/decipher
		fi

		if [ ! -e ./findkey ]; then
                        mv ./src/findkey .
                else
                        rm ./src/findkey
                fi
        fi


    if [ ! -d .sh-toolbox ]; then
    	echo "le dossier en question va être créé"
    	mkdir .sh-toolbox
    else
    	if [ ! -d .sh-toolbox ]; then
    		exit 1;
    	fi
    fi
    
    
    if [ ! -f .sh-toolbox/archives ]; then
    	echo "le fichier archives va être créé"
    	touch .sh-toolbox/archives
	echo 0 > .sh-toolbox/archives
    else
    	if [ ! -f .sh-toolbox/archives ]; then
    		exit 1
    	fi
    fi
    
    if [ `ls .sh-toolbox | wc -l` -ne 1 ];then
	echo "des fichiers existent déjà dans le dossier archives"
    	exit 2;
    fi
    

    exit 0;
