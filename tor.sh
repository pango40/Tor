#!/bin/bash

# Colors
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
CYAN="\e[36m"
MAGENTA="\e[35m"
BOLD="\e[1m"
RESET="\e[0m"

# ASCII Logo for obitõ - Clean Version
echo -e "${CYAN}${BOLD}"
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

# System Information
echo -e "${MAGENTA}${BOLD}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${MAGENTA}${BOLD}║               S Y S T E M   I N F O                  ║${RESET}"
echo -e "${MAGENTA}${BOLD}╚══════════════════════════════════════════════════════╝${RESET}"

echo -e "${CYAN}${BOLD}┌──────────────────────────────────────────────────────┐${RESET}"
echo -e "${YELLOW}├─ User:${RESET} $(whoami)"
echo -e "${YELLOW}├─ Host:${RESET} $(hostname)"
echo -e "${YELLOW}├─ Time:${RESET} $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "${YELLOW}├─ Initial IP:${RESET} $(curl -s ifconfig.me 2>/dev/null || echo 'Not available')"
echo -e "${CYAN}${BOLD}└──────────────────────────────────────────────────────┘${RESET}"

# Contact Information
echo -e "\n${YELLOW}${BOLD}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${YELLOW}${BOLD}║                 C O N T A C T   I N F O               ║${RESET}"
echo -e "${YELLOW}${BOLD}╚══════════════════════════════════════════════════════╝${RESET}"

echo -e "${BLUE}${BOLD}┌──────────────────────────────────────────────────────┐${RESET}"
echo -e "${CYAN}├─ Telegram:${RESET}"
echo -e "${BLUE}│   ${YELLOW}● ${CYAN}https://t.me/Mr_WEBts${RESET}"
echo -e "${CYAN}├─ GitHub:${RESET}"
echo -e "${BLUE}│   ${YELLOW}● ${CYAN}https://github.com/pango40${RESET}"
echo -e "${BLUE}└──────────────────────────────────────────────────────┘${RESET}"

echo -e "\n${RED}${BOLD}Press ENTER to start Tor or Ctrl+C to exit${RESET}"
read -p ""

# Check if Tor is installed
if ! command -v tor &> /dev/null; then
    echo -e "${RED}${BOLD}[!] Tor is not installed!${RESET}"
    echo -e "${YELLOW}[*] Installing Tor...${RESET}"
    
    # Check if we're on Termux
    if [[ -d /data/data/com.termux/files/usr ]]; then
        pkg update && pkg install tor -y
    else
        echo -e "${RED}[!] Please install Tor manually:${RESET}"
        echo -e "${CYAN}For Debian/Ubuntu: sudo apt install tor${RESET}"
        echo -e "${CYAN}For Termux: pkg install tor${RESET}"
        exit 1
    fi
fi

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo -e "${RED}${BOLD}[!] curl is not installed!${RESET}"
    echo -e "${YELLOW}[*] Installing curl...${RESET}"
    
    if [[ -d /data/data/com.termux/files/usr ]]; then
        pkg install curl -y
    else
        sudo apt install curl -y || echo -e "${RED}[!] Failed to install curl${RESET}"
    fi
fi

# Start Tor in the background
echo -e "${CYAN}${BOLD}[+] Starting Tor service...${RESET}"
tor &
TOR_PID=$!

# Wait a few seconds for Tor to initialize
echo -e "${YELLOW}[*] Waiting for Tor to start (10 seconds)...${RESET}"
sleep 10

# Get initial IP through Tor
echo -e "${CYAN}[+] Getting initial IP through Tor...${RESET}"
INITIAL_IP=$(curl --socks5 localhost:9050 -s ifconfig.me 2>/dev/null)

if [ -z "$INITIAL_IP" ] || [ "$INITIAL_IP" = "" ]; then
    echo -e "${RED}[!] Failed to get IP through Tor${RESET}"
    echo -e "${YELLOW}[*] Checking Tor status...${RESET}"
    
    # Check if Tor is running
    if ps -p $TOR_PID > /dev/null; then
        echo -e "${GREEN}[+] Tor is running (PID: $TOR_PID)${RESET}"
        echo -e "${YELLOW}[*] Waiting a bit more...${RESET}"
        sleep 5
        INITIAL_IP=$(curl --socks5 localhost:9050 -s ifconfig.me 2>/dev/null)
    else
        echo -e "${RED}[!] Tor process died!${RESET}"
        exit 1
    fi
fi

echo -e "${GREEN}${BOLD}✅ Tor started successfully!${RESET}"
echo -e "${CYAN}[+] Tor IP: ${YELLOW}$INITIAL_IP${RESET}"

echo -e "\n${RED}${BOLD}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${RED}${BOLD}║       I P   R O T A T I O N   A C T I V E             ║${RESET}"
echo -e "${RED}${BOLD}╚══════════════════════════════════════════════════════╝${RESET}"

echo "Rotating IP every 1 minute..."
ROTATION=1

# Function to request new identity
request_new_identity() {
    echo -e 'AUTHENTICATE ""\nSIGNAL NEWNYM\nQUIT' | nc localhost 9051 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[+] New Tor identity requested at $(date '+%H:%M:%S')${RESET}"
        return 0
    else
        echo -e "${RED}[!] Failed to request new identity${RESET}"
        return 1
    fi
}

while true; do
    echo -e "\n${YELLOW}${BOLD}┌──────────────────────────────────────────────────────┐${RESET}"
    echo -e "${YELLOW}${BOLD}│               R O T A T I O N   #$ROTATION                │${RESET}"
    echo -e "${YELLOW}${BOLD}└──────────────────────────────────────────────────────┘${RESET}"

    # Request new Tor identity
    request_new_identity

    # Get new IP
    sleep 3
    NEW_IP=$(curl --socks5 localhost:9050 -s ifconfig.me 2>/dev/null)
    
    if [ -n "$NEW_IP" ] && [ "$NEW_IP" != "" ]; then
        echo -e "${CYAN}[+] New IP: ${YELLOW}$NEW_IP${RESET}"
    else
        echo -e "${RED}[!] Failed to get new IP${RESET}"
    fi

    # Rotation counter
    echo -e "${MAGENTA}[+] Total rotations: $ROTATION${RESET}"

    # Wait 60 seconds
    echo -e "${BLUE}[*] Next rotation in 60 seconds...${RESET}"
    for i in {60..1}; do
        echo -ne "\r${YELLOW}[*] Time remaining: ${i}s${RESET}     "
        sleep 1
    done
    echo -ne "\r${GREEN}[+] Starting next rotation...${RESET}          \n"

    ROTATION=$((ROTATION + 1))
done

# Cleanup on exit
trap "echo -e '\n${RED}[!] Stopping Tor...${RESET}'; kill $TOR_PID 2>/dev/null; exit 0" INT TERM
