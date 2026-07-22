#!/bin/bash

# Check if correct arguments are passed
if [ $# -ne 1 ] || [ "$1" != "dev" -a "$1" != "ddev" -a "$1" != "merge"  -a "$1" != "prod1"  -a "$1" != "prod1old"  -a "$1" != "prod1new"  -a "$1" != "prod2"  -a "$1" != "prodbackup" -a "$1" != "prod" -a "$1" != "prodaws" ]; then
    echo "Usage: $0 [environment]"
    echo "Environment should be either 'dev', 'ddev', 'merge', 'prod1', 'prod2', 'prod1old', 'prod1new', 'prod2', 'prodbackup' or 'prod'."
    exit 1
fi

ENV="$1"

if [ "$ENV" = "prod2" ]; then
  ENV="prod"
fi

# Use the correct Flutter version
fvm use 3.32.8

# Update the count and date
fvm dart build_count_handler.dart "$ENV"

# Update the package name
fvm dart update_package_name.dart "$ENV"

# Clean and get packages
fvm flutter clean
fvm flutter pub get

# Now build the APK
# fvm flutter build apk --dart-define=env="prod"
# fvm flutter build aab --dart-define=env="$ENV"

fvm flutter build apk --release --dart-define=env="$ENV"

# Rename the APK
fvm dart rename_apk.dart "$ENV"

# 📦 Now create the zip, after build count has updated
bash ./zip_code.sh "$ENV"

# Remove .fvm folder
rm -r ".fvm"

# Open APK output folder
APK_DIR="C:/GitHub-Repos/Winnie/User-App/sanmiwago_user_dev/build/app/outputs/flutter-apk/"
cd "$APK_DIR" || exit
start .

# Pause
read -p "Press any key to continue..."