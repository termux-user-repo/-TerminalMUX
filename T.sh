#!/bin/bash

clear

echo "#######################"
echo "•     Welcome to sys •"
echo "#######################"

sleep 3

echo ""
read -p "         << Enter choice: " choice

if [ "$choice" = "1" ]; then
    echo " welcome haha 🤪 "
    # Add more commands here as needed
else
    echo "Invalid choice or nothing entered."
fi
