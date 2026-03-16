---
layout: post
title: "tryhackme-supplemental-memory"
date: 2025-09-24
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Advanced Endpoint Investigations/Memory Analysis"
source_id: "4fd9138b-35a4-4eed-abb4-38c3c7928515"
source_urls: "(https://tryhackme.com/room/supplementalmemory)"
source_path: "Advanced Endpoint Investigations/Memory Analysis/20250924T162658--tryhackme-supplemental-memory__tryhackme.md"
---

{% raw %}


# TryHackMe  - Supplemental Memory

## Task 1 | Introduction

As a DFIR team member in this room, you are tasked with conducting a memory analysis of a Windows workstation image suspected to have been compromised by a threat actor.

 This room is designed for DFIR team members, Threat Hunters, and SOC L2/L3 analysts who want to improve and reinforce their skills in memory analysis during a potential incident in order to understand better the value that memory dump investigation can provide in such scenarios.

 Learning Objectives 
- Uncover the TryHatMe breach with just a memory dump.
- Identify suspicious processes and network connections.
- Explore traces of execution and discovery actions.
- Detect signs of potential lateral movement and credential dumping.

 Room Prerequisites It is suggested to clear the following rooms first before proceeding:

 
- [Windows Memory & Processes](https://tryhackme.com/room/windowsmemoryandprocs)
- [Windows Memory & User Activity](https://tryhackme.com/room/windowsmemoryanduseractivity)
- [Windows Memory & Network](https://tryhackme.com/room/windowsmemoryandnetwork)

### **Answer the questions below**

**Question:** Let's start!

*Answer:* 

     No answer needed

---

## Task 2 | TryHatMe Attack Scenario

Set up your virtual environmentTo successfully complete this room, you'll need to set up your virtual environment. This involves starting the Target Machine, ensuring you're equipped with the necessary tools and access to tackle the challenges ahead.

![Image 1](https://tryhackme.com/static/media/target-machine.f0eafcef90514da27a537e33578f7c86.svg)

Target machine

![Image 2](https://tryhackme.com/static/media/info.d83e09d73991b8e93198f00b52c8409b.svg)

Status:OffStart MachineWe’ve set up a hands-on scenario for you, where you’ll step into the role of a DFIR team member.

 Scenario  During the [initial stages of the investigation](https://tryhackme.com/room/windowsmemoryandprocs), it was confirmed that the TryHatMe CEO's host WIN-001 was compromised. The attacker successfully obtained credentials belonging to Cain Omoore, a Domain IT Administrators group member who remotely helped the CEO with the endpoint configuration and cached his credentials on the host. 

Given the privileges associated with Cain's account, the internal security team suspects that the attacker laterally moved to other systems within the environment or even to Cain's host - WIN-015. 

Since Cain stores access keys to the TryHatMe factory control system on his WIN-015, your first priority is to investigate his host for any lateral movement or data exfiltration traces. For this, you have been provided with a memory dump of WIN-015. Good luck!  Company Information TryHatMe ****Network Map****

 **Note:**  The network map displays only a limited portion of the network — not all assets in the organisation are represented.

 ![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/66c44fd9733427ea1181ad58/room-content/66c44fd9733427ea1181ad58-1747929180104.png)

 Machine Access  The machine will take approximately 2 minutes to boot up and will start in split view. In case the VM is not visible, you can click the **Show Split View**  button at the top of the page. If you prefer using SSH, you can use the following credentials:

  

![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/be629720b11a294819516c1d4e738c92.png)

    **Username**  analyst   **Password**  forensic   **IP**  MACHINE_IP      The memory dump details are as follows:

 
- File Name: `WIN-015-20250522-111717.dmp`
- File MD5 Hash: `15fd7b30b20b53e7374aa8894413c686`
- File Location: `/home/analyst/memory/WIN-015`

 To execute Volatility 3 for analysis, use the `vol` command, example: `vol -f WIN-015-20250522-111717.dmp windows.psscan` .

 **Note:**  The first time you run a Volatility plugin, it may take a while to complete due to initial setup and caching. This is expected behaviour. Subsequent runs will be much faster and more responsive. Thank you for your patience!

 Additionally, you can find some pre-cooked results from Volatility plugins in the following directory for your convenience:
`/home/analyst/memory/WIN-015/precooked`

 Good luck, and stay sharp - every minute counts!

### **Answer the questions below**

**Question:** Are you ready to begin?

*Answer:* 

     No answer needed

---

## Task 3 | Lateral Movement and  Discovery

Let’s try to either prove or disprove the team’s suspicions regarding traces of the threat actor’s movement to the WIN-015 host.

 Below are a few tips on how different lateral movement techniques can be identified using memory analysis.

 Detecting Lateral Movement via PsExec Execution   Volatility Terminal 
```Volatility Terminal 
analyst@tryhackme$ vol -f ransomhub.dmp windows.pstree
PID     PPID    ImageFileName
4       0       System
* 272   4       smss.exe
* 384     376     csrss.exe
* 460     376       wininit.exe
* 600     460         services.exe
** 3772   600           psexesvc.exe
*** 3916  3772            512370d.exe
```

     Detecting Lateral Movement via WMI Execution   Volatility Terminal 
```Volatility Terminal 
analyst@tryhackme$ vol -f conti.dmp windows.pstree
PID     PPID    ImageFileName
4       0       System
* 272   4       smss.exe
* 384     376     csrss.exe
* 460     376       wininit.exe
* 600     460         services.exe
** 1244   600           svchost.exe
*** 2416  1244            wmiprvse.exe
**** 5156 2416             cobaltrs.exe
```

     Detecting Lateral Movement via PowerShell Remote   Volatility Terminal 
```Volatility Terminal 
analyst@tryhackme$ vol -f FIN12.dmp windows.pstree
PID     PPID    ImageFileName
4       0       System
* 272   4       smss.exe
* 384     376     csrss.exe
* 460     376       wininit.exe
* 600     460         services.exe
** 1280   600           svchost.exe
*** 2532  1280            wsmprovhost.exe
**** 4896 2532              cmd.exe
***** 5012 4896               conhost.exe
***** 5144 4896               trickbot.exe
```

### **Answer the questions below**

**Question:** The IR team suspects that the threat actor may have performed lateral movement to this host. Which executed process provides evidence of this activity?

*Answer:* 

     wmiprvse.exe

**Question:** What is the MITRE technique ID associated with the lateral movement method used by the threat actor?

*Answer:* 

     T1021.006

**Question:** Which other process was executed as part of the lateral movement activity to this host?

*Answer:* 

     TeamsView.exe

**Question:** What is the Security Identifier (SID) of the user account under which the process was executed on this host?

*Answer:* 

     S-1-5-21-3147497877-3647478928-1701467185-1008

**Question:** What is the name of the domain-related security group the user account was a member of?

*Answer:* 

     Domain Users

**Question:** Which processes related to discovery activity were executed by the threat actor on this host? Format: In alphabetical order

*Answer:* 

     ipconfig.exe, systeminfo.exe, whoami.exe

**Question:** What is the Command and Control IP address that the threat actor connected to from this host as a result of the previously executed actions? Format: IP Address:Port

*Answer:* 

     34.244.169.133:1995

---

## Task 4 | Privilege Escalation and Credential Dumping

You did a great job detecting some truly valuable indicators of the adversary in the previous task. Now, let’s dive even deeper into this memory dump and see what other anomalies we can uncover together.

 To detect potential signs of privilege escalation through memory analysis, we recommend the following approaches:

 
1. **Inspect processes associated with services:** Adversaries often abuse service misconfigurations to manipulate their behaviour and gain elevated privileges. Careful memory inspection can occasionally detect this kind of activity.
2. **Analyse the privilege level of users running processes:** Investigate which users are associated with potentially malicious or unusual processes - this can help uncover anomalies or signs of privilege misuse.

 Below are examples of how to identify potential signs of privilege escalation through memory analysis.

   Detection of Malicious Process Execution: 543mal.exe 
```Detection of Malicious Process Execution: 543mal.exe 
analyst@tryhackme$ vol -f apt41.dmp windows.pstree
PID     PPID    ImageFileName
4       0       System
* 272     4       smss.exe
* 384     376     csrss.exe
**  460     376     wininit.exe
*** 600     460       services.exe
****  1420    600       svchost.exe
***** 1588    1420        taskhostw.exe
***** 1612    1420        543mal.exe
```

     Detecting Privilege Levels of Malicious Execution 
```Detecting Privilege Levels of Malicious Execution 
analyst@tryhackme$ vol -f apt41.dmp windows.getsids --pid 1612                         
PID	Process	SID	Name
1612	543mal.exe	S-1-5-21-3147497877-...-1010 michael.brown
1612	543mal.exe	S-1-5-21-3147497877-...-513	Domain Users
...
```

   As seen above, the malicious process was executed under the user account michael.brown on the system. Let's take a closer look at this example.

   Detecting Privilege Escalation via Service 
```Detecting Privilege Escalation via Service 
analyst@tryhackme$ vol -f apt41.dmp windows.pstree                     
PID     PPID    ImageFileName
4       0       System
* 272     4       smss.exe
* 384     376     csrss.exe
**  460     376     wininit.exe
*** 600     460       services.exe
****  1312    600       svchost.exe
****  1531    600       up.exe
```

     Detecting Privilege Levels of Malicious Execution 
```Detecting Privilege Levels of Malicious Execution 
analyst@tryhackme$ vol -f apt41.dmp windows.getsids --pid 1531
PID     Process     SID                                       Name
1531    up.exe      S-1-5-21-3147497877-...-1107 svc_backup
1531    up.exe      S-1-5-21-3147497877-...-556  Service Accounts
```

   As demonstrated in this example, the attacker initially operated under the user account michael.brown, executing 543mal.exe as a reverse shell, and later escalated privileges to svc_backup. The privilege escalation was achieved through service manipulation, exploiting misconfigured services present on the system and as a result, up.exe was executed. We hope you found this example helpful and wish you successful investigations ahead!

### **Answer the questions below**

**Question:** Conduct a deeper investigation and identify another suspicious process on the host. Provide a full path to the process in your answer.

*Answer:* 

     C:\Windows\Temp\pan.exe

**Question:** Which account was used to execute this malicious process?

*Answer:* 

     Local System

**Question:** What was the malicious command line executed by the process?

*Answer:* 

     privilege::debug sekurlsa::logonpasswords

**Question:** Given the command line from the previous question, which well-known hacker tool is most likely the malicious process?

*Answer:* 

     Mimikatz

**Question:** Which MITRE ATT&CK technique ID corresponds to the method the attacker employed to evade detection, as identified in the previous steps?

*Answer:* 

     T1036

---

## Task 5 | Conclusion

And what was next?

 Following our investigation, we identified that the adversary successfully carried out lateral movement to WIN-015, escalated privileges, and extracted credentials. Additionally, as initially suspected, the threat actor likely exfiltrated access keys. However, confirming this will require a more in-depth forensic analysis of the affected host.

 The current state of the incident indicates that the compromise at TryHatMe is more severe than initially anticipated. The organisation faces considerable efforts ahead to fully understand the scope of the breach and implement the necessary remediation steps to restore standard operational capability.

 Here’s a quick recap of what you covered:

 
- Detected lateral movement activity through memory artefacts.
- Investigated malicious process execution and system discovery behaviour.
- Uncovered privilege escalation and credential dumping indicators.

### **Answer the questions below**

**Question:** Well Done!

*Answer:* 

     No answer needed

---
{% endraw %}
