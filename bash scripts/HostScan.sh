#!/bin/bash

#Ctrl+c

function ctrl_c(){
    echo -e "\n[!] exiting..."
    exit 1
}

trap ctrl_c INT


for i in $(seq 1 254); do

    timeout 1 bash -c "ping 192.168.1.$i &>/dev/null" && echo " [+]Host 192.168.1.$i is active" &

done; wait
