#!/bin/bash

#Ctrl+c

function ctrl_c(){
    echo -e "\n[!] exiting..."
    tput cnorm; exit 1
}

trap ctrl_c INT

tput civis #hides cursor

for port in $(seq 1 65535); do

    (echo '' > /dev/tcp/127.0.0.1/$port) 2>/dev/null && echo -e "\n[+] $port - open!" &

    # & creates a thread

done; wait

# retrieve cursor

tput cnrom
