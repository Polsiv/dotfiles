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

function ctrl_c(){
    echo -e  "\n ${redColor}[!] Exiting... ${endColour}"
    tput cnorm; exit 1
}   

function helpPanel(){
    echo -e "\n ${yellowColor}[+] ${endColor} ${grayColor}Casino flags: ${endColor}" 
    echo -e "\t ${blueColor}-m)  ${endColor}${grayColor}Money ${endColor}"
    echo -e "\t ${blueColor}-t)  ${endColor}${grayColor}Technique (Martingala, Inverselabrouchere)${endColor} "
    echo -e "\t ${blueColor}-h)  ${endColor}${grayColor}Help ${endColor}\n"

}


#Ctrl+C
trap ctrl_c INT


function martingala(){
    echo -e "\n[+] current money: $1"
    echo -n "[+] Money to bet: " && read initial_bet
    echo -n "[+] Choose wisely (even/odd)" && read even_odd

    echo 
}

while getopts "m:t:h" args; do

    case $args in
        m) money=$OPTARG;;
        t) technique=$OPTARG;;
        h) helpPanel;;

    esac
done



if [ $money ] && [ $technique ]; then
    if [ $technique == "martingala" ]; then
        martingala $money
    else
        echo -e "\n ${redColor}[!] Wrong technique! ${endColor}"
        helpPanel
    fi
else
    helpPanel
fi
