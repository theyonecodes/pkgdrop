#!/bin/bash
# Simple whiptail-based GUI for pkgdrop uninstall

# Function to get installed packages
get_installed_packages() {
    pkgdrop -l 2>/dev/null | grep -E '^[a-zA-Z0-9\-_.]+( v[0-9.]+)? \(' | sed 's/\s*\(v[0-9.]+\)? \(.*\)$//'
}

# Function to display main menu
show_main_menu() {
    local choice
    choice=$(whiptail --title "pkgdrop Uninstaller" --menu "Choose an action:" 15 60 8 \
        "1" "Uninstall a package" \
        "2" "List installed packages" \
        "3" "Refresh package list" \
        "4" "Exit" 3>&1 1>&2 2>&3)
    
    case "$choice" in
        "1") uninstall_package ;;
        "2") list_packages ;;
        "3") refresh_list ;;
        "4") exit 0 ;;
        *) show_main_menu ;;
    esac
}

# Function to list installed packages
list_packages() {
    local packages
    packages=$(get_installed_packages)
    
    if [ -z "$packages" ]; then
        whiptail --msgbox "No packages installed." 10 50
    else
        whiptail --textbox /dev/fd/3 20 70 3<<EOF
Installed Packages:
==================
$packages
EOF
    fi
    
    show_main_menu
}

# Function to refresh package list
refresh_list() {
    whiptail --msgbox "Package list refreshed." 10 50
    show_main_menu
}

# Function to uninstall a package
uninstall_package() {
    local packages
    packages=$(get_installed_packages)
    
    if [ -z "$packages" ]; then
        whiptail --msgbox "No packages installed." 10 50
        show_main_menu
        return
    fi
    
    # Create array from packages
    mapfile -t package_array <<< "$packages"
    
    # Create options for whiptail
    local options=()
    local i=1
    for pkg in "${package_array[@]}"; do
        options+=("$i" "$pkg")
        ((i++))
    done
    
    # Show package selection dialog
    local selected
    selected=$(whiptail --title "Uninstall Package" --menu "Select package to uninstall:" 15 60 8 "${options[@]}" 3>&1 1>&2 2>&3)
    
    if [ -n "$selected" ]; then
        local package="${package_array[$((selected-1))]}"
        
        # Confirm uninstall
        if whiptail --yesno "Are you sure you want to uninstall \"$package\"?" 10 50; then
            whiptail --infobox "Uninstalling $package..." 10 50
            
            # Run pkgdrop uninstall
            if pkgdrop -u "$package"; then
                whiptail --msgbox "Successfully uninstalled $package." 10 50
            else
                whiptail --msgbox "Failed to uninstall $package." 10 50
            fi
        fi
    fi
    
    show_main_menu
}

# Main execution
if ! command -v pkgdrop &> /dev/null; then
    whiptail --msgbox "pkgdrop command not found. Please ensure pkgdrop is installed and in PATH." 10 50
    exit 1
fi

if ! command -v whiptail &> /dev/null; then
    whiptail --msgbox "whiptail command not found. Please install newt package." 10 50
    exit 1
fi

# Start the GUI
show_main_menu