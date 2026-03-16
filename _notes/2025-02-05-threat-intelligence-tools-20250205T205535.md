---
layout: post
title: "Threat Intelligence Tools"
date: 2025-02-05
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/SOC Level 1/Cyber Threat Intelligence"
identifier: "20250205T205535"
source_id: "c20cc17c-9c94-40dc-b1bb-d4b3e649329d"
source_path: "SOC Level 1/Cyber Threat Intelligence/20250205T205535--threat-intelligence-tools__tryhackme.md"
---

{% raw %}


### SOC Level 1 > Cyber Threat Intelligence > Threat Intelligence Tools

### [TryHackMe | Threat Intelligence Tools](https://tryhackme.com/r/room/threatinteltools)

# Task 1 | Room Outline

This room will cover the concepts of Threat Intelligence and various open-source tools that are useful. The learning objectives include:

- Understanding the basics of threat intelligence & its classifications.
- Using UrlScan.io to scan for malicious URLs.
- Using Abuse.ch to track malware and botnet indicators.
- Investigate phishing emails using PhishTool
- Using Cisco's Talos Intelligence platform for intel gathering.

Answer the questions belowRead the description! Continue to the next task.Correct Answer

### **Answer the questions below**

**Question:** Read the description! Continue to the next task.

*Answer:* 

     No answer needed

---

# Task 2 | Threat Intelligence

Threat Intelligence is the analysis of data and information using tools and techniques to generate meaningful patterns on how to mitigate against potential risks associated with existing or emerging threats targeting organisations, industries, sectors or governments.

 To mitigate against risks, we can start by trying to answer a few simple questions:

- Who's attacking you?
- What's their motivation?
- What are their capabilities?
- What artefacts and indicators of compromise should you look out for?

 Threat Intelligence Classifications: Threat Intel is geared towards understanding the relationship between your operational environment and your adversary. With this in mind, we can break down threat intel into the following classifications:

- **Strategic Intel:**  High-level intel that looks into the organisation's threat landscape and maps out the risk areas based on trends, patterns and emerging threats that may impact business decisions.
- **Technical Intel:**  Looks into evidence and artefacts of attack used by an adversary. Incident Response teams can use this intel to create a baseline attack surface to analyse and develop defence mechanisms.
- **Tactical Intel:**  Assesses adversaries' tactics, techniques, and procedures (TTPs). This intel can strengthen security controls and address vulnerabilities through real-time investigations.
- **Operational Intel:**  Looks into an adversary's specific motives and intent to perform an attack. Security teams may use this intel to understand the critical assets available in the organisation (people, processes, and technologies) that may be targeted.

Answer the questions belowI've read on Threat Intel and the classificationsCorrect Answer

### **Answer the questions below**

**Question:** I've read on Threat Intel and the classifications

*Answer:* 

     No answer needed

hubs:
    - [[TryHackMe]]
---

# Threat Intelligence Tools


# Task 3 | UrlScan.io

