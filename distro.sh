#!/bin/bash

# Function to detect the Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        distro=$NAME
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        distro=$DISTRIB_ID
    elif [ -f /etc/redhat-release ]; then
        distro=$(cat /etc/redhat-release)
    elif [ -f /etc/issue ]; then
        distro=$(head -n 1 /etc/issue)
    else
        echo "Could not detect the Linux distribution. Unknown or unsupported system."
        distro="Unknown"
    fi
        echo "You are using $distro"
}

# Function to run commands based on the distro
run_commands_based_on_distro() {
    case "$distro" in
        *Ubuntu*)
            echo "Running commands for Ubuntu..."
            # Add your Ubuntu-specific commands here
            sudo apt install curl
            ;;
        *Debian*)
            echo "Running commands for Debian..."
            # Add your Debian-specific commands here
            sudo apt install curl
            ;;
        *Fedora*)
            echo "Running commands for Fedora..."
            # Add your Fedora-specific commands here
            sudo dnf install curl
            ;;
        *CentOS*)
            echo "Running commands for CentOS..."
            # Add your CentOS-specific commands here
            sudo yum install -y curl
            ;;
        *)
            echo "No specific commands for this distribution."
            ;;
    esac
}

detect_distro
run_commands_based_on_distro
