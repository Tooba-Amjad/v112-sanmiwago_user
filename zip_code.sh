#!/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install jq first."
    exit 1
fi

# Check if environment argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 [environment]"
    exit 1
fi

ENV="$1"

# Only proceed if ENV contains "prod"
if [[ "$ENV" != *prod* ]]; then
    echo "Skipping zip: Environment '$ENV' is not a prod environment."
    exit 0
fi

# Function to get current date and time
get_datetime() {
    date +"%b%dy%Y"
}

# Function to extract the build count from build_count.json
get_build_count() {
    local env="$1"
    jq -r ".${env}.count" "build_count.json"
}

# Paths
PROJECT_ROOT="C:/GitHub-Repos/Winnie/User-App/sanmiwago_user_dev"
cd "$PROJECT_ROOT" || exit

# Create ZIPS folder if not exists
ZIP_OUTPUT_DIR="C:\GitHub-Repos\Zips"
mkdir -p "$ZIP_OUTPUT_DIR"

# Get values
DATETIME=$(get_datetime)
BUILD_COUNT=$(get_build_count "$ENV")

# Build zip filename
#ZIP_NAME="sanmiwago_user_${ENV}_${BUILD_COUNT}_${DATETIME}.zip"
ZIP_NAME="${ZIP_OUTPUT_DIR}/v${BUILD_COUNT}-sanmiwago_user-${ENV}-${DATETIME}.zip"


# Create zip, EXCLUDING build and .fvm folders
zip -r "$ZIP_NAME" . -x "build/*" ".fvm/*" ".dart_tool/*" "windows/*"

# Done
echo "Created zip: $ZIP_NAME (excluding build/, .fvm/ .dart_tool/ windows/ folders)"

# Open the ZIPS folder automatically
explorer.exe "$ZIP_OUTPUT_DIR"

# Pause to keep Git Bash window open
#read -p "Press any key to continue..."
