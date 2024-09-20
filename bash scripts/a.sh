#!/bin/bash

#STUPID CODE I DONT FUCK W/, ILL FIX IT LATER I PROMISE!

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
    echo -e "\n${yellowColor}[+]${endColor}${grayColor}Current money:${grayColor} ${blueColor}$1 ${endColor}"
    echo -ne "${yellowColor}[+]${endColor}${grayColor}Money to bet:${grayColor}" && read initial_bet
    echo -ne "${yellowColor}[+]${endColor}${grayColor}${grayColor}Choose wisely (even/odd):${endColor}" && read even_odd

    backup_bet=$initial_bet
    counter=0
    bad_luck=" "
    huge_money=$money

    while true; do

        money=$(($money-$initial_bet))
        rand_number="$(($RANDOM % 37))"
#       echo -e "\n[+] $initial_bet on the line! and this yo money: $money"
#       echo -e "${grayColor}[+] Number rolled: $rand_number${endColor}"
        
        if [ ! $money -lt 0 ]; then
            if [ $even_odd == "even" ]; then
                if [ "$(($rand_number % 2))" -eq 0 ]; then
                    if [ $rand_number -eq 0 ]; then
#                       echo -e "${redColor}[-] 0 rolled, YOU LOSE!${endColor}"
                        bad_luck+="$rand_number "
                        initial_bet=$(($initial_bet * 2))
#                       echo -e "${grayColor}[+] Here's yo Money: $money ${endColor}"
                    else
                        reward=$(($initial_bet*2))
#                       echo -e "${greenColor}[+] Even, YOU WIN! ${endColor}"
#                       echo -e "${grayColor}[+] Heres the reward: ${endColor}${greenColor} $reward${endColor}"
                        bad_luck=""                        
                        money=$(($money+$reward))
                        if [ $money -gt $huge_money ]; then
                           let huge_money=$money
                        fi
#                       echo -e "${grayColor}[+] Here's yo Money: $money ${endColor}"
                        initial_bet=$backup_bet
                    fi
                else
#                   echo -e "${redColor}[-] Odd, YOU LOSE!${endColor}"
                    initial_bet=$(($initial_bet * 2))
                    bad_luck+="$rand_number "
#                   echo -e "${grayColor}[+] Here's yo Money: $money ${endColor}"
                fi

            else
                if [ "$(($rand_number % 2))" -eq 1 ]; then
                    
                    reward=$(($initial_bet*2))
#                   echo -e "${greenColor}[+] Odd, YOU WIN! ${endColor}"
#                   echo -e "${grayColor}[+] Heres the reward: ${endColor}${greenColor} $reward${endColor}"
                    bad_luck=""                        
                    money=$(($money+$reward))
                    if [ $money -gt $huge_money ]; then
                        let huge_money=$money
                    fi
#                   echo -e "${grayColor}[+] Here's yo Money: $money ${endColor}"
                    initial_bet=$backup_bet
                    
                else
#                   echo -e "${redColor}[-] Even    , YOU LOSE!${endColor}"
                    initial_bet=$(($initial_bet * 2))
                    bad_luck+="$rand_number "
#                   echo -e "${grayColor}[+] Here's yo Money: $money ${endColor}"
                fi
            fi
        else
            echo -e "\n${redColor}[!] You ran out of money my G!${endColor}\n"
            echo -e "${yellowColor}[+] ${endColor}${grayColor} Play Counter: ${endColor}${blueColor}$counter ${endColor}"
            echo -e "\n${yellowColor}[+]${endColor}${grayColor}Consecutive bad luck: ${endColor}${redColor} $bad_luck ${endColor}\n"
            echo -e "\n${yellowColor}[+]${endColor}${grayColor}Max amount of money obtained:${endColor}${greenColor} $huge_money ${endColor}\n"
            
            tput cnorm; exit 0 
        fi
#        sleep 0.5
        let counter+=1
    done
}


