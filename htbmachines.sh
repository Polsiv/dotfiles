#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Ctrl+C
function ctrl_c(){

    echo -e "\n\n ${redColour} [!]  Exiting...${endColour}\n"
    tput cnorm; exit 1 
}

trap ctrl_c INT

#Global variables
main_url="https://htbmachines.github.io/bundle.js"

#help panel
function helpPanel(){
    echo -e "\n ${yellowColour}[+] ${endColour} ${grayColour}Usage: ${grayColour}"
    echo -e "\t ${purpleColour} d) ${endColour} ${grayColour} Search by Difficulty ${endColour}\n"
    echo -e "\t ${purpleColour} m) ${endColour} ${grayColour} Search by machine name ${endColour}"
    echo -e "\t ${purpleColour} i) ${endColour} ${grayColour} Search by IP address ${endColour}" 
    echo -e "\t ${purpleColour} u) ${endColour} ${grayColour} Update ${endColour}"
    echo -e "\t ${purpleColour} y) ${endColour} ${grayColour} Display YT link${endColour}" 
    echo -e "\t ${purpleColour} h) ${endColour} ${grayColour} Help Panel ${endColour}\n"
}

#update files
function updateFiles(){

    tput civis #hide cursor
    if [ ! -f bundle.js ]; then #if the file bundle.js NOT exists

        
        echo -e "\n ${yellowColour} [+] ${endColour} ${grayColour}  Downloading... ${endColour}"
        curl -s $main_url > bundle.js
        js-beautify bundle.js | sponge bundle.js
        echo -e "\n ${gellowColour}[+]${endColour} ${grayColour}Done. ${endColour}"
        tput cnorm #retrieve cursor

    else

        echo -e "\n ${yellowColour} [+] ${endColour} ${grayColour}Ensuring there are available updates... ${endColour}"
        tput civis
        curl -s $main_url > temp.js
        js beautify temp.js | sponge bundle.js
        md5_temp_value="$(md5sum temp.js | awk '{print $1}')"
        md5_original_value="$(md5sum bundle.js | awk '{print $1}')"

        if [ $md5_original_value == $md5_temp_value ]; then

            echo -e "\n ${greenColour }[!] ${endColour} ${grayColour} No updates available. ${endColour}\n"
            rm temp.js 

        else 
    
            echo -e "\n ${yellowColour}[+] ${endColour} ${grayColour} Downloading Updates... ${endColour}\n"
            sleep 2
            rm bundle.js && mv temp.js bundle.js
            echo -e "\n ${greenColour}[+] ${endColour} ${grayColour} Done! ${endColour}\n"

        fi
    fi

    tput cnorm #retrieve cursor
}

#searchMachine
function searchMachine(){
    
    machineName="$1"
    
    echo -e "\n ${yellowColour}[+] ${endColour} ${grayColour} Machine Properties: ${endColour} \n"

    cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr  -d ',' | sed 's/^ *//'  | awk '{printf "\033[0;37m%s\033[0m \033[0;36m%s\033[0m\n", $1, $2}'
    
}


#searchip
function searchIP(){
    
    machineip="$1"
    machine_name="$(cat bundle.js | grep "ip: \"$machineip\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
    echo -e "\n ${yellowColour}[+] ${endColour} ${grayColour}Respective machine for ${endColour} ${blueColour} $machineip ${endColour} ${grayColour}is: ${endColour}"
    searchMachine $machine_name

}

#search diff
function searchDifficulty(){
    diff="$1"
    check="$(cat bundle.js | grep "dificultad: \"$diff\"" -B 5 | grep "name" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
    if [ "$check" ]; then
        cat bundle.js | grep "dificultad: \"$diff\"" -B 5 | grep "name" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
    else
        echo -e "\n${redColour}[!] Difficulty not found lol! ${endColour}\n"    
    fi 

}

#obtain Link
function obtainLink(){
    machineName="$1"
    check="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr  -d ',' | sed 's/^ *//'  | grep "youtube" | awk 'NF{print $NF}')"

    if [ "$check" ]; then
        echo -e "\n ${yellowColour}[+]${endColour} ${grayColour}link: $check ${endColour}"    
    else
        echo -e "\n${redColour}[!]${endColour} ${grayColour}Not found! ${endColour}"
    fi
}

#Indicators 
declare -i parameter_counter=0 # -i indicates integer

#Menu
while getopts "m:hi:y:d:u" arg; do

    case $arg in
        m) machineName="$OPTARG"; let parameter_counter+=1;;
        u) let parameter_counter+=2;;
        h) helpPanel;;
        i) machineIP="$OPTARG"; let parameter_counter+=3;;
        y) machineName="$OPTARG"; let parameter_counter+=4;;
        d) diff="$OPTARG"; let parameter_counter+=5;;
    esac
done


if [ $parameter_counter -eq 1 ]; then
    searchMachine $machineName

elif [ $parameter_counter -eq 2 ]; then
    updateFiles

elif [ $parameter_counter -eq 3 ]; then
    searchIP $machineIP

elif [ $parameter_counter -eq 4 ]; then
    obtainLink $machineName 

elif [ $parameter_counter -eq 5 ]; then
    searchDifficulty $diff

else
    helpPanel
fi

