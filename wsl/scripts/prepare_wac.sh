#!/bin/bash


# DEFINITIONS

## Prepare the AUTOCONFIG directories
prepare() {
    # Create the AUTOCONFIG_DIR 
    if [ -d "$AUTOCONFIG_DIR" ]; then
        INFO "AUTOCONFIG directory already exists"
    else
        INFO "Creating AUTOCONFIG directory..."
        err mkdir -p "$AUTOCONFIG_DIR"
    fi

    # Create the AUTOCONFIG_BACKUPS_DIR
    if [ -d "$AUTOCONFIG_BACKUPS_DIR" ]; then
        INFO "AUTOCONFIG backups directory already exists"
    else
        INFO "Creating AUTOCONFIG backups directory..."
        err mkdir -p "$AUTOCONFIG_BACKUPS_DIR"
    fi

    # Array of directory names to be created
    directories=("config" "bash" "profile")

    # Loop through each directory name in the array
    for dir in "${directories[@]}"; do
        # Check if the directory already exists
        if [ -d "$AUTOCONFIG_BACKUPS_DIR/$dir" ]; then
            INFO "AUTOCONFIG backups ${dir} directory already exists"
        else
            INFO "Creating AUTOCONFIG backups ${dir} directory..."
            err mkdir -p "$AUTOCONFIG_BACKUPS_DIR/$dir"
        fi
    done
}

## Backup existing AUTOCONFIG configuration
backup() {
    # This script copies the assets from WSL folder to the AUTOCONFIG_DIR
    # Backup exitig config folder
    if [ -d "$AUTOCONFIG_DIR/config" ]; then
        INFO "Backing up existing config folder ..."
        INFO "Only the latest config will be stored, older configs will be overwritten ..."
        err mv "$AUTOCONFIG_DIR/config" "${AUTOCONFIG_BACKUPS_DIR}/config/config_wac_$(date +%Y%m%d%H%M%S).bak"
        INFO "Backups stored in ${AUTOCONFIG_BACKUPS_DIR}/config/config_wac_$(date +%Y%m%d%H%M%S).bak"
    else
        INFO "No existing config folder found ..."
        INFO "Proceeding with installation ..."
    fi
}

## Copy the assets to the AUTOCONFIG_DIR
copy_config() {
    # Copy the assets to the AUTOCONFIG_DIR
    INFO "Copying assets to the autoconfig directory ..."
    err cp -r "$CUR_DIR/wsl/config" "$AUTOCONFIG_DIR"
}

# Main

## Imform the user that AUTOCONFIG directories are being created
echo -e "\n"
WARN -n "Step $((++STEP)): "
WARN "Creating AUTOCONFIG directories..."
WARN "${DELIMITER}"

prepare


## Prompt the user to create backups of existing AUTOCONFIG configuration
echo -e "\n"
WARN -n "Step $((++STEP)): "
WARN "Creating backups of existing AUTOCONFIG configuration..."
WARN "${DELIMITER}"


if [ "$SILENT_MODE" = false ]; then
    # shellcheck disable=SC1091
    read -r -p "Proceed with creating AUTOCONFIG backups? [Y/N]  " yn
    case $yn in
        [Yy]* ) backup;;
        [Nn]* ) 
                echo -n "Skipping creating backups ..."
                # shellcheck disable=SC2034
                for i in {1..8}; do echo -n "." && sleep 0.25; done;;
        * ) echo "Please answer Y or N.";;
    esac
else
    backup
fi

## Prompt the user that new AUTOCONFIG assets are being copied to the AUTOCONFIG_DIR
echo -e "\n"
WARN -n "Step $((++STEP)): "
WARN "Copying new AUTOCONFIG configurations..."
WARN "${DELIMITER}"

copy_config