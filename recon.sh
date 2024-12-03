#!/bin/bash

#!/bin/bash
echo "---------------------------------"
echo " Recon Program Designed By Cuong "
echo "---------------------------------"
echo
echo
# ANSI escape codes for green text
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Prompt user for input
echo -e "Enter the target URL (e.g., http://target:80)$"
read -p "URL: " URL

echo -e "Enter the target IP address (e.g., 10.1.1.1)"
read -p "IP Address: " IP

echo -e "Enter the session token (e.g., SESSION=token)"
read -p "Token: " TOKEN

echo -e "Enter endpoint (e.g., /index.php?id=)"
read -p "Endpoint: " ENDPOINT
echo
echo
# Combine URL and endpoint with FUZZ
COMBINED_URL="$URL$ENDPOINT"  # Full URL (URL + endpoint)
FINAL_URL="${COMBINED_URL}FUZZ"  # Adding FUZZ at the end

# Echo the final result
echo -e "${GREEN}[i] Final URL with FUZZ${NC}"
echo "$FINAL_URL"

# Step 1: nmap scan
echo -e "${GREEN}[i] nmap scan${NC}"
echo "nmap -p- -sV -sS -Pn -A $IP"

# Step 2: WFUZZ - Directory Discovery
echo -e "${GREEN}[i] WFUZZ - Directory Discovery${NC}"
echo "wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt --hc 404,301 \"$URL/FUZZ/\""

# Step 3: WFUZZ - Authenticated Discovery
echo -e "${GREEN}[i] WFUZZ - Authenticated Discovery${NC}"
echo "wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt --hc 404 -b \"PARAM=value\" \"$URL/FUZZ/\""

# Step 4: WFUZZ - File Discovery
echo -e "${GREEN}[i] WFUZZ - File Discovery${NC}"
echo "wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/raft-large-files.txt --hc 301,404 \"$URL/FUZZ\""

# Step 5: WFUZZ - Authenticated File Discovery
echo -e "${GREEN}[i] WFUZZ - Authenticated Discovery${NC}"
echo "wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/raft-large-files.txt --hc 301,404,403 -b \"PARAM=value\" \"$URL/FUZZ\""

# Step 6: WFUZZ - Get Parameter Values
echo -e "${GREEN}[i] WFUZZ - Get Parameter Values${NC}"
echo "wfuzz -c -z file,/usr/share/seclists/Usernames/cirt-default-usernames.txt --hc 404,301 \"$URL/index.php?parameter=FUZZ\""

# Step 7: WFUZZ - HTML Escape Fuzzing
echo -e "${GREEN}[i] WFUZZ - HTML Escape Fuzzing${NC}"
echo "wfuzz -c -z file,/usr/share/wordlists/Fuzzing/yeah.txt \"$URL/FUZZ\""


echo -e "${GREEN}[i] XSS Discovery${NC}"
echo "wfuzz -c -z file,/usr/share/seclists/Fuzzing/XSS/XSS-Jhaddix.txt --hh 0 "$FINAL_URL""

# Step 8: Gobuster - Endpoint Discovery
echo -e "${GREEN}[i] Gobuster - Endpoint Discovery${NC}"
echo "gobuster dns -d $URL -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt"



echo -e "${GREEN}[i] SQL - Fuzzing GET Parameter${NC}"
echo "wfuzz -c -z file,/usr/share/wordlists/wfuzz/Injections/SQL.txt -u "$FINAL_URL""


echo -e "${GREEN}[i] SQL - Fuzzing POST Parameter${NC}"
echo "wfuzz -c -z file,/usr/share/wordlists/wfuzz/Injections/SQL.txt -d "id=FUZZ" -u "$URL/index.php""


echo -e "${GREEN}[i] SQLMAP - GET Parameter${NC}"
echo "sudo sqlmap -u "$URL/$ENDPOINT""

echo -e "${GREEN}[i] SQLMAP - POST Parameter${NC}"
echo "Note: Copy POST request from Burp Suite into post.txt file"
echo "sqlmap -r post.txt -p parameter"

echo -e "${GREEN}[i] WFUZZ - Directory Traversal (LFI)${NC}"
echo "wfuzz -c -z file,/usr/share/seclists/Fuzzing/LFI/LFI-Jhaddix.txt --hh 0 "$FINAL_URL""

echo -e "${GREEN}[i] WFUZZ - LFI App Specific Files${NC}"
echo "Create two wordlists (paths.txt):../../../etc"
echo "Contain custom files related to web technology that is used (Example: Look at /error endpoint; application.properties application.yml)"
echo "wfuzz -w paths.txt -w files.txt --hh 0 "$URL/index.php?id=FUZZFUZ2Z""


echo -e "${GREEN}[i] WFUZZ - Static File IDOR${NC}"
echo "wfuzz -c -z range,1-100 --hc 404 "$FINAL_URL.txt""
echo -e "${GREEN}[i] WFUZZ - ID Based IDOR${NC}"
echo "wfuzz -c -z range,1-100 --hc 404 "$FINAL_URL""

echo -e "${GREEN}[i] WFUZZ - User Discovery Brute Forcing${NC}"
echo "wfuzz -c -z file,/usr/share/SecLists/Usernames/top-username-shortlist.txt --hc 404,403 $FINAL_URL/FUZZ"

echo -e "${GREEN}[i] WFUZZ - Password Discovery Brute Forcing${NC}"
echo "wfuzz -c -z file,/usr/share/seclists/Passwords/xato-net-10-million-passwords-100000.txt --hc 404,403 -d 'username=admin&password=FUZZ' '$URL/login.php'"

