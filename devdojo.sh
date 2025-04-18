#!/bin.bash

# Request linux distro from user
askdistro() {
    echo "Enter the name of your linux distro (e.g., Ubuntu, Arch, Fedora)"
    read distro

    #convert input to lowercase
    distro=$(echo "$distro" | tr '[:upper:]' '[:lower:]')

    # Respond based on user input
    case "$distro" in 
        ubuntu)
            echo "you suck"
            ;;
        arch)
            echo "nice"
            ;;
        *)
            echo "what the fuck"
            ;;
    esac
}

askdistro
