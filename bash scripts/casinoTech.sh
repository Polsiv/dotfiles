#!/bin/bash

# Colors

green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"


function ctrl_c(){
    echo -e  "\n ${red}[!] Exiting... ${end}"
    tput cnorm; exit 1
}   

# Help Panel function

function helpPanel(){
    echo -e "\n ${yellow}[+] ${end} ${gray}Casino flags: ${end}" 
    echo -e "\t ${blue}-m)  ${end}${gray}Money ${end}"
    echo -e "\t ${blue}-t)  ${end}${gray}Technique (Martingala, Inverselabrouchere)${end}"
    echo -e "\t ${blue}-h)  ${end}${gray}Help ${end}\n"
}

#Ctrl+C
trap ctrl_c INT


function initialize_game() {

    declare -gA sequence=(1 2 3 4)
    money=$1
    strat=$2
    bet_to_renew=$((money + 50))
    echo -e "\n ${yellow}[+]${end}${gray}Current Money: ${end}${blue}$money${end}"
    echo -ne "${yellow}[+]${end}${gray} Choose wisely (even/odd): ${end}" && read even_odd
    echo -e "${yellow}[+]${end}${gray} Starting Strat: ${end}${blue}$strat${end}"
}

function print_result(){

    echo -e "${yellow}[+]${end}${gray}Bet:${end}${green}$bet${end}"
    echo -e "${yellow}[+]${end}${gray}Current Money${end}${green}$money${end}"
    echo -e "${yellow}[~]${end}${gray}Number Rolled${end}${green}$rand${end}"

}

function check_game(){

    if [ "$money" -lt 0 ]; then
        echo -e "${red}[x] Ran out of money!${end}"
        echo -e "${yellow}[+]${end}${gray}Total plays:${end}${green}$counter${end}\n"
        tput cnorm; exit 0
    fi
}

function reset_sequence(){
    sequence=(1 2 3 4)
    echo -e "${red}[!]${end}${gray}Sequence reset to:${end}${blue}[${sequence[@]}]${end}"
}

function manage_limits(){
    if [ $money -gt $bet_to_renew ]; then
        echo -e "${yellow}[!]${end}${gray}Limit Exeeced. Reseting seq. ${end}"
        let bet_to_renew+=50
        reset_sequence
    elif [ $money -lt $(($bet_to_renew - 100)) ]; then
        echo - e"${yellow}[!]${end}${gray}Lower limit reached. Adjusting limit. ${end}"
        let bet_to_renew-=50 
    fi 
}

function martingala(){
    initialize_game "$1" "martingala"
    bet=1
    counter=0

    while true; do
        let counter=1
        rand=$((RANDOM % 37))   
        let money-=$bet

        check_game
        print_result

        if [ "$even_odd" == "even" ] && [ "$(($rand % 2))" -eq 0 ] && [ "$rand" -ne 0 ]; then
            reward=$(($bet * 2))
            let money+=$reward
            echo -e "${green}[+] YOU WIN!${end}"
            bet=1
        else
            echo -e "${red}[-] YOU LOSE!${end}"
            bet=$((bet * 2))
        fi
    done
}

function inverese_labouchere(){
    initialize_game "$1" "inverse labouchere"
    sequence=(1 2 3 4)
    bet=$((${sequence[0]} + ${sequence[-1]}))
    counter=0

    while true; do
        let counter+=1
        rand=$((RANDOM % 37))
        let money-=$bet

        check_game
        print_result

        if [ "$even_odd" == "even"] && [ "$(($rand % 2))" -eq 0 ] && [ "$rand" -ne 0]; then
            reward=$(($bet * 2))
            sequence+=($bet)
            let money+=$reward
            echo -e "${green}[+] YOU WIN!${end}"
        else
            echo -e "${red}[+]YOU LOSE!${end}"
            unset sequence[0] sequence[-1]
            sequence=(${sequence[@]})
        fi

        manage_limits
        bet=$(calculate_bet)
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

    elif [ $technique == "inverselabrouchere" ]; then
        inverselabrouchere $money
    else
        echo -e "\n ${redColor}[!] Wrong technique! ${endColor}"
        helpPanel
    fi
else
    helpPanel
fi
