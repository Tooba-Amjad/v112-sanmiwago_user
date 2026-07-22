#!/bin/bash

# Check if correct arguments are passed
if [ $# -ne 1 ] || [ "$1" != "prod2" -a "$1" != "prod" ]; then
    echo "Usage: $0 [environment]"
    echo "Environment should be either 'prod2' or 'prod'."
    read -p "Press any key to continue..."
    exit 1
fi

ENV="$1"

# Use the correct Flutter version
fvm use 3.32.8

# Update the count and date
fvm dart build_count_handler.dart "$ENV"

# Update the package name
fvm dart update_package_name.dart "$ENV"

# Clean and get packages
fvm flutter clean
fvm flutter pub get

# Now build the AAB
# fvm flutter build aab --dart-define=env="prod"
# fvm flutter build aab --dart-define=env="$ENV"

fvm flutter build aab --dart-define=env="$ENV"

# Rename the APK
#fvm dart rename_apk.dart "$ENV"

# 📦 Now create the zip, after build count has updated
bash ./zip_code.sh "$ENV"

# Remove .fvm folder
rm -r ".fvm"

# Open APK output folder
APK_DIR="C:/GitHub-Repos/Winnie/User/sanmiwago_user_dev/build/app/outputs/bundle/release"
cd "$APK_DIR" || exit
start .

# Pause
read -p "Press any key to continue..."