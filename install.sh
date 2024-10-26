#!/bin/bash

# Constants
SOURCES_FILE="/etc/apt/sources.list"
MIRRORS_LIST_URL="http://mirrors.ubuntu.com/IR.txt"

# Colors
RED=$'\e[0;31m'
GREEN=$'\e[0;32m'
YELLOW=$'\e[0;33m'
NC=$'\e[0m'

# Fixed mirrors array (ordered)
MIRROR_NAMES=(
    "Faraso"
    "Pishgaman"
    "IranServer"
    "ArvanCloud"
    "Sindad"
    "Shatel"
    "HostIran"
    "IUT"
    "ParsVDS"
)

declare -A MIRROR_URLS=(
    ["Faraso"]="http://mirror.faraso.org/ubuntu/"
    ["Pishgaman"]="http://ubuntu.pishgaman.net/ubuntu/"
    ["IranServer"]="http://mirror.iranserver.com/ubuntu/"
    ["ArvanCloud"]="http://mirror.arvancloud.ir/ubuntu/"
    ["Sindad"]="http://ir.ubuntu.sindad.cloud/ubuntu/"
    ["Shatel"]="http://ubuntu.shatel.ir/ubuntu/"
    ["HostIran"]="http://ubuntu.hostiran.ir/ubuntu/"
    ["IUT"]="http://repo.iut.ac.ir/repo/Ubuntu/"
    ["ParsVDS"]="http://ubuntu.parsvds.com/ubuntu/"
)

# Create symlink to script
create_command_link() {
    if [[ ! -f "/usr/local/bin/mirror" ]]; then
        ln -s "$(readlink -f "$0")" "/usr/local/bin/mirror"
        chmod +x "/usr/local/bin/mirror"
        echo "${GREEN}Command 'mirror' installed successfully${NC}"
    fi
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "${RED}Please run as root (use sudo)${NC}"
    exit 1
fi

# Create mirror command if doesn't exist
create_command_link

# Function to get current mirror
get_current_mirror() {
    local current_mirror=$(grep -m 1 "^deb http" "$SOURCES_FILE" | awk '{print $2}')
    echo "$current_mirror"
}

# Function to update sources.list
update_sources_list() {
    local mirror=$1
    local codename=$(lsb_release -cs)
    
    # Validate mirror URL
    if [[ ! $mirror =~ ^https?:// ]]; then
        echo "${RED}Invalid mirror URL. Must start with http:// or https://${NC}"
        return 1
    fi

    # Ensure mirror URL ends with trailing slash
    [[ $mirror != */ ]] && mirror="${mirror}/"
    
    cat > "$SOURCES_FILE" <<EOL
# Main repository
deb $mirror $codename main restricted universe multiverse
deb $mirror $codename-updates main restricted universe multiverse
deb $mirror $codename-backports main restricted universe multiverse
deb-src $mirror $codename main restricted universe multiverse
deb-src $mirror $codename-updates main restricted universe multiverse
deb-src $mirror $codename-backports main restricted universe multiverse

# Security updates
deb http://security.ubuntu.com/ubuntu $codename-security main restricted universe multiverse
deb-src http://security.ubuntu.com/ubuntu $codename-security main restricted universe multiverse
EOL

    echo "${GREEN}Sources list updated successfully${NC}"
    echo "Using mirror: ${YELLOW}$mirror${NC}"
}

# Function to get regional mirror
get_regional_mirror() {
    local country_code=$(curl -s https://ipapi.co/country)
    echo "https://${country_code,,}.archive.ubuntu.com/ubuntu/"
}

# Main menu
show_menu() {
    clear
    echo "${GREEN}Ubuntu Mirror Changer${NC}"
    echo "==================="
    
    # Show current mirror
    local current_mirror=$(get_current_mirror)
    echo "${YELLOW}Current Mirror:${NC} $current_mirror"
    echo "==================="
    echo

    echo "${YELLOW}Iranian Mirrors:${NC}"
    echo "------------------"
    
    # Iranian mirrors (using ordered array)
    local i=1
    for name in "${MIRROR_NAMES[@]}"; do
        echo "$i) $name"
        ((i++))
    done

    echo
    echo "${YELLOW}Other Options:${NC}"
    echo "------------------"
    echo "$i) Ubuntu Official (archive.ubuntu.com)"
    ((i++))
    echo "$i) Ubuntu Regional (Based on your location)"
    ((i++))
    echo "$i) Custom Mirror URL"
    ((i++))
    echo "$i) Get mirrors from official list"
    ((i++))
    echo "$i) Exit"
    
    echo
    echo -n "Select an option [1-$i]: "
}

# Main loop
while true; do
    show_menu
    read choice

    max_options=$((${#MIRROR_NAMES[@]} + 5))
    
    if [[ ! $choice =~ ^[0-9]+$ ]] || [ $choice -lt 1 ] || [ $choice -gt $max_options ]; then
        echo "${RED}Invalid option${NC}"
        sleep 1
        continue
    fi

    if [ $choice -le ${#MIRROR_NAMES[@]} ]; then
        # Iranian mirrors
        mirror_name="${MIRROR_NAMES[$((choice-1))]}"
        update_sources_list "${MIRROR_URLS[$mirror_name]}"
    else
        # Calculate offset for other options
        offset=$((choice - ${#MIRROR_NAMES[@]}))
        case $offset in
            1)
                update_sources_list "http://archive.ubuntu.com/ubuntu/"
                ;;
            2)
                regional_mirror=$(get_regional_mirror)
                update_sources_list "$regional_mirror"
                ;;
            3)
                echo -n "Enter custom mirror URL (e.g., http://mirror.example.com/ubuntu/): "
                read custom_url
                update_sources_list "$custom_url"
                ;;
            4)
                echo "${YELLOW}Fetching mirrors list from Ubuntu...${NC}"
                curl -s "$MIRRORS_LIST_URL"
                echo
                echo -n "Press Enter to continue..."
                read
                continue
                ;;
            5)
                echo "${GREEN}Exiting...${NC}"
                exit 0
                ;;
        esac
    fi

    if [ $? -eq 0 ]; then
        echo "${YELLOW}Updating package lists...${NC}"
        apt-get update >/dev/null 2>&1
        echo "${GREEN}Package lists updated successfully!${NC}"
    fi

    echo
    echo -n "Press Enter to continue..."
    read
done
