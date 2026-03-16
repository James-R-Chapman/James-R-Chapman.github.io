---
layout: post
title: "TryHackMe  - IronShade"
date: 2025-09-03
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Advanced Endpoint Investigations/Linux Endpoint Investigation"
source_id: "6353d7f8-478a-4cc1-8463-173d70fb524d"
source_urls: "(https://tryhackme.com/room/ironshade)"
source_path: "Advanced Endpoint Investigations/Linux Endpoint Investigation/TryHackMe  - IronShade.md"
---


# TryHackMe | IronShade

## Task 1 | Linux Challenge

Start MachineIncident Scenario

Based on the threat intel report received, an infamous hacking group, **IronShade** , has been observed targeting Linux servers across the region. Our team had set up a honeypot and exposed weak SSH and ports to get attacked by the APT group and understand their attack patterns.

You are provided with one of the compromised Linux servers. Your task as a Security Analyst is to perform a thorough compromise assessment on the Linux server and identify the attack footprints. Some threat reports indicate that one indicator of their attack is creating a backdoor account for persistence.

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/5e8dd9a4a45e18443162feab-1722910370846.png)

Challenge

Investigate the server and identify the footprints left behind after the exploitation.

Prerequisites

The following rooms will act as prerequisites for this challenge:

 
- [Linux Logs Investigation](https://tryhackme.com/r/room/linuxlogsinvestigations)
- [Linux Live Analysis](https://tryhackme.com/r/room/linuxliveanalysis)
- [Linux Process Analysis](https://tryhackme.com/r/room/linuxprocessanalysis)

 Lab Connection Instructions

Before moving forward, start the lab by clicking the `Start Machine` Button. It will take 3-5 minutes to load properly. The VM will be accessible on the right side of the split screen. If the VM is not visible, use the blue Show Split View button at the top of the page.

Goodluck Hunting!!

### **Answer the questions below**

**Question:** What is the Machine ID of the machine we are investigating?

*Answer:* 

     dc7c8ac5c09a4bbfaf3d09d399f10d96

**Question:** What backdoor user account was created on the server?

*Answer:* 

     mircoservice

**Question:** What is the cronjob that was set up by the attacker for persistence?

*Answer:* 

     @reboot /home/mircoservice/printer_app

**Question:** Examine the running processes on the machine. Can you identify the suspicious-looking hidden process from the backdoor account?

*Answer:* 

     .strokes

**Question:** How many processes are found to be running from the backdoor account’s directory?

*Answer:* 

     2

**Question:** What is the name of the hidden file in memory from the root directory?

*Answer:* 

     .systmd

**Question:** What suspicious services were installed on the server? Format is service a, service b in alphabetical order.

*Answer:* 

     backup.service, strokes.service

**Question:** Examine the logs; when was the backdoor account created on this infected system?

*Answer:* 

     Aug  5 22:05:33

**Question:** From which IP address were multiple SSH connections observed against the suspicious backdoor account?

*Answer:* 

     10.11.75.247 

**Question:** How many failed SSH login attempts were observed on the backdoor account?

*Answer:* 

     8

**Question:** Which malicious package was installed on the host?

*Answer:* 

     pscanner

**Question:** What is the secret code found in the metadata of the suspicious package?

*Answer:* 

     {_tRy_Hack_ME_}

---
