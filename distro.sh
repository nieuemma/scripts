#!/bin/bash

# Log script output to a file
exec > "$(dirname "$0")/output.log" 2>&1

# Define package variables
DEB_PKG="gnome-shell nautilus epiphany-browser gnome-terminal gnome-control-center gnome-tweaks gnome-keyring xdg-user-dirs gdm3 network-manager network-manager-gnome btrfs-progs neovim"
RHL_PKG="gnome-shell nautilus epiphany gnome-terminal gnome-control-center gnome-tweaks gnome-keyring xdg-user-dirs gdm NetworkManager network-manager-applet btrfs-progs neovim"
ARCH_PKG="gnome-shell nautilus epiphany gnome-console gnome-control-center gnome-tweaks gnome-keyring xdg-user-dirs gdm networkmanager nm-connection-editor btrfs-progs neovim"
PKG_FAIL="Failed to install packages."
# Check that required tools are installed
check_commands() {
    for tool in "$@"; do
        if ! command -v "$tool" &> /dev/null; then
            echo "Error: $tool is not installed or not in PATH."
            exit 1
        fi
    done
}

# Detect the active Linux distro
distro_detect() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        distro=$NAME
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        distro=$DISTRIB_ID
    elif [ -f /etc/redhat-release ]; then
        distro="$(cat /etc/redhat-release)"
    elif [ -f /etc/issue ]; then
        distro="$(head -n 1 /etc/issue)"
    else
        echo "Unable to detect the active Linux distribution. Unknown or unsupported system."
        distro="Unknown"
    fi
    echo "Detected Linux distribution: $distro"
}

# Install commands based on active Linux distro
distro_commands() {
    case "$distro" in
        *Debian*|*Ubuntu*)
            if ! sudo apt install -y $DEB_PKG; then
                echo "$PKG_FAIL"
                exit 1
            fi
            ;;
        *Fedora*)
            if ! sudo dnf install -y $RHL_PKG; then
                echo "$PKG_FAIL"
                exit 1
            fi
            ;;
        *CentOS*)
            if ! sudo yum install -y $RHL_PKG; then
                echo "$PKG_FAIL"
                exit 1
            fi
            ;;
        *Arch*)
            if ! sudo pacman -S --noconfirm --needed $ARCH_PKG; then
                echo "$PKG_FAIL"
                exit 1
            fi
            ;;
        *Unknown*)
            exit 1
            return
            ;;
    esac
# Clone neovim config if not already present (all distros)
    if [ -d ~/.config/nvim ]; then
        echo "A neovim configuration already exists."
    else
        if ! git clone https://github.com/nieuemma/nvim.git ~/.config/nvim; then
            echo "Failed to clone repo nieuemma/nvim."
            exit 1
        fi
    fi
}

# Execute the script
check_commands git sudo
distro_detect
distro_commands
