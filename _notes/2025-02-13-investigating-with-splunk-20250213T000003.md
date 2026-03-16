---
layout: post
title: "Investigating with Splunk"
date: 2025-02-13
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/SOC Level 1/Security Information and Event Management"
identifier: "20250213T000003"
source_id: "2d8fda45-2e70-4ce7-b4be-e1548adc19ce"
source_urls: "(https://tryhackme.com/room/investigatingwithsplunk)"
source_path: "SOC Level 1/Security Information and Event Management/20250213T000003--investigating-with-splunk__tryhackme.md"
---


# Investigating with Splunk

# Task 1 | Investigating with Splunk

Start MachineSOC Analyst **Johny** has observed some anomalous behaviours in the logs of a few windows machines. It looks like the adversary has access to some of these machines and successfully created some backdoor. His manager has asked him to pull those logs from suspected hosts and ingest them into Splunk for quick investigation. Our task as SOC Analyst is to examine the logs and identify the anomalies.

To learn more about Splunk and how to investigate the logs, look at the rooms [splunk101](https://tryhackme.com/room/splunk101) and [splunk201](https://tryhackme.com/room/splunk201).

Room Machine

Before moving forward, deploy the machine. When you deploy the machine, it will be assigned an IP **Machine IP** : `MACHINE_IP`. You can visit this IP from the VPN or the Attackbox. The machine will take up to 3-5 minutes to start. All the required logs are ingested in the index **main.** 

Answer the questions belowHow many events were collected and Ingested in the index **main** ?
Correct AnswerOn one of the infected hosts, the adversary was successful in creating a backdoor user. What is the new username?

Correct AnswerHintOn the same host, a registry key was also updated regarding the new backdoor user. What is the full path of that registry key?

Correct AnswerExamine the logs and identify the user that the adversary was trying to impersonate.

Correct AnswerWhat is the command used to add a backdoor user from a remote computer?

Correct AnswerHow many times was the login attempt from the backdoor user observed during the investigation?

Correct AnswerWhat is the name of the infected host on which suspicious Powershell commands were executed?

Correct AnswerPowerShell logging is enabled on this device. How many events were logged for the malicious PowerShell execution?

Correct AnswerAn encoded Powershell script from the infected host initiated a web request. What is the full URL?

SubmitHint

### **Answer the questions below**

**Question:** How many events were collected and Ingested in the index main?

*Answer:* 

     12256

**Question:** On one of the infected hosts, the adversary was successful in creating a backdoor user. What is the new username?

*Answer:* 

     A1berto

**Question:** On the same host, a registry key was also updated regarding the new backdoor user. What is the full path of that registry key?

*Answer:* 

     HKLM\SAM\SAM\Domains\Account\Users\Names\A1berto

**Question:** Examine the logs and identify the user that the adversary was trying to impersonate.

*Answer:* 

     Alberto

**Question:** What is the command used to add a backdoor user from a remote computer?

*Answer:* 

     C:\windows\System32\Wbem\WMIC.exe" /node:WORKSTATION6 process call create "net user /add A1berto paw0rd1

**Question:** How many times was the login attempt from the backdoor user observed during the investigation?

*Answer:* 

     0

**Question:** What is the name of the infected host on which suspicious Powershell commands were executed?

*Answer:* 

     James.browne

**Question:** PowerShell logging is enabled on this device. How many events were logged for the malicious PowerShell execution?

*Answer:* 

     79

**Question:** An encoded Powershell script from the infected host initiated a web request. What is the full URL?

*Answer:* 

     hxxp[://]10[.]10[.]10[.]5/news[.]php

---
