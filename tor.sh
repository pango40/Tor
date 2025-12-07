#!/bin/bash

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
MAGENTA="\033[1;35m"
WHITE="\033[1;37m"
RESET="\033[0m"

# Function to check and install requirements
check_requirements() {
    echo -e "${CYAN}[*] Checking requirements...${RESET}"
    
    # Check for curl
    if ! command -v curl &> /dev/null; then
        echo -e "${YELLOW}[!] curl not found. Installing...${RESET}"
        if [[ -d /data/data/com.termux/files/usr ]]; then
            pkg install curl -y
        else
            sudo apt-get install curl -y
        fi
    fi
    
    # Check for tor
    if ! command -v tor &> /dev/null; then
        echo -e "${RED}[!] Tor is not installed!${RESET}"
        echo -e "${YELLOW}[*] Installing Tor...${RESET}"
        if [[ -d /data/data/com.termux/files/usr ]]; then
            pkg install tor -y
        else
            echo -e "${YELLOW}[*] Please install Tor manually:${RESET}"
            echo -e "${CYAN}   sudo apt-get install tor${RESET}"
            exit 1
        fi
    fi
    
    # Check for netcat (nc)
    if ! command -v nc &> /dev/null; then
        echo -e "${YELLOW}[!] netcat not found. Installing...${RESET}"
        if [[ -d /data/data/com.termux/files/usr ]]; then
            pkg install netcat-openbsd -y
        else
            sudo apt-get install netcat -y
        fi
    fi
    
    echo -e "${GREEN}[✓] All requirements satisfied${RESET}"
}

# Function to show banner
show_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════╗"
    echo "║                                                      ║"
    echo "║         ▒█▀▀▀ ▒█▀▀▀█ ▒█▀▀█ ▒█▀▀▀█ ▒█▀▀█ ▒█▀▀▀█       ║"
    echo "║         ▒█▀▀▀ ▒█░░▒█ ▒█▄▄▀ ▒█░░▒█ ▒█▄▄█ ▒█░░▒█       ║"
    echo "║         ▒█░░░ ▒█▄▄▄█ ▒█░▒█ ▒█▄▄▄█ ▒█░░░ ▒█▄▄▄█       ║"
    echo "║                                                      ║"
    echo "║         ██████╗ ██████╗ ██╗████████╗ ██████╗         ║"
    echo "║        ██╔═══██╗██╔══██╗██║╚══██╔══╝██╔═══██╗        ║"
    echo "║        ██║   ██║██████╔╝██║   ██║   ██║   ██║        ║"
    echo "║        ██║   ██║██╔══██╗██║   ██║   ██║   ██║        ║"
    echo "║        ╚██████╔╝██████╔╝██║   ██║   ╚██████╔╝        ║"
    echo "║         ╚═════╝ ╚═════╝ ╚═╝   ╚═╝    ╚═════╝         ║"
    echo "║                                                      ║"
    echo "║              I N F I N I T E   T S U K U Y O M I     ║"
    echo "║               A N O N Y M I T Y   T O O L            ║"
    echo "║                                                      ║"
    echo "╚══════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

# Function to show system info
show_system_info() {
    echo -e "${MAGENTA}╔══════════════════════════════════════════════════════╗${RESET}"
    echo -e "${MAGENTA}║               S Y S T E M   I N F O                  ║${RESET}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════════════════╝${RESET}"
    
    echo -e "${CYAN}┌──────────────────────────────────────────────────────┐${RESET}"
    echo -e "${YELLOW}├─ User:${WHITE} $(whoami)${RESET}"
    echo -e "${YELLOW}├─ Host:${WHITE} $(hostname)${RESET}"
    echo -e "${YELLOW}├─ Time:${WHITE} $(date '+%Y-%m-%d %H:%M:%S')${RESET}"
    
    # Get initial IP with error handling
    echo -e -n "${YELLOW}├─ Initial IP:${WHITE} "
    local_ip=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "127.0.0.1")
    echo -e "${local_ip}${RESET}"
    
    # Try to get public IP
    echo -e -n "${YELLOW}├─ Public IP:${WHITE} "
    public_ip=$(curl -s --max-time 5 ifconfig.me 2>/dev/null || echo "Not available")
    echo -e "${public_ip}${RESET}"
    
    echo -e "${CYAN}└──────────────────────────────────────────────────────┘${RESET}"
}

# Function to show contact info
show_contact_info() {
    echo -e "\n${YELLOW}╔══════════════════════════════════════════════════════╗${RESET}"
    echo -e "${YELLOW}║                 C O N T A C T   I N F O               ║${RESET}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════════╝${RESET}"
    
    echo -e "${BLUE}┌──────────────────────────────────────────────────────┐${RESET}"
    echo -e "${CYAN}├─ Telegram:${RESET}"
    echo -e "${WHITE}│   ● https://t.me/Mr_WEBts${RESET}"
    echo -e "${CYAN}├─ GitHub:${RESET}"
    echo -e "${WHITE}│   ● https://github.com/pango40${RESET}"
    echo -e "${BLUE}└──────────────────────────────────────────────────────┘${RESET}"
}

