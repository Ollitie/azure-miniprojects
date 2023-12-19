#!/bin/bash

#Tämä skripti tekee uuden resource groupin. Ensin määritellään funktiot.

#funktio, joka kirjaa käyttäjän sisään
login () {
    az login
    echo "Olet kirjautunut sisään"
}

# Näytä 5 käyttäjälle parhaiten sopivaa Azure-regionia. 
# Regionit haetaan Azuresta "az account list-locations"-komennolla ja tallennetaan regions_array-muuttujaan. 
# Lopuksi regionit näytetään käyttäjälle for-loopin avulla.
print_regions () {
    echo "Tässä sinulle parhaiten sopivat regionit:"
    regions_array=($(az account list-locations --query "[?metadata.regionCategory=='Recommended'].{Name:name}" -o tsv | head -n 5))
    for i in "${regions_array[@]}"
    do
        echo "$i"
    done
}

# Funktio, joka pyytää käyttäjää antamaan haluamansa regionin,
# ja tarkastaa, että annettu region täsmää aiemmin esitetyssä listassa oleviin regioneihin.
# Tässä hyödynnetty while-loopia, joka pyytää regionia ja tarkastaa täsmäävyyden. 
# Jos täsmää, loopista lähdetään pois, jos ei, kysytään uudestaan.
check_region() {
    local region_exists=false
    while [[ $region_exists = false ]]; do
        print_regions
        read -p "Syötä haluamasi region: " selected_region
        for j in "${regions_array[@]}"
        do 
            if [[ "$selected_region" == "$j" ]]; then
                region_exists=true
                echo "Regionin valinta ok"
                break
            else
                continue
            fi
        done
    done
}

#Funktio, joka pyytää resource groupille nimen ja tarkastaa, ettei sen nimistä rg:tä ole jo olemassa.
# Hyödynnetty while-loopia ja if-lausetta: jos samanniminen rg on jo olemassa, pyydetään antamaan toinen nimi, muuten poistutaan loopista.
check_resource_group () {
    while true; do
        read -p "Anna nimi resource groupille: " resource_group
        if [ $(az group exists --name $resource_group) = true ]; then
            echo "Resource groupin nimi $resource_group on jo käytössä regionilla $selected_region. Anna toinen nimi. "
        else
            break
        fi
    done
}

#Funktio, jolla luodaan resource group aiemmin annetulla nimellä aiemmin annetulle regionille. 
# Näytetään lopputulemana provisioningState eli käytännössä provisioinnin status
create_resource_group () {
    echo "Luodaan uusi resource group $resource_group alueella $selected_region"
    az group create -g $resource_group -l $selected_region | grep provisioningState
}

#Funktio, joka listaa kaikki resource groupit taulukossa
list_resource_groups () {
    az group list -o table
}

#Lopuksi ajetaan funktiot

login
check_region
check_resource_group
create_resource_group
list_resource_groups
