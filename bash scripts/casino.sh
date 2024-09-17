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
    echo -e  "\n ${redColor}[!] Exiting... ${endColor}"
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

    tput civis
    echo -e "\n${yellowColor}[+] ${endColor} ${grayColor} current money: ${grayColor} ${blueColor}$1 ${endColor}"
    echo -ne "${yellowColor}[+] ${endColor}${grayColor}Money to bet: ${grayColor}" && read initial_bet
    echo -ne "${yellowColor}[+] ${endColor}${grayColor}${grayColor} Choose wisely (even/odd): ${endColor}" && read even_odd

    backup_bet=$initial_bet

    while true; do



        money=$(($money-$initial_bet))
        echo -e "\n[+] $initial_bet on the line! and this yo money: $money"
        rand_number="$(($RANDOM % 37))"
        echo -e "${grayColor}[+] Number rolled: $rand_number${endColor}"
        
        if [ ! $money -le 0 ]; then
            if [ $even_odd == "even" ]; then
                if [ "$(($rand_number % 2))" -eq 0 ]; then
                    if [ $rand_number -eq 0 ]; then
                        echo -e "${redColor}[-] 0 rolled, YOU LOSE!${endColor}"
                        initial_bet=$(($initial_bet * 2))
                        echo -e "${grayColor}[+] Here's yo Money: $money ${endColor}"
                    else
                        reward=$(($initial_bet*2))
                        echo -e "${greenColor}[+] Even, YOU WIN! ${endColor}"
                        echo -e "${grayColor}[+] Heres the reward: ${endColor}${greenColor} $reward${endColor}"
                        money=$(($money+$reward))
                        echo -e "${grayColor}[+] Here's yo Money: $money ${endColor}"
                        initial_bet=$backup_bet
                    fi
                else
                    echo -e "${redColor}[-] Odd, YOU LOSE!${endColor}"
                    initial_bet=$(($initial_bet * 2))
                    echo -e "${grayColor}[+] Here's yo Money: $money ${endColor}"
                fi
            fi
        else
            echo -e "\n${redColor}[!] You ran out of money my G!${endColor}\n"
            tput cnorm; exit 0 
        fi
        sleep 0.5
    done
    
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