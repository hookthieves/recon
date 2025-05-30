
# recon.sh

`recon.sh` is a lightweight Bash script designed to streamline your web application reconnaissance process. Unlike automated scanners that execute tests and generate large outputs, this tool provides a curated list of useful recon and fuzzing commands tailored for manual and precise execution.

This script was created with the **Offensive Security Web Assessor (OSWA)** methodology in mind. It’s perfect for penetration testers and security professionals who prefer hands-on, controlled recon work.

>  Note: This tool does **not** perform scans itself. It outputs commands for you to run manually.

---

## Features

- Prompts for basic inputs: URL, IP address, session token, and endpoint  
- Outputs a full set of recon commands including:
  - `nmap` port scanning
  - `gobuster` directory & file discovery
  - `wfuzz` fuzzing for parameters, endpoints, and vulnerabilities
  - `sqlmap` for SQL injection testing
- Designed for visibility and flexibility in manual testing
- Compatible with popular wordlists from SecLists and other sources

---

## Usage

```bash
chmod +x recon.sh
./recon.sh
````

You will be prompted to enter:

* Target URL (e.g., `http://target:80`)
* IP Address (e.g., `10.1.1.1`)
* Session Token (e.g., `SESSION=token`)
* Vulnerable Endpoint (e.g., `/index.php?id=`)

The script then outputs a comprehensive list of recon and fuzzing commands using your input.

---

## Example Output

```bash
[i] Final URL with FUZZ
http://target:80/index.php?id=FUZZ

[i] Nmap scan
sudo nmap -p- -sV -sS -Pn -A 10.1.1.1

[i] Gobuster - Directory Discovery
gobuster dir -u http://target:80 -w /usr/share/wordlists/dirb/big.txt

[i] SQLMAP - GET Parameter
sudo sqlmap -u "http://target:80/index.php?id="

...
```

---

## Why Use This?

While automated recon tools are fast, they can sometimes skip over small details. `recon.sh` keeps the operator fully engaged and encourages a manual, methodical approach—ideal for learning, demonstrating, or performing recon work where context matters.

---

## Requirements

* Bash shell
* Common tools installed:

  * `nmap`
  * `gobuster`
  * `wfuzz`
  * `sqlmap`
* Wordlists from [SecLists](https://github.com/danielmiessler/SecLists) or similar

---

## Note

All payloads and wordlists used by this script are publicly available. This script acts as a wrapper or cheat-sheet style assistant for experienced testers.

---

## Credits

Designed by **Cuong Nguyen**
Inspired by methodologies in the **OSWA** course by Offensive Security.

---

## Screenshot

![image](https://github.com/user-attachments/assets/c3f47084-d7ad-45de-b6d1-5b06fd0fbd03)

---

## Legal Disclaimer

This tool is intended for educational and authorized security testing purposes only. Do **not** use against systems you do not own or have explicit permission to test.
