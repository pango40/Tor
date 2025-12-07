#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Obito - Infinite Tsukuyomi Anonymity Tool
English Version with IP Rotation
"""

import os
import sys
import time
import socket
import subprocess
import requests
from datetime import datetime
from colorama import init, Fore, Style

# Initialize colorama
init(autoreset=True)

# Color definitions
class Colors:
    RED = Fore.RED + Style.BRIGHT
    GREEN = Fore.GREEN + Style.BRIGHT
    BLUE = Fore.BLUE + Style.BRIGHT
    YELLOW = Fore.YELLOW + Style.BRIGHT
    CYAN = Fore.CYAN + Style.BRIGHT
    MAGENTA = Fore.MAGENTA + Style.BRIGHT
    RESET = Style.RESET_ALL

class ObitoAnonymityTool:
    def __init__(self):
        self.tor_process = None
        self.rotation_count = 0
        self.session = requests.Session()
        self.session.proxies = {
            'http': 'socks5h://127.0.0.1:9050',
            'https': 'socks5h://127.0.0.1:9050'
        }
    
    def clear_screen(self):
        os.system('cls' if os.name == 'nt' else 'clear')
    
    def print_banner(self):
        banner = f"""{Colors.CYAN}
╔══════════════════════════════════════════════════════╗
║                                                      ║
║                 O B I T O   T O O L                  ║
║           Infinite Tsukuyomi Anonymity               ║
║                                                      ║
║           ██████╗ ██████╗ ██╗████████╗ ██████╗       ║
║          ██╔═══██╗██╔══██╗██║╚══██╔══╝██╔═══██╗      ║
║          ██║   ██║██████╔╝██║   ██║   ██║   ██║      ║
║          ██║   ██║██╔══██╗██║   ██║   ██║   ██║      ║
║          ╚██████╔╝██████╔╝██║   ██║   ╚██████╔╝      ║
║           ╚═════╝ ╚═════╝ ╚═╝   ╚═╝    ╚═════╝       ║
║                                                      ║
║           Automated IP Rotation via Tor              ║
║               Secure Anonymity Tool                  ║
║                                                      ║
╚══════════════════════════════════════════════════════╝
{Colors.RESET}"""
        print(banner)
    
    def print_header(self, title, color=Colors.CYAN):
        border = "═" * 50
        print(f"\n{color}╔{border}╗")
        print(f"║{title.center(50)}║")
        print(f"╚{border}╝{Colors.RESET}")
    
    def get_system_info(self):
        self.print_header("SYSTEM INFORMATION", Colors.MAGENTA)
        
        info = [
            f"{Colors.YELLOW}├─ User:{Colors.RESET} {os.getlogin() if hasattr(os, 'getlogin') else os.getenv('USER', 'Unknown')}",
            f"{Colors.YELLOW}├─ Host:{Colors.RESET} {socket.gethostname()}",
            f"{Colors.YELLOW}├─ Time:{Colors.RESET} {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
            f"{Colors.YELLOW}├─ IP Address:{Colors.RESET} {self.get_public_ip()}"
        ]
        
        print(f"{Colors.CYAN}┌──────────────────────────────────────────────────────┐")
        for line in info:
            print(line)
        print(f"└──────────────────────────────────────────────────────┘{Colors.RESET}")
    
    def get_contact_info(self):
        self.print_header("CONTACT INFORMATION", Colors.YELLOW)
        
        contacts = f"""{Colors.BLUE}┌──────────────────────────────────────────────────────┐
{Colors.CYAN}├─ Telegram:{Colors.RESET}
{Colors.BLUE}│   {Colors.YELLOW}● {Colors.CYAN}https://t.me/Mr_WEBts{Colors.RESET}
{Colors.CYAN}├─ GitHub:{Colors.RESET}
{Colors.BLUE}│   {Colors.YELLOW}● {Colors.CYAN}https://github.com/pango40{Colors.RESET}
{Colors.BLUE}└──────────────────────────────────────────────────────┘{Colors.RESET}"""
        print(contacts)
    
    def get_public_ip(self):
        try:
            return requests.get('https://api.ipify.org', timeout=5).text
        except:
            return "Unable to retrieve"
    
    def check_requirements(self):
        print(f"\n{Colors.CYAN}[*] Checking requirements...{Colors.RESET}")
        
        # Check Python packages
        try:
            import requests
            import colorama
            print(f"{Colors.GREEN}[✓] All Python packages installed{Colors.RESET}")
        except ImportError as e:
            print(f"{Colors.RED}[!] Missing package: {e}{Colors.RESET}")
            print(f"{Colors.YELLOW}[*] Install with: pip install requests colorama{Colors.RESET}")
            return False
        
        # Check Tor
        if not self.is_tor_installed():
            print(f"{Colors.RED}[!] Tor is not installed{Colors.RESET}")
            return False
        
        print(f"{Colors.GREEN}[✓] Tor is installed{Colors.RESET}")
        return True
    
    def is_tor_installed(self):
        try:
            subprocess.run(['which', 'tor'], capture_output=True, check=True)
            return True
        except:
            return False
    
    def start_tor(self):
        print(f"\n{Colors.CYAN}[+] Starting Tor service...{Colors.RESET}")
        
        if self.is_tor_running():
            print(f"{Colors.YELLOW}[!] Tor is already running{Colors.RESET}")
            return True
        
        try:
            self.tor_process = subprocess.Popen(
                ['tor'],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True
            )
            
            print(f"{Colors.CYAN}[*] Initializing Tor...{Colors.RESET}")
            time.sleep(10)
            
            if self.is_tor_running():
                print(f"{Colors.GREEN}✅ Tor service started successfully!{Colors.RESET}")
                return True
            else:
                print(f"{Colors.RED}[!] Tor failed to start{Colors.RESET}")
                return False
                
        except Exception as e:
            print(f"{Colors.RED}[!] Error: {e}{Colors.RESET}")
            return False
    
    def is_tor_running(self):
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(2)
            result = sock.connect_ex(('127.0.0.1', 9050))
            sock.close()
            return result == 0
        except:
            return False
    
    def get_tor_ip(self):
        try:
            return self.session.get('https://api.ipify.org', timeout=10).text
        except:
            return "Unable to retrieve"
    
    def rotate_identity(self):
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(5)
            sock.connect(('127.0.0.1', 9051))
            
            sock.send(b'AUTHENTICATE ""\r\n')
            time.sleep(0.5)
            sock.send(b'SIGNAL NEWNYM\r\n')
            time.sleep(0.5)
            sock.send(b'QUIT\r\n')
            sock.close()
            
            print(f"{Colors.GREEN}[+] New identity requested at {datetime.now().strftime('%H:%M:%S')}{Colors.RESET}")
            return True
        except:
            print(f"{Colors.RED}[!] Failed to rotate identity{Colors.RESET}")
            return False
    
    def rotation_cycle(self):
        self.rotation_count += 1
        
        print(f"\n{Colors.YELLOW}┌──────────────────────────────────────────────────────┐")
        print(f"│               R O T A T I O N   #{self.rotation_count:03d}                │")
        print(f"└──────────────────────────────────────────────────────┘{Colors.RESET}")
        
        if self.rotate_identity():
            time.sleep(3)
            new_ip = self.get_tor_ip()
            print(f"{Colors.CYAN}[+] New IP: {Colors.YELLOW}{new_ip}{Colors.RESET}")
        
        print(f"{Colors.MAGENTA}[+] Total rotations: {self.rotation_count}{Colors.RESET}")
    
    def main_loop(self):
        self.print_header("IP ROTATION ACTIVE", Colors.RED)
        
        print(f"Rotating IP every minute...")
        
        initial_ip = self.get_tor_ip()
        print(f"{Colors.CYAN}[+] Initial Tor IP: {Colors.YELLOW}{initial_ip}{Colors.RESET}")
        
        while True:
            try:
                self.rotation_cycle()
                
                print(f"\n{Colors.BLUE}Next rotation in 60 seconds...{Colors.RESET}")
                
                for i in range(60, 0, -1):
                    print(f"\r{Colors.YELLOW}Time remaining: {i}s{Colors.RESET}     ", end='', flush=True)
                    time.sleep(1)
                
                print(f"\r{Colors.GREEN}Starting next rotation...{Colors.RESET}          \n")
                
            except KeyboardInterrupt:
                print(f"\n{Colors.RED}[!] Rotation stopped{Colors.RESET}")
                break
            except Exception as e:
                print(f"{Colors.RED}[!] Error: {e}{Colors.RESET}")
                time.sleep(5)
    
    def run(self):
        self.clear_screen()
        self.print_banner()
        self.get_system_info()
        self.get_contact_info()
        
        if not self.check_requirements():
            return
        
        print(f"\n{Colors.RED}Press ENTER to start or Ctrl+C to exit{Colors.RESET}")
        input()
        
        if not self.start_tor():
            return
        
        try:
            self.main_loop()
        except KeyboardInterrupt:
            print(f"\n{Colors.RED}[!] Program terminated{Colors.RESET}")
        finally:
            if self.tor_process:
                self.tor_process.terminate()

if __name__ == "__main__":
    tool = ObitoAnonymityTool()
    tool.run()