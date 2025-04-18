#!/bin/bash

# Function to detect the Linux distribution
distro_detect() {
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
}

# Function to run commands based on the distro
distro_commands() {
    case "$distro" in
        *Ubuntu*)
            echo "Running commands for Ubuntu..."
            # Add your Ubuntu-specific commands here
            sudo apt install curl
            ;;
        *Debian*)
            echo "Running commands for Debian..."
            sudo apt install curl
            ;;
        *Fedora*)
            echo "Running commands for Fedora..."
            sudo dnf install curl
            ;;
        *CentOS*)
            echo "Running commands for CentOS..."
            sudo yum install -y curl
            ;;
        *"Arch Linux"*)
            sudo pacman -S --noconfirm --needed gnome-shell nautilus epiphany gnome-console gnome-control-center gnome-tweaks gnome-keyring xdg-user-dirs gdm networkmanager nm-connection-editor baobab gnome-disk utilitx gnome-text-editor gnome-system-monitor loupe totem decibels guake neovim btrfs-progs timeshift
            [ -f /bin/btrfs-list ] && echo "btrfs-list is already installed." || (git clone https://aur.archlinux.org/btrfs-list.git && cd btrfs-list && makepkg -s --install --noconfirm *.zst && cd .. && rm -rf btrfs-list)
            [ -d ~/.config/nvim ] && echo "A neovim configuration already exists." || (cd ~/.config && git clone https://github.com/nieuemma/nvim.git)
            ;;
        *)
            echo "No specific commands for this distribution."
            ;;
    esac
}

distro_detect
distro_commands
rm -f $0
