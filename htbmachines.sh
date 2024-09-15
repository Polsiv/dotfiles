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
    echo -e "\t ${purpleColour} u) ${endColour} ${grayColour} Update ${endColour}"
    echo -e "\t ${purpleColour} m) ${endColour} ${grayColour} Search by machine name ${endColour}"
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
    echo -e "$machineName"
}


#Indicators 
declare -i parameter_counter=0 # -i indicates integer

#Menu
while getopts "m:hu" arg; do

    case $arg in
        m) machineName=$OPTARG; let parameter_counter+=1;;
        u) let parameter_counter+=2;;
        h) helpPanel;;
    esac
done


if [ $parameter_counter -eq 1 ]; then
    searchMachine $machineName

elif [ $parameter_counter -eq 2 ]; then
    updateFiles
else
    helpPanel
fi
