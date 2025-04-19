#!/bin/sh
# Log script output to a file
output_log() {
    exec > >(tee -a "$(dirname "$0")/setup.log" | awk '{ print strftime("%Y-%m-%d %H:%M:%S"), $0 }') 2>&1
}
# Set error handling
handle_error() {
    echo "Error: $1" >&2
    echo "Check the setup.log for more details." >&2
}
PKG_FAIL="Failed to install packages."
# Load configuration file
conf_source() { 
    if [ -f "$(dirname "$0")/setup.conf" ]; then
        source "$(dirname "$0")/setup.conf"
    else
        handle_error "Configuration file not found."
        exit 1
    fi
}
# Check that required tools are installed
check_tool() {
    for tool in "$@"; do
        if ! command -v "$tool" &> /dev/null; then
            handle_error "$tool is not installed or not in PATH."
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
        handle_error "Unable to detect the active Linux distribution."
        exit 1
    fi
    echo "Detected Linux distribution: $distro"
}
# Install packages for each distro
pkg_install() {
    case "$distro" in
        *Debian*|*Ubuntu*) sudo apt install -y "$DEB_PKG" || handle_error "$PKG_FAIL" 
        ;;
        *Fedora*) sudo dnf install -y "$RHL_PKG" || handle_error "$PKG_FAIL" 
        ;;
        *CentOS*) sudo yum install -y "$RHL_PKG" || handle_error "$PKG_FAIL" 
        ;;
        *Arch*) sudo pacman -S --noconfirm --needed "$ARCH_PKG" || handle_error "$PKG_FAIL" 
        ;;
    esac
}
# Clone repository and install btrfs-list
btrfs_list_install() {
    if [ -f /bin/btrfs-list ]; then
        handle_error "btrfs-list is already installed."
    else 
        if ! git clone https://github.com/speed47/btrfs-list/ ./btrfs-list; then
        handle_error "Failed to clone repo speed47/btrfs-list."
        else
            cd btrfs-list
            sudo mv btrfs-list /bin/btrfs-list
            cd ..
            rm -rf "$(dirname "$0")/btrfs-list"
        fi
    fi
}
# Clone neovim config if not already present (all distros)
nvim_config_install() {
    if [ -d ~/.config/nvim ]; then
        handle_error "A neovim configuration already exists."
    else
        if ! git clone https://github.com/nieuemma/nvim.git ~/.config/nvim; then
            handle_error "Failed to clone repo nieuemma/nvim."
        fi
    fi
}
# Execute the script
check_tool git sudo awk tee
distro_detect
pkg_install
btrfs_list_install
nvim_config_install
