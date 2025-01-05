#!/bin/bash

#name age
#alice 21
#ryan 30

while true 
do
    read -p column1
    
    if [ ($column1 || $column2) == exit ]
        exit 1
    fi
    read -p column2
    echo "$column1 $column2" >>input.txt
done



