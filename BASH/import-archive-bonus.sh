
                if [ $? -ne 0 ]; then
                        echo "problème de copie"
                        exit 3
                fi




        fi



        if [ ! -d .sh-toolbox/$nom ] && [ ! -f .sh-toolbox/$nom ]; then #regarde si la copie à bien été faite
                echo "la copie à rencotnré un problème"
                exit 3
        fi
        shift
done





exit 0
