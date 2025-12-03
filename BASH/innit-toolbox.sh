#!/bin/bash

    if [ ! -d .sh-toolbox ]; then #check si le dossier .sh-toolobx existe pas
    	echo "le dossier en question va être créé"
    	mkdir .sh-toolbox #si  vrai, le créer
        if [ $? -ne 0 ]; then
            echo "mkdir a rencontré un problème"
            exit 1
        fi
    else
    	if [ ! -d .sh-toolbox ]; then #check si le dossier existe bien arpès la commande mkdir
    		exit 1;
    	fi
    fi
    
    
    if [ ! -f .sh-toolbox/archives ]; then #check si le fichier archives existe pas
    	echo "le fichier archives va être créé"
    	touch .sh-toolbox/archives #si vrai, le créer
        if [ $? -ne 0 ]; then
            echo "touch a rencontré un problème"
            exit 1
        fi
    else
    	if [ ! -f .sh-toolbox/archives ]; then #check si le fichier existe bien arpès la commande touch
    		exit 1
    	fi
    fi
    
    if [ `ls .sh-toolbox | wc -l` -ne 1 ]; then #check si il y a plus d'un fichier (archives de base) dans le dossier
    	exit 2;
    fi
    
    exit 0;
    
