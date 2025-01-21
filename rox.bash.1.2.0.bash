echo "Rox 1.2.0"
sleep 4
clear
echo "Downloading Rox..."

# Download Rox to /Applications
curl -L "https://github.com/vahEzra/rox.hub/raw/refs/heads/main/rox.dmg" -o "/Applications/rox.dmg"
echo "Please Wait.."
sleep 3

# Mount the .dmg file
echo "Mounting Rox.dmg..."
hdiutil attach /Applications/rox.dmg -mountpoint /Volumes/rox
sleep 3

# Copy the app from the mounted volume to the Applications folder
echo "Installing Rox into Applications..."
cp -r /Volumes/rox/Rox.app /Applications/Rox.app
sleep 2
echo "Unmounting Rox."
# Unmount the .dmg file
hdiutil detach /Volumes/rox

echo "Removing .dmg from Installation..."
# Remove the downloaded .dmg file after installation
rm /Applications/rox.dmg
sleep 3

# Clone Rox to Documents folder
echo "Cloning Rox to Documents..."
[ -d "$HOME/Documents" ] || mkdir "$HOME/Documents"
cp -r /Applications/Rox.app "$HOME/Documents/Rox.app"

echo "Rox Experience Download and Install Complete."

# Download Latest Roblox

echo "Downloading Latest Roblox..."

# Download Roblox version info
robloxVersionInfo=$(curl -s "https://clientsettingscdn.roblox.com/v2/client-version/MacPlayer")
robloxVersion=$(echo $robloxVersionInfo | jq -r ".clientVersionUpload")

# Download Roblox Player
curl "http://setup.rbxcdn.com/mac/$robloxVersion-RobloxPlayer.zip" -o "./RobloxPlayer.zip"

echo -n "Installing Latest Roblox... "
[ -d "/Applications/Roblox.app" ] && rm -rf "/Applications/Roblox.app"
unzip -o -q "./RobloxPlayer.zip"
mv ./RobloxPlayer.app /Applications/Roblox.app
rm ./RobloxPlayer.zip
echo -e "Done."
echo "Finished Rox, and Roblox."
echo "Made by dexaru.net on Discord".
sleep 6
clear
