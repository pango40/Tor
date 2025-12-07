#!/bin/bash

# Auto-fix CRLF issue for GitHub downloads
if [ -n "$(cat "$0" 2>/dev/null | head -1 | grep -o '\r')" ] || [ "$(head -c 2 "$0" 2>/dev/null | od -c | grep -o '\\r')" ]; then
    echo "🔧 Fixing GitHub CRLF issue..."
    sed -i 's/\r$//' "$0" 2>/dev/null
    exec /bin/bash "$0" "$@"
    exit 0
fi

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
echo -e "${YELLOW}├─ Initial IP:${RESET} $(curl -s ifconfig.me 2>/dev/null || echo "Not connected")"
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
    echo -e "${RED}Tor is not installed. Installing...${RESET}"
    pkg update -y && pkg install tor -y
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to install Tor. Exiting.${RESET}"
        exit 1
    fi
    echo -e "${GREEN}Tor installed successfully.${RESET}"
fi

# Start Tor in the background
echo -e "${CYAN}${BOLD}[+] Starting Tor service...${RESET}"
tor &
TOR_PID=$!

# Wait for Tor to initialize
sleep 10

# Check if Tor is running
if ! ps -p $TOR_PID > /dev/null 2>&1; then
    echo -e "${RED}Failed to start Tor. Trying alternative method...${RESET}"
    tor --quiet &
    TOR_PID=$!
    sleep 5
fi

# Get initial IP through Tor
echo -e "${CYAN}[+] Getting initial IP...${RESET}"
INITIAL_IP=$(curl --socks5 localhost:9050 -s ifconfig.me 2>/dev/null || curl -s ifconfig.me 2>/dev/null)

if [ -n "$INITIAL_IP" ]; then
    echo -e "${GREEN}✅ Tor started successfully!${RESET}"
    echo -e "${CYAN}[+] Tor IP: ${YELLOW}$INITIAL_IP${RESET}"
else
    echo -e "${YELLOW}⚠️  Could not get IP. Tor might be still starting...${RESET}"
fi

echo -e "\n${RED}${BOLD}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${RED}${BOLD}║       I P   R O T A T I O N   A C T I V E             ║${RESET}"
echo -e "${RED}${BOLD}╚══════════════════════════════════════════════════════╝${RESET}"

echo "Rotating IP every 1 minute..."
ROTATION=1

# Main rotation loop
while true; do
    echo -e "\n${YELLOW}${BOLD}┌──────────────────────────────────────────────────────┐${RESET}"
    echo -e "${YELLOW}${BOLD}│               R O T A T I O N   #$ROTATION                │${RESET}"
    echo -e "${YELLOW}${BOLD}└──────────────────────────────────────────────────────┘${RESET}"
    
    # Request new Tor identity
    echo -e 'AUTHENTICATE ""\nSIGNAL NEWNYM\nQUIT' | nc localhost 9051 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[+] New Tor identity requested at $(date '+%H:%M:%S')${RESET}"
    else
        echo -e "${YELLOW}[!] Could not send NEWNYM signal. Tor might need restart.${RESET}"
        kill $TOR_PID 2>/dev/null
        sleep 2
        tor &
        TOR_PID=$!
        sleep 8
    fi
    
    # Get new IP
    sleep 3
    NEW_IP=$(curl --socks5 localhost:9050 -s ifconfig.me 2>/dev/null)
    
    if [ -n "$NEW_IP" ]; then
        echo -e "${CYAN}[+] New IP: ${YELLOW}$NEW_IP${RESET}"
    else
        echo -e "${YELLOW}[!] Could not get new IP${RESET}"
    fi
    
    # Rotation counter
    echo -e "${MAGENTA}[+] Total rotations: $ROTATION${RESET}"
    
    # Wait 60 seconds with countdown
    echo -e "${BLUE}Next rotation in 60 seconds...${RESET}"
    for i in {60..1}; do
        echo -ne "\r${YELLOW}Time remaining: ${i}s${RESET}     "
        sleep 1
    done
    echo -ne "\r${GREEN}Starting next rotation...${RESET}          \n"
    
    ROTATION=$((ROTATION + 1))
done

# Cleanup on exit
cleanup() {
    echo -e "\n${RED}${BOLD}Shutting down...${RESET}"
    kill $TOR_PID 2>/dev/null
    echo -e "${GREEN}Tor stopped. Goodbye!${RESET}"
    exit 0
}

trap cleanup INT TERM
