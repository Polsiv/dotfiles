#!/bin/bash


declare -r readableVariable="test"

#readableVariable="test2" #this wont work since its an only readable variable


#array
declare -a myArray=(24 2 18 3 82 10)

echo ${myArray[@]}

declare -i pos=0

#iterate through array
for element in ${myArray[@]}; do
    echo "[+] $element at $pos"
    let pos+=1
done

#Print array length
echo ${#myArray[@]}

#print the 0 element
echo ${myArray[0]}

#print the last element
echo ${myArray[-1]}

#add both ends
echo "$((${myArray[0]} + ${myArray[-1]}))"


#add new elements

myArray+=(5)


echo ${myArray[@]}


#remove elements

unset myArray[0]
unset myArray[-1]
myArray=(${myArray[@]})

#print new array
echo ${myArray[@]}

declare -a newarray=(3)

echo "$((${newarray[0]} + ${newarray[-1]}))"
