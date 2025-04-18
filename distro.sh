#!/bin/bash

# Function to detect the Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "You are using $NAME $VERSION"
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        echo "You are using $DISTRIB_ID $DISTRIB_RELEASE"
    elif [ -f /etc/redhat-release ]; then
        echo "You are using $(cat /etc/redhat-release)"
    elif [ -f /etc/issue ]; then
        echo "You are using $(head -n 1 /etc/issue)"
    else
        echo "Could not detect the Linux distribution. Unknown or unsupported system."
    fi
}

detect_distro
