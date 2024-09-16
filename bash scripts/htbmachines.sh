#!/bin/bash

#Colors
greenColor="\e[0;32m\033[1m"
endColor="\033[0m\e[0m"
redColor="\e[0;31m\033[1m"
blueColor="\e[0;34m\033[1m"
yellowColor="\e[0;33m\033[1m"
purpleColor="\e[0;35m\033[1m"
turquoiseColor="\e[0;36m\033[1m"
grayColor="\e[0;37m\033[1m"

# Ctrl+C
function ctrl_c(){

    echo -e "\n\n ${redColor} [!]  Exiting...${endColor}\n"
    tput cnorm; exit 1 
}

trap ctrl_c INT

#Global variables
main_url="https://htbmachines.github.io/bundle.js"

#help panel
function helpPanel(){
    echo -e "\n${yellowColor}[+] ${endColor}${grayColor}Usage: ${grayColor}"
    echo -e "\t${purpleColor}d) ${endColor} ${grayColor} Search by Difficulty ${endColor}"
    echo -e "\t${purpleColor}m) ${endColor} ${grayColor} Search by machine name ${endColor}"
    echo -e "\t${purpleColor}i) ${endColor} ${grayColor} Search by IP address ${endColor}" 
    echo -e "\t${purpleColor}o) ${endColor} ${grayColor} Search by Operating System${endColor}" 
    echo -e "\t${purpleColor}u) ${endColor} ${grayColor} Update ${endColor}"
    echo -e "\t${purpleColor}y) ${endColor} ${grayColor} Display YT link${endColor}" 
    echo -e "\t${purpleColor}h) ${endColor} ${grayColor} Help Panel ${endColor}\n"
}

#update files
function updateFiles(){

    tput civis #hide cursor
    if [ ! -f bundle.js ]; then #if the file bundle.js NOT exists

        
        echo -e "\n${yellowColor}[+] ${endColor} ${grayColor}  Downloading... ${endColor}"
        curl -s $main_url > bundle.js
        js-beautify bundle.js | sponge bundle.js
        echo -e "\n${yellowColor}[+]${endColor} ${grayColor}Done. ${endColor}"
        tput cnorm #retrieve cursor

    else

        echo -e "\n${yellowColor}[+] ${endColor} ${grayColor}Ensuring there are available updates... ${endColor}"
        tput civis
        curl -s $main_url > temp.js
        js-beautify temp.js | sponge temp.js
        md5_temp_value="$(md5sum temp.js | awk '{print $1}')"
        js-beautify bundle.js | sponge bundle.js
        md5_original_value="$(md5sum bundle.js | awk '{print $1}')"

        if [ $md5_original_value == $md5_temp_value ]; then

            echo -e "\n${greenColor}[!] ${endColor} ${grayColor}No updates available. ${endColor}\n"
            rm temp.js 

        else 
    
            echo -e "\n ${yellowColor}[+] ${endColor} ${grayColor} Downloading Updates... ${endColor}\n"
            sleep 2
            rm bundle.js && mv temp.js bundle.js
            echo -e "\n ${greenColor}[+] ${endColor} ${grayColor} Done! ${endColor}\n"

        fi
    fi

    tput cnorm #retrieve cursor
}

#searchMachine
function searchMachine(){
    
    machineName="$1"
    
    echo -e "\n${yellowColor}[+]${endColor}${grayColor} Machine Properties: ${endColor} \n"

    cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr  -d ',' | sed 's/^ *//'  | awk '{printf "\033[0;37m%s\033[0m \033[0;36m%s\033[0m\n", $1, $2}'
    
}
 
#searchip
function searchIP(){
    
    machineip="$1"
    machine_name="$(cat bundle.js | grep "ip: \"$machineip\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"

    if [ $machine_name ]; then
        echo -e "\n${yellowColor}[+]${endColor} ${grayColor}Respective machine for${endColor} ${blueColor}$machineip${endColor}${grayColor} is:${endColor}${blueColor} $machine_name${endColor}"
        searchMachine $machine_name
    else 
        echo -e "\n ${redColor}[!] Ip not found!${endColor} \n"
    fi
}

