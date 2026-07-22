#!/bin/bash

# Check if correct arguments are passed
if [ $# -ne 1 ] || [ "$1" != "dev" -a "$1" != "ddev" -a "$1" != "merge"  -a "$1" != "prod1"  -a "$1" != "prod1old"  -a "$1" != "prod1new"  -a "$1" != "prod2"  -a "$1" != "prodbackup" -a "$1" != "prod" -a "$1" != "prodaws" ]; then
    echo "Usage: $0 [environment]"
    echo "Environment should be either 'dev', 'ddev', 'merge', 'prod1', 'prod1old', 'prod1new', 'prod2', 'prodbackup' or 'prod'."
    exit 1
fi

ENV="$1"

# Use the correct Flutter version
fvm use 3.32.8

# Update the package name
fvm dart update_package_name.dart "$ENV"

# Clean and get packages
fvm flutter clean
fvm flutter pub get

# Remove .fvm folder
rm -r ".fvm"

echo "✅ Package name and app name updated for environment: $ENV"

# Optionally pause the script if running interactively
read -p "Press any key to exit..."
