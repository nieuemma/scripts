#!/bin/bash
# Exit on error
set -euxo pipefail
# Define packages to install
DEB_PKG="gnome-shell nautilus epiphany-browser gnome-terminal gnome-control-center gnome-tweaks gnome-keyring xdg-user-dirs gdm3 network-manager network-manager-gnome btrfs-progs neovim"
RHL_PKG="gnome-shell nautilus epiphany gnome-terminal gnome-control-center gnome-tweaks gnome-keyring xdg-user-dirs gdm NetworkManager network-manager-applet btrfs-progs neovim"
ARCH_PKG="gnome-shell nautilus epiphany gnome-console gnome-control-center gnome-tweaks gnome-keyring xdg-user-dirs gdm networkmanager nm-connection-editor btrfs-progs neovim"

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
        echo "Could not detect the Linux distribution. Unknown or unsupported system."
        distro="Unknown"
    fi
}

# Install commands based on active Linux distro
distro_commands() {
    case "$distro" in
        *Debian*|*Ubuntu*)
            sudo apt install -y $DEB_PKG
            ;;
        *Fedora*)
            sudo dnf install -y $RHL_PKG
            ;;
        *CentOS*)
            sudo yum install -y $RHL_PKG
            ;;
        *"Arch Linux"*)
            sudo pacman -S --noconfirm --needed $ARCH_PKG
            [ -f /bin/btrfs-list ] && echo "btrfs-list is already installed." || (git clone https://aur.archlinux.org/btrfs-list.git && cd btrfs-list && makepkg -s --install --noconfirm *.zst && cd .. && rm -rf btrfs-list)
            ;;
        *Unknown*)
            echo "No commands for this distribution."
            return
            ;;
    esac
    [ -d ~/.config/nvim ] && echo "A neovim configuration already exists." || (cd ~/.config && git clone https://github.com/nieuemma/nvim.git)
}

distro_detect
distro_commands
rm $0