function inverselabrouchere(){

    declare -a sequence=(1 2 3 4)
    echo -e "\n${yellowColor}[+]${endColor}${grayColor}Current money:${grayColor} ${blueColor}$1 ${endColor}"
    echo -ne "${yellowColor}[+]${endColor}${grayColor}${grayColor}Choose wisely (even/odd):${endColor}" && read even_odd
    echo -e "\n${yellowColor}[+] ${endColor}${grayColor}Starting with sequence: ${endColor}${blueColor}[${sequence[@]}]${endColor}"
    counter=0
    bet_to_renew=$(($money+50))
    bet=$((${sequence[0]} + ${sequence[-1]})) #money till sequence reset
    sequence=(${sequence[@]})
    tput civis

    echo -e "${yellowColor}[+]${endColor}${grayColor} Limit until sequence is reestablished is above:${endColor}${greenColor} $bet_to_renew${endColor}"


    while true; do
    
        let counter+=1
        rand=$(($RANDOM % 37))
        let money-=$bet
        
        if [ "$money" -lt 0 ]; then   
            echo -e "${redColor}[x] You got no Money to bet!${endColor}"
            echo -e "${yellowColor}[+] ${endColor} Total plays:${endColor}${greenColor} $counter${endColor}\n"
            tput cnorm; exit 0
        fi


        echo -e "${yellowColor}[+]${endColor}${grayColor} Money on the line: ${endColor}${greenColor}$bet usd! ${endColor}${grayColor}"
        echo -e "${yellowColor}[+]${endColor}${grayColor} Current money:${endColor} ${greenColor}$money${endColor}"
        echo -e "\n${yellowColor}[~]${endColor}${grayColor} Number rolled:${endColor}${blueColor} $rand${endColor}"
        
        if [ $even_odd == "even" ]; then
            if [ "$(($rand % 2))" -eq 0 ] && [ $rand -ne 0 ]; then

                reward=$(($bet * 2))
                sequence+=($bet)
                sequence=(${sequence[@]})
                let money+=$reward

                echo -e "${greenColor}[+] Even, YOU WIN!${endColor}"
                echo -e "${yellowColor}[+]${endColor}${grayColor} Now you got:${endColor} ${greenColor}$money${endColor}"

                #=========================================
                if [ $money -gt $bet_to_renew ]; then
                    echo -e "${yellowColor}[!]${endColor} ${grayColor}Our money has outpassed the limit of: ${greenColor}$bet_to_renew${endColor}${grayColor}, new sequence stablished${endColor}"
                    let bet_to_renew+=50
                    echo -e "${yellowColor}[+]${endColor}${grayColor} New limit:${endColor}${greenColor} $bet_to_renew${endColor}"
                    sequence=(1 2 3 4)
                    echo -e "${yellowColor}[!]${endColor}${grayColor}Sequence stablished to: ${endColor}${blueColor}[${sequence[@]}]${endColor}"
                    bet=$((${sequence[0]} + ${sequence[-1]})) 
                
                elif [ $money -lt $(($bet_to_renew - 100)) ]; then

                    let bet_to_renew-=50

                    echo -e "\n${yellowColor}[+]${endColor} ${grayColor}Minimun Limit reached, new limit stablished: ${endColor}${greenColor}$bet_to_renew ${endColor}"

                     echo -e "${yellowColor}[+]${endColor}${grayColor} New sequence:${endColor}${blueColor} [${sequence[@]}]${endColor}"

                    if [ "${#sequence[@]}" -gt 1 ]; then
                        bet=$((${sequence[0]} + ${sequence[-1]})) 
                    elif [ "${#sequence[@]}" -eq 1 ]; then
                        bet=${sequence[0]}  
                    else

                        sequence=(1 2 3 4)
                        bet=$((${sequence[0]} + ${sequence[-1]}))

                        echo -e "${redColor}[!]${endColor}${grayColor}We lost our sequence!, restored to: ${endColor}[${sequence[@]}]${endColor}"
                        
                    fi

                else                
                    echo -e "${yellowColor}[+]${endColor}${grayColor} New sequence:${endColor}${blueColor} [${sequence[@]}]${endColor}"

                    if [ "${#sequence[@]}" -gt 1 ]; then
                        bet=$((${sequence[0]} + ${sequence[-1]})) 
                    elif [ "${#sequence[@]}" -eq 1 ]; then
                        bet=${sequence[0]}  
                    else

                        sequence=(1 2 3 4)
                        bet=$((${sequence[0]} + ${sequence[-1]}))

                        echo -e "${redColor}[!]${endColor}${grayColor}We lost our sequence!, restored to: ${endColor}[${sequence[@]}]${endColor}"
                        
                    fi
                fi
                #=========================================

            elif [ "$(($rand % 2))" -eq  1 ] || [ "$rand" -eq 0 ]; then 


                if [ "$rand" -eq 0 ]; then
                    echo -e "${redColor}[-] Rolled 0, YOU LOSE!${endColor}"
                else
                    echo -e "${redColor}[-] Odd, YOU LOSE!${endColor}"
                fi


                if [ $money -lt $(($bet_to_renew - 100)) ]; then

                    let bet_to_renew-=50

                    echo -e "\n${yellowColor}[+]${endColor} ${grayColor}Minimun Limit reached, new limit stablished: ${endColor}${greenColor}$bet_to_renew ${endColor}"

                    echo -e "${yellowColor}[+]${endColor}${grayColor} New sequence:${endColor}${blueColor} [${sequence[@]}]${endColor}"


                    unset sequence[0]
                    unset sequence[-1] 2>/dev/null
                    sequence=(${sequence[@]})

                    if [ "${#sequence[@]}" -gt 1 ]; then
                        bet=$((${sequence[0]} + ${sequence[-1]})) 
                    elif [ "${#sequence[@]}" -eq 1 ]; then
                        bet=${sequence[0]}  
                    else

                        sequence=(1 2 3 4)
                        bet=$((${sequence[0]} + ${sequence[-1]}))

                        echo -e "${redColor}[!]${endColor}${grayColor}We lost our sequence!, restored to: ${endColor}[${sequence[@]}]${endColor}"
                        
                    fi

                else  
                        
                        unset sequence[0]
                        unset sequence[-1] 2>/dev/null
                        sequence=(${sequence[@]})
                    
                    echo -e "${yellowColor}[+]${endColsor} ${grayColor}Sequence updated:${endColor}${blueColor} [${sequence[@]}]${endColor}"
                    
                    if [ "${#sequence[@]}" -gt 1 ]; then
                        bet=$((${sequence[0]} + ${sequence[-1]})) 
                    elif [ "${#sequence[@]}" -eq 1 ]; then
                        bet=${sequence[0]}
                    else
                        sequence=(1 2 3 4)
                        bet=$((${sequence[0]} + ${sequence[-1]})) 
                        
                        echo -e "${redColor}[!]${endColor}${grayColor} We lost our sequence!, restored to: ${endColor}${blueColor}[${sequence[@]}]${endColor}"
                    fi
                fi 
            fi
        else    
            echo "odd"
        fi

    done
    tput cnorm
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