#search diff
function searchDifficulty(){
    diff="$1"
    check="$(cat bundle.js | grep "dificultad: \"$diff\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
    if [ "$check" ]; then

        echo -e "\n${yellowColor}[+]${endColor}${grayColor} Machines on ${endColor}${blueColor}$diff ${endColor}${grayColor}difficulty:${endColor}\n"
        cat bundle.js | grep "dificultad: \"$diff\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
    else
        echo -e "\n${redColor}[!] Difficulty not found lol! ${endColor}\n"    
    fi 

}


#search os
function searchOS(){
    os="$1"
    check="$(cat bundle.js | grep "so: \"$os\"" -B 4 | grep "name: " | awk 'NF{print $NF}' | tr -d '"', | tr -d ',' | column)"

    if [ "$check" ]; then

        echo -e "\n${yellowColor}[+]${endColor}${grayColor} Machines running on ${endColor}${blueColor}$os:${endColor}\n"
        cat bundle.js | grep "so: \"$os\"" -B 4 | grep "name: " | awk 'NF{print $NF}' | tr -d '"', | tr -d ',' | column

    else
        echo -e "\n${redColor}[!] Operating System not found lol! ${endColor}\n"

    fi

}

#search skills
function searchSkills(){
    skill="$1"
    check="$(cat bundle.js | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ",")"

    if [ "$check" ]; then
        echo -e "\n${yellowColor}[+]${endColor}${grayColor} Machines involving ${endColor}${blueColor}$skill:${endColor}\n"
        cat bundle.js | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d "," | column
    else
        echo -e "\n${redColor}[!] Skill not found lol! ${endColor}\n"
    fi
}

#obtain Link
function obtainLink(){
    machineName="$1"
    check="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr  -d ',' | sed 's/^ *//'  | grep "youtube" | awk 'NF{print $NF}')"

    if [ "$check" ]; then
        echo -e "\n ${yellowColor}[+]${endColor} ${grayColor}link: $check ${endColor}"    
    else
        echo -e "\n${redColor}[!]${endColor} ${grayColor}Not found! ${endColor}"
    fi
}



#extra 
function getosDifMachine(){
    diff="$1"
    os="$2"
    check="$(cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$diff\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

    if [ "$check" ]; then
        echo -e "\n${yellowColor}[+]${endColor}${grayColor} Machines running on ${endColor}${blueColor}$os${endColor} ${grayColor}and${endColor} ${blueColor}$diff ${endColor}${grayColor}Difficulty:${endColor}\n"    
        cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$diff\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
    else
        echo -e "\n${redColor}[!] Machines not found lol! ${endColor}\n"
    fi
}

# Indicators
machineName=""
machineIP=""
diff=""
os=""
skill=""

# Flags
flag_diff=0
flag_os=0


# Get options
while getopts "m:hi:y:s:d:o:u" arg; do
    case $arg in
        m) machineName="$OPTARG"; ;;
        u) updateFiles; exit 0 ;;
        i) machineIP="$OPTARG"; ;;
        y) machineName="$OPTARG"; ;;
        d) diff="$OPTARG"; flag_diff=1 ;;
        o) os="$OPTARG"; flag_os=1 ;;
        s) skill="$OPTARG"; ;;
        h) helpPanel; exit 0 ;;
        *) helpPanel; exit 1 ;;
    esac
done


# Logic based on the options set
if [ -n "$machineName" ]; then
    searchMachine "$machineName"
    
elif [ -n "$machineIP" ]; then
    searchIP "$machineIP"

elif [ -n "$diff" ] && [ $flag_diff -eq 1 ]; then
    if [ $flag_os -eq 1 ]; then
        getosDifMachine "$diff" "$os"
    else
        searchDifficulty "$diff"
    fi
elif [ -n "$os" ]; then
    searchOS "$os"
elif [ -n "$skill" ]; then
    searchSkills "$skill"
else
    helpPanels
fi