---
layout: post
title: "TryHackMe  - Passwords - A Cracking Christmas"
date: 2025-12-24
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Learn/Passwords - A Cracking Christmas"
identifier: "20251231T213118"
source_id: "e0fdafca-f740-47a3-823d-1f80764c06a8"
source_urls: "(https://tryhackme.com/room/attacks-on-ecrypted-files-aoc2025-asdfghj123)"
source_path: "20251231T213118--tryhackme-passwords-a-cracking-christmas__tryhackme.md"
---

{% raw %}


# TryHackMe | Passwords - A Cracking Christmas

## Task 1 | Introduction

The Story

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/5fc2847e1bbebc03aa89fbf2-1762352007911.svg)

With time between Easter and Christmas being destabilised, the once-quiet systems of _The Best Festival Company_ began showing traces of encrypted data buried deep within their servers. Sir Carrotbane, stumbled upon a series of locked PDF and ZIP files labelled _“North Pole Asset List.”_ Rumours spread that these could contain fragments of **Santa’s master gift registry** , critical information that could help Malhare control the festive balance between both worlds.

Sir Carrotbane sets out to crack the encryption, learning how weak passwords can expose even the most guarded secrets. Can the Elves adapt fast and prevent their secrets from being discovered?

Learning Objectives

- How password-based encryption protects files such as PDFs and ZIP archives.
- Why weak passwords make encrypted files vulnerable.
- How attackers use dictionary and brute-force attacks to recover passwords.
- A hands-on exercise: cracking the password of an encrypted file to reveal its contents.
- The importance of using strong, complex passwords to defend against these attacks.

A few simple points to remember:

- The **strength of protection** depends almost entirely on the password. Short or common passwords can be guessed; long, random passwords are far harder to break.
- Different file formats use different algorithms and key derivation methods. For example, PDF encryption and ZIP encryption differ in details (how the key is derived, salt use, number of hash iterations). That affects how easy or hard cracking is.
- Many consumer tools still support legacy or weak modes (particularly older ZIP encryption). That makes some encrypted archives much easier to attack than modern, well-implemented schemes.
- Encryption protects data confidentiality only. It does not prevent someone with access to the encrypted file from trying to guess the password offline.

To make it simple, encryption makes the contents unreadable unless the correct password is known. If the password is weak, an attacker can simply try likely passwords until one works.

Connecting to the Machine Before moving forward, review the questions in the connection card shown below:

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f9c7574e201fe31dad228fc/room-content/5f9c7574e201fe31dad228fc-1763031042705.png)

Start your target machine by clicking the **Start Machine** button below. The machine will need about 2 minutes to fully boot. In case you can not see it, click the **Show Split View** button at the top of the page.

Set up your virtual environmentTo successfully complete this room, you'll need to set up your virtual environment. This involves starting the Target Machine, ensuring you're equipped with the necessary tools and access to tackle the challenges ahead.

