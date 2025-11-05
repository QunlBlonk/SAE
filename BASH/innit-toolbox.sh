#!/bin/bash

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
    else
    	if [ ! -f .sh-toolbox/archives ]; then
    		exit 1
    	fi
    fi
    
    if [ `ls .sh-toolbox | wc -l` -ne 1 ];then
    	exit 2;
    fi
    
    exit 0;
    
