#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Obito Tor - Python Version
Fixed IP Rotation with Multiple IP Services
"""

import os
import sys
import time
import socket
import subprocess
import requests
import random
from datetime import datetime

# Colors for terminal
class Colors:
    RED = '\033[91m'
    GREEN = '\033[92m'
    BLUE = '\033[94m'
    YELLOW = '\033[93m'
    CYAN = '\033[96m'
    MAGENTA = '\033[95m'
    BOLD = '\033[1m'
    RESET = '\033[0m'
    WHITE = '\033[97m'

class ObitoTorPython:
    def __init__(self):
        self.tor_process = None
        self.rotation_count = 0
        self.is_running = True
        
        # Multiple IP checking services
        self.ip_services = [
            'https://api.ipify.org',
            'https://icanhazip.com',
            'https://ident.me',
            'https://checkip.amazonaws.com',
            'http://ipinfo.io/ip'
        ]
    
    def clear_screen(self):
        """Clear terminal screen"""
        os.system('cls' if os.name == 'nt' else 'clear')
    
    def print_banner(self):
        """Print ASCII banner"""
        banner = f"""{Colors.CYAN}{Colors.BOLD}
╔══════════════════════════════════════════════════════╗
║                                                      ║
║         ▒█▀▀▀ ▒█▀▀▀█ ▒█▀▀█ ▒█▀▀▀█ ▒█▀▀█ ▒█▀▀▀█       ║
║         ▒█▀▀▀ ▒█░░▒█ ▒█▄▄▀ ▒█░░▒█ ▒█▄▄█ ▒█░░▒█       ║
║         ▒█░░░ ▒█▄▄▄█ ▒█░▒█ ▒█▄▄▄█ ▒█░░░ ▒█▄▄▄█       ║
║                                                      ║
║         ██████╗ ██████╗ ██╗████████╗ ██████╗         ║
║        ██╔═══██╗██╔══██╗██║╚══██╔══╝██╔═══██╗        ║
║        ██║   ██║██████╔╝██║   ██║   ██║   ██║        ║
║        ██║   ██║██╔══██╗██║   ██║   ██║   ██║        ║
║        ╚██████╔╝██████╔╝██║   ██║   ╚██████╔╝        ║
║         ╚═════╝ ╚═════╝ ╚═╝   ╚═╝    ╚═════╝         ║
║                                                      ║
║              I N F I N I T E   T S U K U Y O M I     ║
║               A N O N Y M I T Y   T O O L            ║
║                                                      ║
╚══════════════════════════════════════════════════════╝
{Colors.RESET}
"""
        print(banner)
    
    def print_section(self, title, color=Colors.CYAN):
        """Print section header"""
        width = 50
        border = "═" * (width - 2)
        print(f"\n{color}╔{border}╗")
        print(f"║{title.center(width-2)}║")
        print(f"╚{border}╝{Colors.RESET}")
    
    def display_system_info(self):
        """Display system information"""
        self.print_section("S Y S T E M   I N F O", Colors.MAGENTA)
        
        try:
            username = os.getenv('USER') or 'termux'
        except:
            username = 'termux'
        
        try:
            hostname = socket.gethostname()
        except:
            hostname = 'android'
        
        # Get public IP (direct)
        public_ip = self.get_public_ip_direct()
        
        info_lines = [
            f"{Colors.YELLOW}├─ User:{Colors.WHITE} {username}",
            f"{Colors.YELLOW}├─ Host:{Colors.WHITE} {hostname}",
            f"{Colors.YELLOW}├─ Time:{Colors.WHITE} {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
            f"{Colors.YELLOW}├─ Public IP:{Colors.WHITE} {public_ip}",
            f"{Colors.YELLOW}├─ System:{Colors.WHITE} Termux"
        ]
        
        print(f"{Colors.CYAN}┌──────────────────────────────────────────────────────┐")
        for line in info_lines:
            print(line)
        print(f"└──────────────────────────────────────────────────────┘{Colors.RESET}")
    
    def display_contact_info(self):
        """Display contact information"""
        self.print_section("C O N T A C T   I N F O", Colors.YELLOW)
        
        contact_info = f"""{Colors.BLUE}┌──────────────────────────────────────────────────────┐
{Colors.CYAN}├─ Telegram:{Colors.RESET}
{Colors.WHITE}│   ● https://t.me/Mr_WEBts{Colors.RESET}
{Colors.CYAN}├─ GitHub:{Colors.RESET}
{Colors.WHITE}│   ● https://github.com/pango40{Colors.RESET}
{Colors.BLUE}└──────────────────────────────────────────────────────┘{Colors.RESET}"""
        print(contact_info)
    
    def check_and_install(self):
        """Check and install requirements"""
        self.print_section("CHECKING REQUIREMENTS", Colors.CYAN)
        
        print(f"{Colors.YELLOW}[*] Checking environment...{Colors.RESET}")
        
        # Check if we're in Termux
        if 'com.termux' not in os.environ.get('PREFIX', ''):
            print(f"{Colors.RED}[!] Run this in Termux only!{Colors.RESET}")
            return False
        
        # Install packages
        packages = ['python', 'tor', 'curl', 'nmap']
        for pkg in packages:
            print(f"{Colors.YELLOW}[*] Checking {pkg}...{Colors.RESET}", end='')
            try:
                subprocess.run(['pkg', 'list-installed', pkg], 
                              capture_output=True, check=True)
                print(f"{Colors.GREEN} ✓{Colors.RESET}")
            except:
                print(f"{Colors.RED} ✗{Colors.RESET}")
                print(f"{Colors.YELLOW}[*] Installing {pkg}...{Colors.RESET}")
                subprocess.run(['pkg', 'install', pkg, '-y'], check=False)
        
        # Install Python modules
        try:
            import requests
            print(f"{Colors.GREEN}[✓] requests module ready{Colors.RESET}")
        except:
            print(f"{Colors.YELLOW}[*] Installing requests...{Colors.RESET}")
            subprocess.run([sys.executable, '-m', 'pip', 'install', 'requests'], 
                          check=False)
        
        print(f"{Colors.GREEN}[✓] All requirements satisfied{Colors.RESET}")
        return True
    
    def get_public_ip_direct(self):
        """Get public IP directly (without Tor)"""
        services = ['https://api.ipify.org', 'https://icanhazip.com']
        
        for service in services:
            try:
                response = requests.get(service, timeout=5)
                if response.status_code == 200:
                    return response.text.strip()
            except:
                continue
        
        return "Not available"
    
    def start_tor_service(self):
        """Start Tor service"""
        print(f"\n{Colors.CYAN}[+] Starting Tor service...{Colors.RESET}")
        
        # Check if Tor is already running
        if self.is_tor_running():
            print(f"{Colors.YELLOW}[!] Tor is already running{Colors.RESET}")
            return True
        
        # Kill any existing Tor processes
        os.system('pkill -f tor 2>/dev/null')
        
        # Start Tor
        try:
            self.tor_process = subprocess.Popen(
                ['tor'],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL
            )
            
            # Wait for Tor
            print(f"{Colors.CYAN}[*] Initializing Tor (15 seconds)...{Colors.RESET}")
            
            for i in range(1, 16):
                if self.is_tor_running():
                    print(f"\r{Colors.GREEN}[✓] Tor started!{Colors.RESET}")
                    return True
                print(f"\r{Colors.YELLOW}[*] {i}/15 seconds{Colors.RESET}", end='')
                time.sleep(1)
            
            print(f"\r{Colors.RED}[!] Tor failed to start{Colors.RESET}")
            return False
            
        except Exception as e:
            print(f"{Colors.RED}[!] Error: {e}{Colors.RESET}")
            return False
    
    def is_tor_running(self):
        """Check if Tor is running"""
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(1)
            result = sock.connect_ex(('127.0.0.1', 9050))
            sock.close()
            return result == 0
        except:
            return False
    
    def get_ip_through_tor(self):
        """Get IP through Tor with multiple fallback services"""
        # Try curl method first (most reliable)
        try:
            result = subprocess.run(
                ['curl', '--socks5-hostname', '127.0.0.1:9050', '-s', '--max-time', '10',
                 'https://api.ipify.org'],
                capture_output=True,
                text=True
            )
            
            if result.returncode == 0 and result.stdout.strip():
                ip = result.stdout.strip()
                if len(ip.split('.')) == 4 and not '<' in ip:
                    return ip
        except:
            pass
        
        # Try other services
        services = [
            'https://api.ipify.org',
            'https://icanhazip.com',
            'https://checkip.amazonaws.com'
        ]
        
        for service in services:
            try:
                proxies = {
                    'http': 'socks5h://127.0.0.1:9050',
                    'https': 'socks5h://127.0.0.1:9050'
                }
                
                response = requests.get(service, proxies=proxies, timeout=10)
                if response.status_code == 200:
                    ip = response.text.strip()
                    if len(ip.split('.')) == 4 and not '<' in ip:
                        return ip
            except:
                continue
        
        return "Waiting..."
    
    def rotate_tor_identity(self):
        """Rotate Tor identity/circuit"""
        try:
            # Method 1: Using netcat
            result = subprocess.run(
                ['echo', '-e', 'AUTHENTICATE ""\nSIGNAL NEWNYM\nQUIT'],
                capture_output=True,
                text=True
            )
            
            subprocess.run(
                ['nc', 'localhost', '9051'],
                input=result.stdout,
                capture_output=True,
                timeout=5
            )
            return True
            
        except:
            try:
                # Method 2: Using Python socket
                sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                sock.settimeout(5)
                sock.connect(('127.0.0.1', 9051))
                
                sock.send(b'AUTHENTICATE ""\r\n')
                time.sleep(0.5)
                sock.send(b'SIGNAL NEWNYM\r\n')
                time.sleep(0.5)
                sock.send(b'QUIT\r\n')
                sock.close()
                return True
                
            except:
                # Method 3: Kill and restart Tor
                if self.tor_process:
                    self.tor_process.terminate()
                    time.sleep(2)
                    return self.start_tor_service()
                return False
    
    def show_countdown(self, seconds):
        """Show countdown timer"""
        print(f"{Colors.BLUE}[*] Next rotation in {seconds} seconds...{Colors.RESET}")
        
        for i in range(seconds, 0, -1):
            mins = i // 60
            secs = i % 60
            print(f"\r{Colors.YELLOW}[*] Time: {mins:02d}:{secs:02d}{Colors.RESET}", end='')
            time.sleep(1)
        
        print(f"\r{Colors.GREEN}[✓] Starting rotation...{Colors.RESET}")
    
    def perform_rotation(self):
        """Perform one rotation cycle"""
        self.rotation_count += 1
        
        # Display rotation header
        print(f"\n{Colors.YELLOW}┌──────────────────────────────────────────────────────┐")
        print(f"│               R O T A T I O N   #{self.rotation_count:03d}                │")
        print(f"└──────────────────────────────────────────────────────┘{Colors.RESET}")
        
        # Rotate identity
        print(f"{Colors.CYAN}[*] Rotating Tor identity...{Colors.RESET}")
        
        if self.rotate_tor_identity():
            print(f"{Colors.GREEN}[+] Identity rotated at {datetime.now().strftime('%H:%M:%S')}{Colors.RESET}")
            
            # Wait for new circuit
            time.sleep(5)
            
            # Get new IP
            new_ip = self.get_ip_through_tor()
            
            # Validate IP
            if new_ip != "Waiting..." and '.' in new_ip and not '<' in new_ip:
                print(f"{Colors.CYAN}[+] New IP: {Colors.YELLOW}{new_ip}{Colors.RESET}")
            else:
                print(f"{Colors.YELLOW}[!] Getting new IP...{Colors.RESET}")
                time.sleep(5)
                new_ip = self.get_ip_through_tor()
                if new_ip != "Waiting..." and '.' in new_ip:
                    print(f"{Colors.CYAN}[+] New IP: {Colors.YELLOW}{new_ip}{Colors.RESET}")
                else:
                    print(f"{Colors.RED}[!] Failed to get new IP{Colors.RESET}")
        
        # Display stats
        print(f"{Colors.MAGENTA}[+] Total rotations: {self.rotation_count}{Colors.RESET}")
        print(f"{Colors.BLUE}[+] Tor port: 9050 | Control: 9051{Colors.RESET}")
    
    def main_rotation_loop(self):
        """Main rotation loop"""
        self.print_section("I P   R O T A T I O N   A C T I V E", Colors.RED)
        
        print(f"{Colors.WHITE}Rotating IP every minute...{Colors.RESET}")
        
        # Get initial Tor IP
        print(f"\n{Colors.CYAN}[*] Getting initial Tor IP...{Colors.RESET}")
        initial_ip = self.get_ip_through_tor()
        
        if initial_ip != "Waiting..." and '.' in initial_ip:
            print(f"{Colors.GREEN}✅ Tor IP: {Colors.YELLOW}{initial_ip}{Colors.RESET}")
        else:
            print(f"{Colors.YELLOW}[!] Waiting for Tor connection...{Colors.RESET}")
            time.sleep(5)
            initial_ip = self.get_ip_through_tor()
            print(f"{Colors.GREEN}✅ Tor connected! IP: {Colors.YELLOW}{initial_ip}{Colors.RESET}")
        
        print(f"{Colors.RED}Press Ctrl+C to stop{Colors.RESET}\n")
        
        # Main loop
        try:
            while self.is_running:
                self.perform_rotation()
                self.show_countdown(60)
                
        except KeyboardInterrupt:
            print(f"\n{Colors.RED}[!] Rotation stopped{Colors.RESET}")
    
    def cleanup(self):
        """Cleanup"""
        print(f"\n{Colors.RED}[!] Cleaning up...{Colors.RESET}")
        
        if self.tor_process:
            self.tor_process.terminate()
            time.sleep(1)
        
        print(f"{Colors.GREEN}[✓] Cleanup complete{Colors.RESET}")
    
    def run(self):
        """Main function"""
        self.clear_screen()
        self.print_banner()
        self.display_system_info()
        self.display_contact_info()
        
        # Check requirements
        if not self.check_and_install():
            return
        
        # Wait for user
        print(f"\n{Colors.RED}Press ENTER to start or Ctrl+C to exit{Colors.RESET}")
        input()
        
        # Start Tor
        if not self.start_tor_service():
            print(f"{Colors.RED}[!] Cannot start Tor{Colors.RESET}")
            return
        
        # Run rotation
        try:
            self.main_rotation_loop()
        except Exception as e:
            print(f"{Colors.RED}[!] Error: {e}{Colors.RESET}")
        finally:
            self.cleanup()

# Simplified version for Termux
def simple_version():
    """Simple working version"""
    print(f"\033[96m\033[1m")
    print("╔══════════════════════════════════════╗")
    print("║         Obito Tor - Termux           ║")
    print("║      Working IP Rotation             ║")
    print("╚══════════════════════════════════════╝")
    print("\033[0m")
    
    # Check if in Termux
    if 'com.termux' not in os.environ.get('PREFIX', ''):
        print("Run in Termux only!")
        return
    
    # Install if needed
    print("[*] Checking requirements...")
    os.system('pkg install tor curl -y 2>/dev/null')
    os.system('pip install requests 2>/dev/null')
    
    # Start Tor
    print("[+] Starting Tor...")
    os.system('pkill tor 2>/dev/null')
    os.system('tor > /dev/null 2>&1 &')
    time.sleep(15)
    
    # Check Tor
    sock = socket.socket()
    sock.settimeout(2)
    result = sock.connect_ex(('127.0.0.1', 9050))
    sock.close()
    
    if result != 0:
        print("[!] Tor failed to start")
        return
    
    print("[✓] Tor is running")
    
    # Main loop
    count = 0
    try:
        while True:
            count += 1
            print(f"\n┌─────────────────────────────┐")
            print(f"│ Rotation #{count:03d}                 │")
            print(f"└─────────────────────────────┘")
            
            # Rotate
            os.system("echo -e 'AUTHENTICATE \"\"\nSIGNAL NEWNYM\nQUIT' | nc 127.0.0.1 9051 2>/dev/null")
            print(f"[+] New identity requested")
            
            # Wait
            time.sleep(5)
            
            # Get IP using curl (reliable)
            ip = os.popen('curl --socks5 127.0.0.1:9050 -s https://api.ipify.org 2>/dev/null').read().strip()
            if ip and '.' in ip and not '<' in ip:
                print(f"[+] IP: {ip}")
            else:
                print(f"[!] Getting IP...")
            
            print(f"[+] Total: {count}")
            
            # Countdown
            for i in range(60, 0, -1):
                print(f"\r[*] Next in: {i}s", end='')
                time.sleep(1)
            print()
            
    except KeyboardInterrupt:
        print("\n[!] Stopped")
        os.system('pkill tor 2>/dev/null')

# Run it
if __name__ == "__main__":
    try:
        # Ask which version
        print("Choose version:")
        print("1. Full version (with interface)")
        print("2. Simple version (just rotation)")
        choice = input("Select (1/2): ").strip()
        
        if choice == "1":
            tool = ObitoTorPython()
            tool.run()
        else:
            simple_version()
            
    except KeyboardInterrupt:
        print("\n[!] Exit")
    except Exception as e:
        print(f"[!] Error: {e}")