# Function to start Tor
start_tor() {
    echo -e "\n${CYAN}[*] Starting Tor service...${RESET}"
    
    # Check if Tor is already running
    if pgrep -x "tor" > /dev/null; then
        echo -e "${YELLOW}[!] Tor is already running${RESET}"
        return 0
    fi
    
    # Start Tor in background
    tor --RunAsDaemon 1 --SocksPort 9050 --ControlPort 9051 &
    TOR_PID=$!
    
    # Wait for Tor to start
    echo -e "${CYAN}[*] Waiting for Tor to initialize...${RESET}"
    sleep 10
    
    # Check if Tor started successfully
    if ! ps -p $TOR_PID > /dev/null; then
        echo -e "${RED}[!] Failed to start Tor${RESET}"
        return 1
    fi
    
    echo -e "${GREEN}[✓] Tor started successfully (PID: $TOR_PID)${RESET}"
    return 0
}

# Function to get IP through Tor
get_tor_ip() {
    local max_retries=3
    local retry_count=0
    
    while [ $retry_count -lt $max_retries ]; do
        local tor_ip=$(curl --socks5 localhost:9050 --socks5-hostname localhost:9050 -s --max-time 10 ifconfig.me 2>/dev/null)
        
        if [ -n "$tor_ip" ] && [ "$tor_ip" != "" ]; then
            echo "$tor_ip"
            return 0
        fi
        
        retry_count=$((retry_count + 1))
        echo -e "${YELLOW}[!] Retry $retry_count/$max_retries to get Tor IP...${RESET}"
        sleep 2
    done
    
    echo "Failed"
    return 1
}

# Function to request new identity
request_new_identity() {
    local max_retries=3
    local retry_count=0
    
    while [ $retry_count -lt $max_retries ]; do
        echo -e 'AUTHENTICATE ""\nSIGNAL NEWNYM\nQUIT' | nc -w 5 localhost 9051 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[✓] New Tor identity requested at $(date '+%H:%M:%S')${RESET}"
            return 0
        fi
        
        retry_count=$((retry_count + 1))
        sleep 1
    done
    
    echo -e "${RED}[!] Failed to request new identity${RESET}"
    return 1
}

# Function to show countdown
show_countdown() {
    local seconds=$1
    local message=$2
    
    echo -e "${BLUE}[*] $message${RESET}"
    for ((i=seconds; i>0; i--)); do
        printf "\r${YELLOW}[*] Time remaining: %02ds${RESET}" "$i"
        sleep 1
    done
    echo -e "\r${GREEN}[✓] Starting next rotation...${RESET}          "
}

# Main function
main() {
    # Check requirements first
    check_requirements
    
    # Show banner and info
    show_banner
    show_system_info
    show_contact_info
    
    echo -e "\n${RED}Press ENTER to start IP rotation or Ctrl+C to exit${RESET}"
    read -p ""
    
    # Start Tor
    if ! start_tor; then
        echo -e "${RED}[!] Cannot continue without Tor${RESET}"
        exit 1
    fi
    
    # Get initial IP
    echo -e "${CYAN}[*] Getting initial Tor IP...${RESET}"
    INITIAL_IP=$(get_tor_ip)
    
    if [ "$INITIAL_IP" = "Failed" ]; then
        echo -e "${RED}[!] Cannot get Tor IP. Check Tor configuration${RESET}"
        exit 1
    fi
    
    echo -e "${GREEN}[✓] Initial Tor IP: ${YELLOW}$INITIAL_IP${RESET}"
    
    echo -e "\n${RED}╔══════════════════════════════════════════════════════╗${RESET}"
    echo -e "${RED}║       I P   R O T A T I O N   A C T I V E             ║${RESET}"
    echo -e "${RED}╚══════════════════════════════════════════════════════╝${RESET}"
    
    echo -e "${WHITE}Rotating IP every 1 minute...${RESET}"
    ROTATION=1
    
    # Main rotation loop
    while true; do
        echo -e "\n${YELLOW}┌──────────────────────────────────────────────────────┐${RESET}"
        echo -e "${YELLOW}│               R O T A T I O N   #$ROTATION                │${RESET}"
        echo -e "${YELLOW}└──────────────────────────────────────────────────────┘${RESET}"
        
        # Request new identity
        request_new_identity
        
        # Get new IP
        sleep 3
        NEW_IP=$(get_tor_ip)
        
        if [ "$NEW_IP" != "Failed" ]; then
            echo -e "${CYAN}[+] New IP: ${YELLOW}$NEW_IP${RESET}"
        else
            echo -e "${RED}[!] Failed to get new IP${RESET}"
        fi
        
        # Rotation counter
        echo -e "${MAGENTA}[+] Total rotations: $ROTATION${RESET}"
        
        # Wait for next rotation
        show_countdown 60 "Next rotation in 60 seconds..."
        
        ROTATION=$((ROTATION + 1))
    done
}

# Cleanup function
cleanup() {
    echo -e "\n${RED}[!] Stopping Tor and cleaning up...${RESET}"
    pkill -f tor 2>/dev/null
    exit 0
}

# Set trap for cleanup
trap cleanup INT TERM EXIT

# Run main function
main "$@"
