#!/bin/bash

#+ command to run this script is: ./clean.sh


# Run Flutter build selection command
fvm use 3.32.8

# Clean
fvm flutter clean

# Pub get
fvm flutter pub get

# Remove .fvm folder
rm -r ".fvm"