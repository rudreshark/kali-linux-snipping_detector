#!/bin/bash

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' 
BOLD='\033[1m'

# --- Banner Function ---
show_banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "========================================================================"
    echo "  _  __   _   _      ___   _      ___  _  _  _   _  __  __"
    echo " | |/ /  /_\ | |    |_ _| | |    |_ _|| \| || | | | \ \/ /"
    echo " | ' <  / _ \| |__   | |  | |__   | | | .\` || |_| |  >  < "
    echo " |_|\_\/_/ \_\____| |___| |____| |___||_|\_| \___/  /_/\_\\"
    echo "            S N I F F I N G   D E T E C T O R "
    echo "========================================================================"
    echo -e "${PURPLE}                   Created by: Rudresha RK${NC}"
    echo -e "${CYAN}========================================================================${NC}"
}

# --- Detection Functions ---

arp_sniffing_detection() {
    echo -e "\n${BLUE}[*] Scanning for ARP Sniffing (5 second capture)...${NC}"
    arpscan=$(timeout 5s tcpdump -l -i any -n -c 5 arp 2>/dev/null)
    
    if [ -n "$arpscan" ]; then
        echo -e "${RED}${BOLD}[!] ALERT: ARP Packet Activity Detected!${NC}"
        echo -e "${YELLOW}Traffic Log:${NC}\n$arpscan"
    else
        echo -e "${GREEN}[+] Network appears stable. No suspicious sniffing traffic.${NC}"
    fi
}

unwanted_connections_detection() {
    echo -e "\n${BLUE}[*] Checking Active Connections & Running Services...${NC}"
    found_unwanted=false
    
    # Define the blacklist of process names
    blacklist=("sshd" "httpd" "mysql" "apache2" "nc" "netcat" "ncat")

    for target in "${blacklist[@]}"; do
        # Check if the process exists in the process tree
        if pgrep -x "$target" > /dev/null; then
            # Get PIDs (multiple PIDs might exist for one service)
            pids=$(pgrep -x "$target")
            
            for pid in $pids; do
                # Get the port associated with this PID (if any)
                port_info=$(netstat -tlnp 2>/dev/null | grep "$pid/" | awk '{print $4}' | cut -d: -f2)
                
                if [ -n "$port_info" ]; then
                    echo -e "${RED}${BOLD}[!] ALERT: Unwanted Process Detected!${NC}"
                    echo -e "${YELLOW}    NAME : $target${NC}"
                    echo -e "${YELLOW}    PID  : $pid${NC}"
                    echo -e "${YELLOW}    PORT : $port_info${NC}"
                else
                    echo -e "${RED}${BOLD}[!] ALERT: Unwanted Process Detected!${NC}"
                    echo -e "${YELLOW}    NAME : $target${NC}"
                    echo -e "${YELLOW}    PID  : $pid${NC}"
                fi

                found_unwanted=true
                
                # Ask to kill
                echo -ne "${CYAN}>> Do you want to KILL $target (PID: $pid)? (y/n): ${NC}"
                read -r kill_choice < /dev/tty
                if [[ "$kill_choice" =~ ^([yY][eE][sS]|[yY])$ ]]; then
                    kill -9 "$pid" && echo -e "${GREEN}[+] Process $target terminated.${NC}" || echo -e "${RED}[-] Failed to kill $target.${NC}"
                fi
                echo "----------------------------------------------------------"
            done
        fi
    done

    if [ "$found_unwanted" = false ]; then
        echo -e "${GREEN}[+] No blacklisted processes or active ports found.${NC}"
    fi
}

file_scanning() {
    echo -e "\n${BLUE}[*] Scanning current directory for Risk File Types...${NC}"
    unwanted_file_types=("exe" "dll" "zip" "rar" "7z" "tar" "gz" "bz2" "xz")
    found_files=false
    
    for ext in "${unwanted_file_types[@]}"; do
        files=$(find . -maxdepth 2 -iname "*.$ext" 2>/dev/null)
        if [ -n "$files" ]; then
            for f in $files; do
                echo -e "${YELLOW}[!] Risky File Found: ${NC}$f"
                found_files=true
            done
        fi
    done
    
    if [ "$found_files" = false ]; then
        echo -e "${GREEN}[+] No restricted file types found.${NC}"
    fi
}

# --- Main Logic ---

if [[ $EUID -ne 0 ]]; then
   show_banner
   echo -e "${RED}${BOLD}ERROR: This script must be run as root!${NC}"
   exit 1
fi

show_banner

while true; do
    echo -e "\n${BOLD}SELECT A SCANNING CATEGORY:${NC}"
    echo -e "${CYAN}1)${NC} ARP Sniffing Detection"
    echo -e "${CYAN}2)${NC} Unwanted Process Finder (Detect & Kill)"
    echo -e "${CYAN}3)${NC} Risk File Scanner"
    echo -e "${CYAN}4)${NC} FULL SECURITY AUDIT"
    echo -e "${RED}5) Exit${NC}"
    echo -ne "\n${YELLOW}Enter choice [1-5]: ${NC}"
    read -r choice

    case $choice in
        1) arp_sniffing_detection ;;
        2) unwanted_connections_detection ;;
        3) file_scanning ;;
        4) 
            arp_sniffing_detection
            unwanted_connections_detection
            file_scanning
            ;;
        5) 
            echo -e "${GREEN}Goodbye, Rudresha RK! Stay secure.${NC}"
            exit 0
            ;;
        *) 
            echo -e "${RED}Invalid selection.${NC}"
            ;;
    esac
    echo -e "\n${CYAN}----------------------------------------------------------${NC}"
done

