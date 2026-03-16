---
title:      "Friday Overtime"
date:       2025-02-05T20:55:22-05:00
tags:       ["tryhackme"]
identifier: "20250205T205524"
hubs: "TryHackMe/SOC Level 1/Cyber Threat Intelligence"
id: cb0a6d17-435b-41a5-905f-c28c5e1831ef
---

### SOC Level 1 > Cyber Threat Intelligence > Friday Overtime

### [TryHackMe | Friday Overtime](https://tryhackme.com/r/room/fridayovertime)

# Task 1 | Challenge Scenario

Start MachineDisclaimer

 **Please note:**  The artefacts used in this scenario were retrieved from a real-world cyber-attack. Hence, it is advised that interaction with the artefacts be done only inside the attached VM, as it is an isolated environment.

    
 Hello Busy Weekend. . .

 It's a Friday evening at PandaProbe Intelligence when a notification appears on your CTI platform. While most are already looking forward to the weekend, you realise you must pull overtime because SwiftSpend Finance has opened a new ticket, raising concerns about potential malware threats. The finance company, known for its meticulous security measures, stumbled upon something suspicious and wanted immediate expert analysis.

 As the only remaining CTI Analyst on shift at PandaProbe Intelligence, you quickly took charge of the situation, realising the gravity of a potential breach at a financial institution. The ticket contained multiple file attachments, presumed to be malware samples.

 With a deep breath, a focused mind, and the longing desire to go home, you began the process of:

  
1. Downloading the malware samples provided in the ticket, ensuring they were contained in a secure environment.
2. Running the samples through preliminary automated malware analysis tools to get a quick overview.
3. Deep diving into a manual analysis, understanding the malware's behaviour, and identifying its communication patterns.
4. Correlating findings with global threat intelligence databases to identify known signatures or behaviours.
5. Compiling a comprehensive report with mitigation and recovery steps, ensuring SwiftSpend Finance could swiftly address potential threats.

  Connecting to the machine

 Start the virtual machine in split-screen view by clicking the green **Start Machine**  button on the upper right section of this task. If the VM is not visible, use the blue **Show Split View**  button at the top-right of the page. Additionally, you can open the DocIntel platform using the credentials below.

   

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/be629720b11a294819516c1d4e738c92.png)

      **Username**    ericatracy     **Password**    Intel321!    **IP**    10.10.168.253        
 **Note:** While the web browser (i.e., Chromium) will immediately start after boot up, it may show a tab that has a "502 Bad Gateway" error message displayed. This is because the DocIntel platform takes about 5 more minutes to finish starting up **after**  the VM has completely booted up. After 5 minutes, you can **refresh** the page in order to view the login page. We appreciate your patience. The ticket details can be found by logging in to the DocIntel platform. **OSINT, a web browser, and a text editor outside the VM will also help.**

Answer the questions belowWho shared the malware samples?

Correct AnswerWhat is the SHA1 hash of the file "pRsm.dll" inside samples.zip?

Correct AnswerWhich malware framework utilizes these DLLs as add-on modules?

Correct AnswerHintWhich MITRE ATT&CK Technique is linked to using pRsm.dll in this malware framework?

Correct AnswerWhat is the CyberChef defanged URL of the malicious download location first seen on 2020-11-02?

Correct AnswerWhat is the CyberChef defanged IP address of the C&C server first detected on 2020-09-14 using these modules?

Correct AnswerWhat is the SHA1 hash of the spyagent family spyware hosted on the same IP targeting Android devices on November 16, 2022?

SubmitHint

### **Answer the questions below**

**Question:** Who shared the malware samples?

*Answer:* 

     Oliver Bennett

**Question:** What is the SHA1 hash of the file "pRsm.dll" inside samples.zip?

*Answer:* 

     9d1ecbbe8637fed0d89fca1af35ea821277ad2e8

**Question:** Which malware framework utilizes these DLLs as add-on modules?

*Answer:* 

     MgBot

**Question:** Which MITRE ATT&CK Technique is linked to using pRsm.dll in this malware framework?

*Answer:* 

     T1123

**Question:** What is the CyberChef defanged URL of the malicious download location first seen on 2020-11-02?

*Answer:* 

     hxxp[://]update[.]browser[.]qq[.]com/qmbs/QQ/QQUrlMgr_QQ88_4296[.]exe

**Question:** What is the CyberChef defanged IP address of the C&C server first detected on 2020-09-14 using these modules?

*Answer:* 

     122[.]10[.]90[.]12

**Question:** What is the SHA1 hash of the spyagent family spyware hosted on the same IP targeting Android devices on November 16, 2022?

*Answer:* 

     1c1fe906e822012f6235fcc53f601d006d15d7be

---

