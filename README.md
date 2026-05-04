# Kali Linux Sniffing Detector 🛡️

An interactive Bash-based security auditing tool designed specifically for Kali Linux to detect network sniffing attempts, unauthorized services, and risky files.

## 🚀 Features
- **ARP Sniffing Detection**: Real-time monitoring of ARP traffic for MitM detection.
- **Process Management**: Automatically identifies unauthorized services (SSH, Apache, MySQL, etc.) and provides an option to terminate them by PID.
- **Service Mapping**: Shows the exact Port and PID associated with unwanted processes.
- **Risk File Scanner**: Searches the local directory for executable and compressed risk files.
- **Colorized UI**: Professional ASCII banner and status updates for better readability.

## 🛠️ Installation
1. Clone the repo:
   ```bash
   git clone [https://github.com/YOUR_USERNAME/Sniffing-Detector.git](https://github.com/YOUR_USERNAME/Sniffing-Detector.git)
   🛠️ How to Download & Run

Follow these steps to get the Kali Linux Sniffing Detector running on your system.
1. Prerequisites

Ensure your system is updated and has the necessary networking tools installed:
Bash

sudo apt update && sudo apt install git net-tools tcpdump -y

2. Download the Tool

You can download the tool by cloning the repository directly from GitHub:
Bash

git clone https://github.com/YOUR_USERNAME/Kali-Linux-Sniffing-Detector.git

Alternatively, if you downloaded the ZIP file from GitHub, extract it using:
Bash

unzip Kali-Linux-Sniffing-Detector-main.zip

3. Navigate to the Directory

Move into the folder where the script is located:
Bash

cd Kali-Linux-Sniffing-Detector

4. Set Execution Permissions

By default, Linux scripts are not executable. You must grant permission:
Bash

chmod +x security_scan.sh

5. Run the Script

This tool monitors network interfaces and system processes, so it requires root (sudo) privileges:
Bash

sudo ./security_scan.sh