![Image 3](https://tryhackme.com/static/svg/target-machine.a3955286.svg)

Target machine

![Image 4](data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTciIGhlaWdodD0iMTYiIHZpZXdCb3g9IjAgMCAxNyAxNiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTguODI1MiAwQzQuNDA2NDUgMCAwLjgyNTE5NSAzLjU4MTI1IDAuODI1MTk1IDhDMC44MjUxOTUgMTIuNDE4NyA0LjQwNjQ1IDE2IDguODI1MiAxNkMxMy4yNDM5IDE2IDE2LjgyNTIgMTIuNDE4NyAxNi44MjUyIDhDMTYuODI1MiAzLjU4MTI1IDEzLjI0MzkgMCA4LjgyNTIgMFpNOC44MjUyIDRDOS4zNzczOCA0IDkuODI1MiA0LjQ0NzgxIDkuODI1MiA1QzkuODI1MiA1LjU1MjE5IDkuMzc3MzggNiA4LjgyNTIgNkM4LjI3MzAxIDYgNy44MjUyIDUuNTUzMTIgNy44MjUyIDVDNy44MjUyIDQuNDQ2ODggOC4yNzIwNyA0IDguODI1MiA0Wk0xMC4wNzUyIDEySDcuNTc1MkM3LjE2MjcgMTIgNi44MjUyIDExLjY2NTYgNi44MjUyIDExLjI1QzYuODI1MiAxMC44MzQ0IDcuMTYxMTMgMTAuNSA3LjU3NTIgMTAuNUg4LjA3NTJWOC41SDcuODI1MkM3LjQxMTEzIDguNSA3LjA3NTIgOC4xNjQwNiA3LjA3NTIgNy43NUM3LjA3NTIgNy4zMzU5NCA3LjQxMjcgNyA3LjgyNTIgN0g4LjgyNTJDOS4yMzkyNiA3IDkuNTc1MiA3LjMzNTk0IDkuNTc1MiA3Ljc1VjEwLjVIMTAuMDc1MkMxMC40ODkzIDEwLjUgMTAuODI1MiAxMC44MzU5IDEwLjgyNTIgMTEuMjVDMTAuODI1MiAxMS42NjQxIDEwLjQ5MDggMTIgMTAuMDc1MiAxMloiIGZpbGw9IiM4NzhGQTIiLz4KPC9zdmc+Cg==)

Status:OffStart Machine Alternatively, you can use the credentials below to connect to the target machine via SSH from your own THM VPN connected machine:

Credentials

Only needed if you are using your own THM VPN connected machine.

Username ubuntu Password AOC2025Ubuntu! IP address MACHINE_IP Connection via SSH ssh ubuntu@MACHINE_IP

### **Answer the questions below**

**Question:**

_Answer:_

     No answer needed

---

## Task 2 | Attacks Against Encrypted Files

How Attackers Recover Weak Passwords Attackers don't usually try to "break" the encryption itself because that would take far too long with modern cryptography. Instead, they focus on guessing the password that protects the file. The two most common ways of doing this are dictionary attacks and brute-force (or mask) attacks.

**Dictionary Attacks**

In a dictionary attack, the attacker uses a predefined list of potential passwords, known as a wordlist, and tests each one until the correct password is found. These wordlists often contain leaked passwords from previous breaches, common substitutions like **password123** , predictable combinations of names and dates, and other patterns that people frequently use. Because many users choose weak or common passwords, dictionary attacks are usually fast and highly effective.

**Mask Attacks**

![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/5fc2847e1bbebc03aa89fbf2-1763695819086.png)

Brute-force and mask attacks go one step further. A brute-force attack systematically tries every possible combination of characters until it finds the right one. While this guarantees success eventually, the time it takes grows exponentially with the length and complexity of the password.

Mask attacks aim to reduce that time by limiting guesses to a specific format. For example, trying all combinations of three lowercase letters followed by two digits.

By narrowing the search space, mask attacks strike a balance between speed and thoroughness, especially when the attacker has some idea of how the password might be structured.

Practical tips attackers use (and defenders should know about):

- Start with a wordlist (fast wins). Common lists: `rockyou.txt`, `common-passwords.txt`.
- If the wordlist fails, move to targeted wordlists (company names, project names, or data from the target).
- If that fails, try mask or incremental attacks on short passwords (e.g. `?l?l?l?d?d` = three lowercase letters + two digits, which is used as a password mask format by password cracking tools).
- Use GPU-accelerated cracking when possible; it dramatically speeds up attacks for some algorithms.
- Keep an eye on resource use: cracking is CPU/GPU intensive. That behaviour can be detected on a monitored endpoint.

Exercise You will find the files for this section in the `Desktop` directory of the machine. Switch to it by running `cd Desktop` in your terminal.

**1. Confirm the File Type**

Use the `file` command or open the file with a hex viewer. This helps pick the right tool.

File Command

```File Command
ubuntu@tryhackme:~/Desktop$ file flag.pdf      ubuntu@tryhackme:~/Desktop$ file flag.zip
```

If it's a PDF, proceed with PDF tools. If it's a ZIP, proceed with ZIP tools.

**2. Tools to Use (pick one based on file type)**

- PDF: `pdfcrack`, `john` (via `pdf2john`)
- ZIP: `fcrackzip`, `john` (via `zip2john`)
- General: `john` (very flexible) and `hashcat` (GPU acceleration, more advanced)

  **3. Try a Dictionary Attack First (fast, often successful)**

Example: PDF with `pdfcrack` and `rockyou.txt`:

PdfCrack Command

```PdfCrack Command
ubuntu@tryhackme:~/Desktop$ pdfcrack -f flag.pdf -w /usr/share/wordlists/rockyou.txt
PDF version 1.7
Security Handler: Standard
V: 2
R: 3
P: -1060
Length: 128
Encrypted Metadata: True
FileID: 3792b9a3671ef54bbfef57c6fe61ce5d
U: c46529c06b0ee2bab7338e9448d37c3200000000000000000000000000000000
O: 95d0ad7c11b1e7b3804b18a082dda96b4670584d0044ded849950243a8a367ff
Average Speed: 29538.5 w/s. Current Word: 's8t8a8r8'
Average Speed: 31068.0 w/s. Current Word: 'toby344'
Average Speed: 30443.7 w/s. Current Word: 'erikowa'
Average Speed: 29519.3 w/s. Current Word: '0848845800'
Average Speed: 29676.4 w/s. Current Word: 'u3904041'
Average Speed: 29339.8 w/s. Current Word: 'spider0187'
Average Speed: 30156.8 w/s. Current Word: 'roermond7'
Average Speed: 30364.8 w/s. Current Word: 'papaopass2'
found user-password: 'XXXXXXXXXX'
```

Example: using `john`

- Create a hash that John can understand: `zip2john flag.zip > ziphash.txt`

  Terminal

```Terminal
ubuntu@tryhackme:~/Desktop$ zip2john flag.zip > ziphash.txt
```

- John will report the recovered password if it finds one.

  Terminal

```Terminal
ubuntu@tryhackme:~/Desktop$ john --wordlist=/usr/share/wordlists/rockyou.txt ziphash.txt
Using default input encoding: UTF-8
Loaded 1 password hash (ZIP, WinZip [PBKDF2-SHA1 128/128 AVX 4x])
Cost 1 (HMAC size) is 29 for all loaded hashes
Will run 2 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
XXXXXXXXXXX      (flag.zip/flag.txt)
1g 0:00:02:12 DONE (2025-10-03 08:26) 0.007552g/s 20696p/s 20696c/s 20696C/s winternights..wine23
Use the "--show" option to display all of the cracked passwords reliably
Session completed.
```

Detection of Indicators and Telemetry Offline cracking does not hit login services, so lockouts and failed logon dashboards stay quiet. We can detect the work where it runs, on endpoints and jump boxes. The important signals to monitor include:

**Process creation:** Password cracking has a small set of well-known binaries and command patterns that we can look out for. A mix of process events, file activity, GPU signals, and network touches tied to tooling and wordlists. Our goal is to make the activity obvious without drowning in noise.

- Binaries and aliases: `john`, `hashcat`, `fcrackzip`, `pdfcrack`, `zip2john`, `pdf2john.pl`, `7z`, `qpdf`, `unzip`, `7za`, `perl` invoking `pdf2john.pl`.
- Command‑line traits: `--wordlist`, `-w`, `--rules`, `--mask`, `-a 3`, `-m` in Hashcat, references to `rockyou.txt`, `SecLists`, `zip2john`, `pdf2john`.
- Potfiles and state: `~/.john/john.pot`, `.hashcat/hashcat.potfile`, `john.rec`.

![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f9c7574e201fe31dad228fc/room-content/5f9c7574e201fe31dad228fc-1765273235527.jpg)

It's worth noting that on Windows systems, Sysmon Event ID 1 captures process creation with full command line properties, while on Linux, `auditd`, `execve`, or EDR sensors capture binaries and arguments.

**GPU and Resource Artefacts**

GPU cracking is loud. Sudden high utilisation on hosts can be picked up and would need to be investigated.

- `nvidia-smi` shows long‑running processes named `hashcat` or `john`.
- High, steady GPU utilisation and power draw while the fan curve spikes.
- Libraries loaded: `nvcuda.dll`, `OpenCL.dll`, `libcuda.so`, `amdocl64.dll`.

  **Network Hints, Light but Useful**

Offline cracking does not need the network once wordlists are present. Yet most operators fetch lists and tools first.

- Downloads of large text files named `rockyou.txt`, or Git clones of popular wordlist repos.
- Package installs, for example `apt install john hashcat`, detected by EDR package telemetry.
- Tool updates and driver fetches for GPU runtimes.

  **Unusual File Reads**

Repeated reads of files such as wordlists or encrypted files would need analysis.

**Detections**

Below are some examples of detection rules and hunting queries we can put to use across various environments.

_Sysmon_ :

```
(ProcessName="C:\Program Files\john\john.exe" OR
 ProcessName="C:\Tools\hashcat\hashcat.exe" OR
 CommandLine="*pdf2john.pl*" OR
 CommandLine="*zip2john*")
```

_Linux audit rules, temporary for an investigation:_

```
auditctl -w /usr/share/wordlists/rockyou.txt -p r -k wordlists_read
auditctl -a always,exit -F arch=b64 -S execve -F exe=/usr/bin/john -k crack_exec
auditctl -a always,exit -F arch=b64 -S execve -F exe=/usr/bin/hashcat -k crack_exec
```

_Sigma style rule, Windows process create for cracking tools:_

```
title: Password Cracking Tools Execution
id: 9f2f4d3e-4c16-4b0a-bb3a-7b1c6c001234
status: experimental
logsource:
  product: windows
  category: process_creation
detection:
  selection_name:
    Image|endswith:
      - '\john.exe'
      - '\hashcat.exe'
      - '\fcrackzip.exe'
      - '\pdfcrack.exe'
      - '\7z.exe'
      - '\qpdf.exe'
  selection_cmd:
    CommandLine|contains:
      - '--wordlist'
      - 'rockyou.txt'
      - 'zip2john'
      - 'pdf2john'
      - '--mask'
      - ' -a 3'
  condition: selection_name or selection_cmd
level: medium
```

**Response Playbook**

As security analysts in Wareville, it is important to have a playbook to follow when such incidents occur. The immediate actions to take are:

1. Isolate the host if malicious activity is detected. If it is a lab, tag and suppress.
2. Capture triage artefacts such as process list, process memory dump, `nvidia-smi` sample output, open files, and the encrypted file.
3. Preserve the working directory, wordlists, hash files, and shell history.
4. Review which files were decrypted. Search for follow‑on access, lateral movement or exfiltration.
5. Identify the origin and intent of the activity. Was this authorised? If not, escalate to the IR team.
6. Remediate the activity, rotate affected keys and passwords, and enforce MFA for accounts.
7. Close with education and correct placement of tools into approved sandboxes.

### **Answer the questions below**

**Question:**

_Answer:_

     THM{Cr4ck1ng_PDFs_1s_34$y}

**Question:**

_Answer:_

     THM{Cr4ck1n6_z1p$_1s_34$yyyy}

**Question:**

_Answer:_

     No answer needed

**Question:**

_Answer:_

     No answer needed

---

{% endraw %}
