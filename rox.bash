echo "Rox 1.2.0"
sleep 4
clear
echo "Downloading Rox.."

curl -L "https://github.com/vahEzra/rox.hub/raw/refs/heads/main/rox.dmg" -o "./rox.dmg"
echo "Please Wait.."
sleep 3

[ -d "Applications" ] || mkdir "Applications"
echo -e "Downloading Latest Roblox..."

# Download Roblox version info
robloxVersionInfo=$(curl -s "https://clientsettingscdn.roblox.com/v2/client-version/MacPlayer")
robloxVersion=$(echo $robloxVersionInfo | jq -r ".clientVersionUpload")

# Download Roblox Player
curl "http://setup.rbxcdn.com/mac/$robloxVersion-RobloxPlayer.zip" -o "./RobloxPlayer.zip"

echo -n "Installing Latest Roblox... "
[ -d "Applications/Roblox.app" ] && rm -rf "Applications/Roblox.app"
unzip -o -q "./RobloxPlayer.zip"
mv ./RobloxPlayer.app ./Applications/Roblox.app
rm ./RobloxPlayer.zip
echo -e "Done."
echo "Rox Experience Download end"