[Urlscan.io](https://urlscan.io/) is a free service developed to assist in scanning and analysing websites. It is used to automate the process of browsing and crawling through websites to record activities and interactions.

 When a URL is submitted, the information recorded includes the domains and IP addresses contacted, resources requested from the domains, a snapshot of the web page, technologies utilised and other metadata about the website.

 The site provides two views, the first one showing the most recent scans performed and the second one showing current live scans.

 ![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/db3fb7276dd4c303a5ef7aa04a2ad8a0.gif)

 Scan Results URL scan results provide ample information, with the following key areas being essential to look at:

 
- **Summary:**  Provides general information about the URL, ranging from the identified IP address, domain registration details, page history and a screenshot of the site.
- **HTTP:**  Provides information on the HTTP connections made by the scanner to the site, with details about the data fetched and the file types received.
- **Redirects:**  Shows information on any identified HTTP and client-side redirects on the site.
- **Links:**  Shows all the identified links outgoing from the site's homepage.
- **Behaviour:**  Provides details of the variables and cookies found on the site. These may be useful in identifying the frameworks used in developing the site.
- **Indicators:**  Lists all IPs, domains and hashes associated with the site. These indicators do not imply malicious activity related to the site.

 ![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/5ba68bbdd6e7e9ef2bbe2a0dc13106bc.gif)

**Note** : Due to the dynamic nature of internet activities, data searched can produce different results on different days as new information gets updated.

 Scenario You have been tasked to perform a scan on TryHackMe's domain. The results obtained are displayed in the image below. Use the details on the image to answer the questions:

![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/322ccb4ad9e4a6cd7e2998ba6def47ec.png)

 Answer the questions belowWhat was TryHackMe's Cisco Umbrella Rank based on the screenshot?Correct AnswerHow many domains did UrlScan.io identify on the screenshot?

Correct AnswerWhat was the main domain registrar listed on the screenshot?

Correct AnswerWhat was the main IP address identified for TryHackMe on the screenshot?

Correct Answer

### **Answer the questions below**

**Question:** What was TryHackMe's Cisco Umbrella Rank based on the screenshot?

*Answer:* 

     345612

**Question:** How many domains did UrlScan.io identify on the screenshot?

*Answer:* 

     13

**Question:** What was the main domain registrar listed on the screenshot?

*Answer:* 

     NAMECHEAP INC

**Question:** What was the main IP address identified for TryHackMe on the screenshot?

*Answer:* 

     2606:4700:10::ac43:1b0a

---

# Task 4 | Abuse.ch

[Abuse.ch](https://abuse.ch/) is a research project hosted by the Institue for Cybersecurity and Engineering at the Bern University of Applied Sciences in Switzerland. It was developed to identify and track malware and botnets through several operational platforms developed under the project. These platforms are:

 
- **Malware Bazaar:**  A resource for sharing malware samples.
- **Feodo Tracker:**  A resource used to track botnet command and control (C2) infrastructure linked with Emotet, Dridex and TrickBot.
- **SSL Blacklist:**  A resource for collecting and providing a blocklist for malicious SSL certificates and JA3/JA3s fingerprints.
- **URL Haus:**  A resource for sharing malware distribution sites.
- **Threat Fox:**  A resource for sharing indicators of compromise (IOCs).

 Let us look into these platforms individually.

 [MalwareBazaar](https://bazaar.abuse.ch/) As the name suggests, this project is an all in one malware collection and analysis database. The project supports the following features:

- **Malware Samples Upload:**  Security analysts can upload their malware samples for analysis and build the intelligence database. This can be done through the browser or an API.
- **Malware Hunting:**  Hunting for malware samples is possible through setting up alerts to match various elements such as tags, signatures, YARA rules, ClamAV signatures and vendor detection.

 ![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/55890b3448b3ecf9a55705cd1bd20b08.gif)

 [FeodoTracker](https://feodotracker.abuse.ch/) With this project, Abuse.ch is targeting to share intelligence on botnet Command & Control (C&C) servers associated with Dridex, Emotes (aka Heodo), TrickBot, QakBot and BazarLoader/BazarBackdoor. This is achieved by providing a database of the C&C servers that security analysts can search through and investigate any suspicious IP addresses they have come across. Additionally, they provide various IP and IOC blocklists and mitigation information to be used to prevent botnet infections.

![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/22e34a463f65fbf7e621a54e347543be.gif)

 

 [SSL Blacklist](https://sslbl.abuse.ch/) Abuse.ch developed this tool to identify and detect malicious SSL connections. From these connections, SSL certificates used by botnet C2 servers would be identified and updated on a denylist that is provided for use. The denylist is also used to identify JA3 fingerprints that would help detect and block malware botnet C2 communications on the TCP layer.

 You can browse through the SSL certificates and JA3 fingerprints lists or download them to add to your deny list or threat hunting rulesets.

![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/78bb7ba13a89c203b3ed331df18e2c4d.gif)

 [URLhaus](https://urlhaus.abuse.ch/) As the name points out, this tool focuses on sharing malicious URLs used for malware distribution. As an analyst, you can search through the database for domains, URLs, hashes and filetypes that are suspected to be malicious and validate your investigations.

 The tool also provides feeds associated with country, AS number and Top Level Domain that an analyst can generate based on specific search needs.

 ![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/f388122492011e9506410912afd749d1.gif)

 [ThreatFox](https://threatfox.abuse.ch/) With ThreatFox, security analysts can search for, share and export indicators of compromise associated with malware. IOCs can be exported in various formats such as MISP events, Suricata IDS Ruleset, Domain Host files, DNS Response Policy Zone, JSON files and CSV files.

 ![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/e0fffff3133f4641f85190228990bdfb.gif)

Answer the questions belowThe IOC **212.192.246.30:5555** is identified under which malware alias name on ThreatFox?
Correct AnswerHintWhich malware is associated with the JA3 Fingerprint **51c64c77e60f3980eea90869b68c58a8**  on SSL Blacklist?

Correct AnswerFrom the statistics page on URLHaus, what malware-hosting network has the ASN number **AS14061** ?

Correct AnswerWhich country is the botnet IP address **178.134.47.166**  associated with according to FeodoTracker?

Correct Answer

### **Answer the questions below**

**Question:** The IOC 212.192.246.30:5555 is identified under which malware alias name on ThreatFox?

*Answer:* 

     Katana

**Question:** Which malware is associated with the JA3 Fingerprint 51c64c77e60f3980eea90869b68c58a8 on SSL Blacklist?

*Answer:* 

     Dridex

**Question:** From the statistics page on URLHaus, what malware-hosting network has the ASN number AS14061?

*Answer:* 

     DIGITALOCEAN-ASN

**Question:** Which country is the botnet IP address 178.134.47.166 associated with according to FeodoTracker?

*Answer:* 

     Georgia

hubs:
    - "[[TryHackMe]]"
---


# Task 5 | PhishTool

Start MachineBefore going into the task, click the Start Machine button to start the attached VM and open it in Split View. You will be using the same machine through tasks 7 and 8.

This task will introduce you to a tool, **PhishTool,**  that you would add to your toolkit of email analysis tools. Please take note that it would not be necessary to use it to complete the task; however, the principles learnt would be helpful.

 Email Phishing Email phishing is one of the main precursors of any cyber attack. Unsuspecting users get duped into opening and accessing malicious files and links sent to them by email, as they appear to be legitimate. As a result, adversaries infect their victims’ systems with malware, harvesting their credentials and personal data and performing other actions such as financial fraud or conducting ransomware attacks.

 For more information and content on phishing, check out these rooms:

 
- [Phishing
Emails 1](https://tryhackme.com/room/phishingemails1tryoe)
- [Phishing
Emails 2](https://tryhackme.com/room/phishingemails2rytmuv)
- [Phishing
Emails 3](https://tryhackme.com/room/phishingemails3tryoe)
- [Phishing Emails 4](https://tryhackme.com/room/phishingemails4gkxh)
- [Phishing Emails 5](https://tryhackme.com/room/phishingemails5fgjlzxc)

 [PhishTool](https://www.phishtool.com/) seeks to elevate the perception of phishing as a severe form of attack and provide a responsive means of email security. Through email analysis, security analysts can uncover email IOCs, prevent breaches and provide forensic reports that could be used in phishing containment and training engagements.

 PhishTool has two accessible versions: **Community**  and **Enterprise** . We shall mainly focus on the Community version and the core features in this task. Sign up for an account via this [link](https://app.phishtool.com/sign-up/community) to use the tool.

 The core features include:

 
- **Perform email analysis:**  PhishTool retrieves metadata from phishing emails and provides analysts with the relevant explanations and capabilities to follow the email’s actions, attachments, and URLs to triage the situation.
- **Heuristic intelligence:**  OSINT is baked into the tool to provide analysts with the intelligence needed to stay ahead of persistent attacks and understand what TTPs were used to evade security controls and allow the adversary to social engineer a target.
- **Classification and reporting:**  Phishing email classifications are conducted to allow analysts to take action quickly. Additionally, reports can be generated to provide a forensic record that can be shared.

 Additional features are available on the Enterprise version:

 
- Manage user-reported phishing events.
- Report phishing email findings back to users and keep them engaged in the process.
- Email stack integration with Microsoft 365 and Google Workspace.

 We are presented with an upload file screen from the Analysis tab on login. Here, we submit our email for analysis in the stated file formats. Other tabs include:

 
- **History:**  Lists all submissions made with their resolutions.
- **In-tray:**  An Enterprise feature used to receive and process phish reports posted by team members through integrating Google Workspace and Microsoft 365.

 ![Image 9](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/4c5d66d92d6aeb83d67961be5239842d.png)

 Analysis Tab Once uploaded, we are presented with the details of our email for a more in-depth look. Here, we have the following tabs:

 
- **Headers:**  Provides the routing information of the email, such as source and destination email addresses, Originating IP and DNS addresses and Timestamp.
- **Received Lines:**  Details on the email traversal process across various SMTP servers for tracing purposes.
- **X-headers:**  These are extension headers added by the recipient mailbox to provide additional information about the email.
- **Security:**  Details on email security frameworks and policies such as Sender Policy Framework (SPF), DomainKeys Identified Mail (DKIM) and Domain-based Message Authentication, Reporting and Conformance (DMARC).
- **Attachments:**  Lists any file attachments found in the email.
- **Message URLs:**  Associated external URLs found in the email will be found here.

 We can further perform lookups and flag indicators as malicious from these options. On the right-hand side of the screen, we are presented with the Plaintext and Source details of the email.

 ![Image 10](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/03364f3a4fb2177cce13abc3b181bca9.gif)

Above the **Plaintext**  section, we have a **Resolve**  checkmark. Here, we get to perform the resolution of our analysis by classifying the email, setting up flagged artefacts and setting the classification codes. Once the email has been classified, the details will appear on the **Resolution**  tab on the analysis of the email.

![Image 11](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/b13d63d0c2fe177085a1b487efb4065e.gif)

You can now add **PhishTool** to your list of email analysis tools.

 ScenarioYou are a SOC Analyst and have been tasked to analyse a suspicious email, **Email1.eml** . To solve the task, open the email using **Thunderbird** on the attached VM, analyse it and answer the questions below.Answer the questions belowWhat social media platform is the attacker trying to pose as in the email?

Correct AnswerHintWhat is the senders email address?
Correct AnswerWhat is the recipient's email address?

Correct AnswerWhat is the Originating IP address? Defang the IP address.

Correct AnswerHintHow many hops did the email go through to get to the recipient?

Correct Answer

### **Answer the questions below**

**Question:** What social media platform is the attacker trying to pose as in the email?

*Answer:* 

     LinkedIn

**Question:** What is the senders email address?

*Answer:* 

     darkabutla@sc500.whpservers.com

**Question:** What is the recipient's email address?

*Answer:* 

     cabbagecare@hotsmail.com

**Question:** What is the Originating IP address? Defang the IP address.

*Answer:* 

     204[.]93[.]183[.]11

**Question:** How many hops did the email go through to get to the recipient?

*Answer:* 

     4

---

# Task 6 | Cisco Talos Intelligence

IT and Cybersecurity companies collect massive amounts of information that could be used for threat analysis and intelligence. Being one of those companies, Cisco assembled a large team of security practitioners called Cisco Talos to provide actionable intelligence, visibility on indicators, and protection against emerging threats through data collected from their products. The solution is accessible as [Talos Intelligence](https://talosintelligence.com/).

 Cisco Talos encompasses six key teams:

 
- **Threat Intelligence & Interdiction:**  Quick correlation and tracking of threats provide a means to turn simple IOCs into context-rich intel.
- **Detection Research:**  Vulnerability and malware analysis is performed to create rules and content for threat detection.
- **Engineering & Development:**  Provides the maintenance support for the inspection engines and keeps them up-to-date to identify and triage emerging threats.
- **Vulnerability Research & Discovery:**  Working with service and software vendors to develop repeatable means of identifying and reporting security vulnerabilities.
- **Communities:**  Maintains the image of the team and the open-source solutions.
- **Global Outreach:**  Disseminates intelligence to customers and the security community through publications.

 More information about Cisco Talos can be found on their [White
Paper](https://www.talosintelligence.com/docs/Talos_WhitePaper.pdf)

 Talos Dashboard Accessing the open-source solution, we are first presented with a reputation lookup dashboard with a world map. This map shows an overview of email traffic with indicators of whether the emails are legitimate, spam or malware across numerous countries. Clicking on any marker, we see more information associated with IP and hostname addresses, volume on the day and the type.

 ![Image 12](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/e8ad635a9e449c698e081895bbb13ab1.png)

At the top, we have several tabs that provide different types of intelligence resources. The primary tabs that an analyst would interact with are:

 
- **Vulnerability Information:**  Disclosed and zero-day vulnerability reports marked with CVE numbers and CVSS scores. Details of the vulnerabilities reported are provided when you select a specific report, including the timeline taken to get the report published. Microsoft vulnerability advisories are also provided, with the applicable snort rules that can be used.

 ![Image 13](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/c761ada971950f5c2b676263d6e328a8.gif)

 
- **Reputation Center:**  Provides access to searchable threat data related to IPs and files using their SHA256 hashes. Analysts would rely on these options to conduct their investigations. Additional email and spam data can be found under the **Email & Spam Data tab** .

 ![Image 14](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/e14c377b524b9eb51b0a8ed8f1ee8356.gif)

 ![Image 15](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/844f12e63a5a255b85df2ad6d261facb.gif)

 Task Use the information gathered from inspecting the **Email1.eml**  file from Task 5 to answer the following questions using Cisco Talos Intelligence. Please note that the VM launched in Task 5 would not have access to the Internet.

Answer the questions belowWhat is the listed domain of the IP address from the previous task?Correct AnswerHintWhat is the customer name of the IP address?

Correct AnswerHint

### **Answer the questions below**

**Question:** What is the listed domain of the IP address from the previous task?

*Answer:* 

     scnet.net

**Question:** What is the customer name of the IP address?

*Answer:* 

     Complete Web Reviews

hubs:
    - "[[TryHackMe]]"
---


# Task 7 | Scenario 1

![Image 16](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/8e3277d4996e27e57bcc63ae0705549e.png)

 **Scenario** **:**  You are a SOC Analyst. Several suspicious emails have been forwarded to you from other coworkers. You must obtain details from each email to triage the incidents reported.

**Task** : Use the tools and knowledge discussed throughout this room (or use your resources) to help you analyze **Email2.eml** **** found on the VM attached to **Task 5**  and use the information to answer the questions.

Answer the questions belowAccording to **Email2.eml** , what is the recipient's email address?Correct AnswerOn VirusTotal, the attached file can also be identified by a Detection Alias, which starts with an **H.**

Correct Answer

### **Answer the questions below**

**Question:** According to Email2.eml, what is the recipient's email address?

*Answer:* 

     chris.lyons@supercarcenterdetroit.com

**Question:** On VirusTotal, the attached file can also be identified by a Detection Alias, which starts with an H.

*Answer:* 

     HIDDENEXT/Worm.Gen

---

# Task 8 | Scenario 2

![Image 17](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/8e3277d4996e27e57bcc63ae0705549e.png)

 Scenario: You are a SOC Analyst. Several suspicious emails have been forwarded to you from other coworkers. You must obtain details from each email to triage the incidents reported.

Task: Use the tools and knowledge discussed throughout this room (or use your resources) to help you analyze **Email3.eml** found on the VM attached to **Task 5**  and use the information to answer the questions.

Answer the questions belowWhat is the name of the attachment on Email3.eml?Correct AnswerWhat malware family is associated with the attachment on Email3.eml?

Correct Answer

### **Answer the questions below**

**Question:** What is the name of the attachment on Email3.eml?

*Answer:* 

     Sales_Receipt 5606.xls

**Question:** What malware family is associated with the attachment on Email3.eml?

*Answer:* 

     Dridex

hubs:
    - "[[TryHackMe]]"
---


# Task 9 | Conclusion

There's More Out There You have come to the end of the room. However, this is just the tip of the iceberg for open-source threat intelligence tools that can help you as an analyst triage through incidents. There are plenty of more tools that may have more functionalities than the ones discussed in this room.

Check out these rooms to dive deeper into Threat Intelligence:

- [Yara](https://tryhackme.com/room/yara)
- [MISP](https://tryhackme.com/room/misp)
- [Red Team Threat Intel](https://tryhackme.com/room/redteamthreatintel)

Answer the questions belowRead the above and completed the roomComplete

### **Answer the questions below**

**Question:** Read the above and completed the room

*Answer:* 

     No answer needed

---
{% endraw %}
