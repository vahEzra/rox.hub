echo "Latest Roblox Downloader -Dexaru.net"
clear
sleep 4
echo "Downloading Latest Roblox..."

# Fetch Roblox version info
robloxVersionInfo=$(curl -s "https://clientsettingscdn.roblox.com/v2/client-version/MacPlayer")
robloxVersion=$(echo $robloxVersionInfo | jq -r ".clientVersionUpload")
if [ -z "$robloxVersion" ]; then
  echo "Failed to fetch Roblox version. Exiting."
  exit 1
fi

# Download Roblox Player
robloxZipPath="/tmp/RobloxPlayer.zip"
curl -L "http://setup.rbxcdn.com/mac/$robloxVersion-RobloxPlayer.zip" -o "$robloxZipPath"
echo "Download complete."
sleep 2

# Install Roblox
echo "Installing Latest Roblox..."
[ -d "/Applications/Roblox.app" ] && rm -rf "/Applications/Roblox.app"
unzip -o -q "$robloxZipPath" -d /tmp
mv /tmp/RobloxPlayer.app "/Applications/Roblox.app"
rm "$robloxZipPath"
echo "Roblox installation complete."
sleep 2
