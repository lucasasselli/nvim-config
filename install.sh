#!/bin/bash

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function create_links(){
    rm -rf ~/.config/nvim
    ln -sfn $DIR ~/.config/nvim 
}

# Handle user input
while true; do
    read -p "This script will replace your current configuration. Do you want to continue? [y/n] " yn
    case $yn in
        [Yy]*) 
            create_links
            break
            ;;
        [Nn]*) 
            exit
            ;;
        *) 
            echo "Please answer yes or no."
            ;;
    esac
done
