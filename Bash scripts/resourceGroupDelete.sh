#!/bin/bash
#Funktio, joka listaa tilin resource groupit
listaa_resource_groupit () {
    az group list --output table
}

#Funktio, joka poistaa resource groupin
poista_resource_group () {
    az group delete -n $resource_group
    echo "Resource group $resource_group poistettu!"
}

#Funktio, joka kysyy, minkä niminen RG poistetaan.
resource_groupin_tarkastus () {
    while true; do
        read -p "Minkä resource groupin haluat poistaa? " resource_group
        if [ $(az group exists --name $resource_group) = true ]; then
            poista_resource_group
            read -p "Haluatko poistaa toisen resource groupin (y/n)? " delete_another
                if [ $delete_another = "y" ]; then
                    listaa_resource_groupit
                    continue
                else
                    break
                fi
        else
            echo "Antamaasi resource groupia ei ole olemassa. Kokeile uudestaan."
        fi
    done
}

listaa_resource_groupit
resource_groupin_tarkastus