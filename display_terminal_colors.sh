#!/bin/bash
# Display the colors available in the terminal.

for num in {0..255}; do  
    printf "%s\033[38;5;${num}mcolour${num}\033[0m \t"; 

    if [ $(expr $((num+1)) % 8) -eq 0 ]; then
        printf "\n"
    fi
done

