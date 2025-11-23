                                        read var3
                                done
                                if [ $var3 = "y" ]; then #rappel : faire l'exception pour 0
                                        nbr_ligne=`wc -l .sh-toolbox/archives | cut -d ' ' -f 1`
                                        fichier2=`sed -s "1d" .sh-toolbox/archives`
                                        if [ $nbr_ligne -eq 1 ]; then
                                        cat << TAG > .sh-toolbox/archives
$nbr_ligne
TAG
                                        else
                                        cat << TAG > .sh-toolbox/archives
$nbr_ligne
$fichier2
TAG
                                        fi
                                        echo "$nom_fich:$(date '+%Y%m%d-%H%M%S'):" >> .sh-toolbox/archives
                                else
                                        let "j=j+1"
                                fi
                        fi

        done


fi
