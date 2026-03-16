---
layout: post
title: "TryHackMe | Systems as Attack Vectors"
date: 2025-11-11
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/SOC Level 1/Blue Team Introduction"
source_id: "a400ab69-65ff-4b24-bd0f-491db504831e"
source_path: "SOC Level 1/Blue Team Introduction/TryHackMe  - Systems as Attack Vectors.md"
---


# TryHackMe | Systems as Attack Vectors

## Task 1 | Introduction

Continue exploring the SOC role in protecting the digital world, now focusing on systems as attack vectors. In this room, you will learn what the systems are, why and how threat groups target them, and what you can do as a SOC analyst to keep your company secure.

 Learning Objectives 
- Learn the role of a system in a modern digital world
- Explore a variety of real-world attacks targeting systems
- Practice the acquired knowledge in two realistic scenarios

 Prerequisites 
- Complete the [Junior Security Analyst](https://tryhackme.com/room/jrsecanalystintrouxo) room
- Complete the [Humans as Attack Vectors](https://tryhackme.com/room/humansattackvectors) room

### **Answer the questions below**

**Question:** 

*Answer:* 

     No answer needed

---

## Task 2 | Definition of System

Imagine a castle again, but now with a trained gatekeeper who knows how to identify phishing and how to combat deepfakes. However, if the lock on the main gate is fragile and cheap, guardian skills do not matter, as the enemy can just sneak into the castle while no one is watching. In cyber terms, threat actors can attack insecure systems directly, without the users' knowledge.

 ![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1752596680315.svg)

 Definition of System Where do the banks store your cards, or where are your emails stored? The answer - on a system: a physical server, a virtual machine, or a cloud platform like Microsoft 365. Protecting such systems is crucial: if the attackers breach one user's mailbox via phishing, they compromise a single mailbox, but if they breach a mail server, they now control all thousands of mailboxes. Each system type can have a different value for threat actors, for example:

    Breached System Attack Value   A personal laptop of a school student Steal Steam profile and add the PC to a botnet   A laptop of the bank's senior IT administrator Get access to the internal banking systems   A mail server of a criminal law company Dump all mailboxes and blackmail the victim    A server at the heart of an industrial network Encrypt the whole network with ransomware   A government website management panel Damage the website content ([defacement](https://en.wikipedia.org/wiki/Website_defacement) / activism)

### **Answer the questions below**

**Question:** 

*Answer:* 

     Yea

**Question:** 

*Answer:* 

     Yea

---

## Task 3 | Attacks on Systems

In most serious attacks, the first goal is to gain **access**  to the target system. What happens next depends on the attacker's motivation: stealing data, deploying ransomware, or even destroying information without a way to recover. However, nearly all attacks begin the same way. Let's look at three examples of how systems are attacked.

 Human-Led Attacks It's no surprise that system users are often those who start the attack: By inserting a malicious USB found on a street, downloading malware from pirated resources, or simply reusing a weak password everywhere. [81%](https://deepstrike.io/blog/password-statistics-2025) of breaches involve stolen or breached passwords - [check out](https://haveibeenpwned.com/Passwords) your passwords too!

 ![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1753218281339.svg)

 Vulnerabilities Every piece of software can have security flaws. In 2024, [over 40,000](https://cyberpress.org/over-40000-cves-published-in-2024/) software vulnerabilities were published and [more than 300](https://www.cisa.gov/known-exploited-vulnerabilities-catalog) were actively exploited in major attacks. Moreover, IT administrators often increase the risks by setting weak passwords and allowing unrestricted access to their systems.

 ![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1753218271259.svg)

 Supply Chain Your PC is home to hundreds of apps, including web browsers, messengers, development, and entertainment software. Every app depends on thousands of libraries. If threat actors manage to breach one of the apps or libraries and push an update to all its users, all of them will be compromised. This technique is called a supply chain attack. The most famous examples are the [SolarWinds](https://attack.mitre.org/campaigns/C0024/#:~:text=Victims%20of%20this%20campaign%20included%20government) and [3CX](https://cloud.google.com/blog/topics/threat-intelligence/3cx-software-supply-chain-compromise) breaches which affected thousands of companies.

 **Emerging Threat of Supply Chain**

 It is hard to protect from supply chain attacks since you can't always control all the software present on your laptops, servers, and web apps. Even TryHackMe once [fell victim](https://tryhackme.com/room/supplychainattacks) to a supply chain in Lottie Player, a library used for room animations. As a SOC analyst, you must be ready for such scenarios and know how to respond!

### **Answer the questions below**

**Question:** 

*Answer:* 

     Vulnerability

**Question:** 

*Answer:* 

     Supply Chain

---

## Task 4 | Vulnerabilities

Software Vulnerabilities Every piece of software has flaws, but some take years to be discovered. For example, [Shellshock](https://www.invicti.com/blog/web-security/cve-2014-6271-shellshock-bash-vulnerability-scan/), a major Linux vulnerability, existed since 1992 but wasn't found until 2014. In the worst-case scenario, attackers discover the vulnerability before anyone else. This is known as a [zero-day](https://en.wikipedia.org/wiki/Zero-day_vulnerability), and only your SOC skills can determine whether it gets detected in time.

 Once a vulnerability is made public, it is assigned a Common Vulnerabilities and Exposures ([CVE](https://www.cvedetails.com/cisa-known-exploited-vulnerabilities/kev-1.html)) number. From that moment, it's a race: attackers develop exploits while defenders rush to update their systems. Here is the timeline of how Windows vulnerabilities evolve every year:

 ![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1752598525644.svg)

 Responding to Vulnerabilities An answer to a CVE is always **a patch** - an update supplied by the software vendor. Even for zero-days, you'll have to wait for a patch, vigilantly monitor for exploitation traces, and try to survive the stressful period before the patch is released. For example, by:

 
- Restricting access to the system to only trusted IPs
- Applying temporary measures provided by the vendor
- Blocking known attack patterns on IPS or WAF

### **Answer the questions below**

**Question:** 

*Answer:* 

     CVE-2025-53770

**Question:** 

*Answer:* 

     Patch

---

## Task 5 | Misconfigurations

Misconfigurations On the other hand, a misconfiguration isn't a bug in the software but a mistake in how the system was set up, often by the IT team. These errors happen frequently, usually to make things simpler, like using "1111" instead of typing a long password every time. Let's take a look at some real-world examples.

 
- How ["123456" password](https://www.bleepingcomputer.com/news/security/123456-password-exposed-chats-for-64-million-mcdonalds-job-chatbot-applications/) exposed chats for 64 million McDonald's job applications
- How a [misconfigured AWS cloud](https://www.bleepingcomputer.com/news/security/capital-one-data-breach-affects-106-million-people-suspect-arrested/#:~:text=intrusion%20occurred%20through%20a%20misconfigured%20web%20application%20firewall) resulted in a breach of 106 million bank customers
- How improperly configured [smart fridges](https://www.sectigo.com/resource-library/when-refrigerators-attack-how-cyber-criminals-infect-appliances-and-how-manufacturers-can-stop-them) are silently used in full-scale botnet attacks

 Another common scenario is when the IT department unknowingly introduces new flaws into secure systems. Below is a simple example of how a critical database can be breached because of the insecure configuration:

 ![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1754915771066.svg)

 Responding to Misconfigurations Misconfigurations do not require a software update - just a better setup. As a SOC analyst, you'll often spot them only after threat actors exploit them. However, in smaller companies, you might also be responsible for a more proactive response, for example:

 
- **Penetration Testing** : Hire ethical "hackers" who simulate an attack and report on discovered security flaws
- **Vulnerability Scans** : Periodically run tools that can detect default passwords or outdated software
- **Configuration Audits** : Manually review the systems to match best practices like [CIS benchmarks](https://www.cisecurity.org/cis-benchmarks)

### **Answer the questions below**

**Question:** 

*Answer:* 

     Nay

**Question:** 

*Answer:* 

     Penetration Testing

---

## Task 6 | Practice

Remember our fortress analogy? Attackers are opportunists. They'll often seek the easiest path, whether through a flaw in the building itself or by manipulating someone to open a door. Attackers don't see "human hacking" and "system hacking" as separate, so you should apply equal effort into protecting both humans and systems, combining **Mitigation** and **Detection** :

 ![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1752599036221.svg)

 Unlike humans, you can't train the system to spot the attack. However, you can train your IT department to configure the systems and explain how to avoid simple mistakes. Below are the most common mitigation measures to protect your systems:

    Mitigation Description   **Patch Management**  A process of tracking and patching the vulnerable systems significantly reduces the chance of a successful attack   **Training for IT**  If your IT knows the risks of misconfigurations, they are less likely to leave the systems unprotected   **Network Protection**  The system is much harder to breach if access to it is restricted to trusted people or IP addresses   **Antivirus Protection**  Same as with attacks on humans, a good antivirus can stop or at least detect many different attacks     Practice View Site For this lab, continue your SOC analyst journey at TryHackMe. This time, decide what to do with the **Systems at Risk**  and choose the best measures to protect your systems at the **Remediation Plan** tabs. Open the security dashboard by clicking the **View Site**  button, complete the tasks, and claim the flags to answer the task questions!

 ![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1753289285149.png)

### **Answer the questions below**

**Question:** 

*Answer:* 

     THM{patch_or_reconfigure?}

**Question:** 

*Answer:* 

     THM{best_systems_defender!}

---

## Task 7 | Conclusion

Even though SOC analysts don't typically manage systems directly, understanding the common attacks and defenses, and sharing them with the IT department, is a key to broadening your cyber security perspective. If you want to grow quickly and be a strong team player, stay updated on the latest threats and always share the news with others!

 
- [The DFIR Report: How Real Intrusions Happen](https://thedfirreport.com/)
- [CISA: Known Exploited Vulnerabilities Catalog](https://www.cisa.gov/known-exploited-vulnerabilities-catalog)
- [BleepingComputer: Latest Supply Chain Attacks](https://www.bleepingcomputer.com/tag/supply-chain-attack/)
- [CheckPoint: Interactive Live Cyber Threat Map](https://threatmap.checkpoint.com/)

### **Answer the questions below**

**Question:** 

*Answer:* 

     No answer needed

---
