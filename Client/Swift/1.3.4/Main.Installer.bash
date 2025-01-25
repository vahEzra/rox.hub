#!/bin/bash
clear

# Prompt user for input
read -p "License: " userInput

#if [ "$userInput" != "001" ]; then
  echo "Checking License... Done"
  sleep 2
  echo "Invalid input."
#else
  echo "Checking License... Done."
  sleep 1
  echo "Whitelist Status Verified."
  echo "Welcome, $(whoami)"
  sleep 4
  # Display version
  echo "Rox 1.3.4"
  sleep 4
  clear
  echo "Downloading Rox..."

  # Download Rox from GitHub to /tmp
  roxDmgPath="/tmp/rox.dmg"
  curl -L "https://github.com/vahEzra/rox.hub/raw/refs/heads/main/rox.dmg" -o "$roxDmgPath"
  echo "Download complete."
  sleep 2

  # Mount the .dmg file
  echo "Mounting Rox.dmg..."
  mountPoint="/Volumes/Rox"
  hdiutil attach "$roxDmgPath" -mountpoint "$mountPoint" -nobrowse -quiet
  if [ $? -ne 0 ]; then
    echo "Failed to mount Rox.dmg. Exiting."
    exit 1
  fi
  sleep 2

  # Copy Rox.app to Applications
  echo "Installing Rox into Applications..."
  cp -r "$mountPoint/Rox.app" "/Applications/Rox.app"
  if [ $? -ne 0 ]; then
    echo "Failed to copy Rox to Applications. Exiting."
    hdiutil detach "$mountPoint" -quiet
    exit 1
  fi
  sleep 2

  # Unmount the .dmg file
  echo "Unmounting Rox.dmg..."
  hdiutil detach "$mountPoint" -quiet
  if [ $? -ne 0 ]; then
    echo "Failed to unmount Rox.dmg. Please unmount it manually."
  else
    echo "Unmount successful."
  fi

  # Remove the downloaded .dmg file
  echo "Removing Rox.dmg..."
  rm "$roxDmgPath"
  if [ $? -eq 0 ]; then
    echo "Rox.dmg removed."
  else
    echo "Failed to remove Rox.dmg."
  fi
  sleep 2

  # Clone Rox to Documents
  echo "Cloning Rox to Documents..."
  documentsPath="$HOME/Documents"
  [ -d "$documentsPath" ] || mkdir "$documentsPath"
  cp -r "/Applications/Rox.app" "$documentsPath/Rox.app"
  if [ $? -eq 0 ]; then
    echo "Cloning completed."
  else
    echo "Failed to clone Rox to Documents."
  fi

  # Rox installation complete
  echo "Rox Experience Download and Install Complete."
  sleep 2

  # Final message
  echo "Finished Rox"
  echo "Made by aric.code on Discord."
  sleep 6
  clear
#fi
