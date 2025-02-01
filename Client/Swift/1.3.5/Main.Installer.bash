#!/bin/bash

# Hello there

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

progress_bar() {
    local duration=$1
    local width=50
    local progress=0
    local bar_char="━"
    local empty_char="─"

    while [ $progress -le 100 ]; do
        local filled=$((progress * width / 100))
        local empty=$((width - filled))
        
        printf "\r${BLUE}["
        printf "%${filled}s" | tr " " "$bar_char"
        printf "%${empty}s" | tr " " "$empty_char"
        printf "] %3d%%${NC}" $progress
        
        progress=$((progress + 2))
        sleep $(echo "scale=2; $duration/50" | bc)
    done
    printf "\n"
}

spinner() {
    local pid=$1

    local delay=0.1
    local spinstr='.oOo'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf "\r${CYAN}[%c]${NC} " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    printf "\r   \r"
}

clear
echo -e "${BLUE}"
cat << "EOF"

██████╗░░█████╗░██╗░░██╗
██╔══██╗██╔══██╗╚██╗██╔╝
██████╔╝██║░░██║░╚███╔╝░
██╔══██╗██║░░██║░██╔██╗░
██║░░██║╚█████╔╝██╔╝╚██╗
╚═╝░░╚═╝░╚════╝░╚═╝░░╚═╝

EOF
echo -e "${NC}"

echo -e "                  ${WHITE}Version ${appVersion}${NC} - ${CYAN}Beta${NC}"
echo -e "              ${WHITE}Created by Aric.Codes${NC}"
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "${CYAN}⚡ System Check${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [[ "$(uname)" != "Darwin" ]]; then
    echo -e "${RED}✘ Error: This installer is only for MacOS systems${NC}"
    exit 1
else
    echo -e "${GREEN}✓${NC} MacOS detected"
fi

if ! command -v curl &> /dev/null; then
    echo -e "${RED}✘ Error: curl is not installed${NC}"
    exit 1
else
    echo -e "${GREEN}✓${NC} curl is installed"
fi

detect_arch() {
    local arch=$(uname -m)
    case "$arch" in
        arm64|aarch64)
            echo "arm"
            ;;
        x86_64)
            echo "intel"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

DETECTED_ARCH=$(detect_arch)
ARCH=${ARCH:-$DETECTED_ARCH}

case "$ARCH" in
    arm|arm64|aarch64)
        ARCH="arm"
        echo -e "${GREEN}✓${NC} Apple Silicon detected"
        ;;
    intel|x64|x86_64)
        ARCH="intel"
        echo -e "${GREEN}✓${NC} Intel processor detected"
        ;;
    *)
        echo -e "${RED}✘ Error: Unsupported architecture: ${ARCH}${NC}"
        exit 1
        ;;
esac

echo -e "\n${CYAN}⚡ Installation Setup${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}! Your Mac password is required to install the application${NC}"
    if ! sudo -v; then
        echo -e "${RED}✘ Error: Failed to obtain administrator privileges${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓${NC} Administrator access granted"
fi

DOWNLOAD_URL=""
if [ "$ARCH" = "arm" ]; then
    DOWNLOAD_URL="https://limewire.com/d/5403e3a5-e222-4756-b911-7f5b291afa9f#AJViwNOooSuRWckTK0pQRFV76L0nzfbrKv1i3x_eYzw"
else
    DOWNLOAD_URL="https://limewire.com/d/5403e3a5-e222-4756-b911-7f5b291afa9f#AJViwNOooSuRWckTK0pQRFV76L0nzfbrKv1i3x_eYzw"
fi

echo -e "\n${CYAN}⚡ Downloading Rox${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

TEMP_DMG=$(mktemp)
curl -L -o "$TEMP_DMG" "$DOWNLOAD_URL" 2>/dev/null & spinner $!

if [ -f "$TEMP_DMG" ] && [ -s "$TEMP_DMG" ]; then
    progress_bar 2
    echo -e "${GREEN}✓${NC} Download completed successfully"
else
    echo -e "${RED}✘ Download failed. Please check your internet connection${NC}"
    rm -f "$TEMP_DMG" 2>/dev/null
    exit 1
fi

echo -e "\n${CYAN}⚡ Installing Rox${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "${WHITE}▶${NC} Mounting disk image..."
MOUNT_OUTPUT=$(hdiutil attach -nobrowse "$TEMP_DMG" 2>&1)
MOUNT_POINT=$(echo "$MOUNT_OUTPUT" | grep /Volumes/ | cut -f 3-)

if [ -z "$MOUNT_POINT" ]; then
    echo -e "${RED}✘ Failed to mount disk image${NC}"
    echo -e "${RED}Error: $MOUNT_OUTPUT${NC}"
    rm -f "$TEMP_DMG" 2>/dev/null
    exit 1
fi
echo -e "${GREEN}✓${NC} Disk image mounted at: $MOUNT_POINT"

if [ -d "/Applications/Rox.app" ]; then
    echo -e "${WHITE}▶${NC} Closing Rox if running..."
    osascript -e 'quit app "Rox"' 2>/dev/null
    sleep 2
    echo -e "${WHITE}▶${NC} Removing previous installation..."
    sudo rm -rf "/Applications/Rox.app"
    echo -e "${GREEN}✓${NC} Previous installation removed"
fi

echo -e "${WHITE}▶${NC} Copying files to Applications folder..."
sudo cp -R "$MOUNT_POINT/Rox.app" /Applications/

if [ -d "/Applications/Rox.app" ]; then
    sudo chown -R root:wheel "/Applications/Rox.app" 2>/dev/null
    sudo chmod -R 755 "/Applications/Rox.app" 2>/dev/null
    progress_bar 1
    echo -e "${GREEN}✓${NC} Application installed successfully"
else
    echo -e "${RED}✘ Failed to copy application${NC}"
    hdiutil detach "$MOUNT_POINT" >/dev/null 2>&1
    rm -f "$TEMP_DMG" 2>/dev/null
    exit 1
fi

echo -e "${WHITE}▶${NC} Cleaning up..."
(hdiutil detach "$MOUNT_POINT" >/dev/null && rm -f "$TEMP_DMG") & spinner $!
echo -e "${GREEN}✓${NC} Cleanup completed"

echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✨ Installation Complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo -e "${YELLOW}Important Notes:${NC}"
echo -e "  ${WHITE}•${NC} Rox has been installed to your Applications folder"
echo -e "\n${GREEN}Thank you for installing Rox!${NC}\n"

echo -e "${WHITE}▶${NC} Launching Rox..."
open -a "Applications/Rox.app"
echo -e "${GREEN}✓${NC} Application launched\n"

