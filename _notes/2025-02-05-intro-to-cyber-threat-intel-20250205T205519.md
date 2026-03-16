---
layout: post
title: "Intro to Cyber Threat Intel"
date: 2025-02-05
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/SOC Level 1/Cyber Threat Intelligence"
identifier: "20250205T205519"
source_id: "72ffe3a6-3630-47a0-8908-0a47b5a5d4cc"
source_path: "SOC Level 1/Cyber Threat Intelligence/20250205T205519--intro-to-cyber-threat-intel__tryhackme.md"
---

{% raw %}


### SOC Level 1 > Cyber Threat Intelligence > Intro to Cyber Threat Intel

### [TryHackMe | Intro to Cyber Threat Intel](https://tryhackme.com/r/room/cyberthreatintel)

# Task 1 | Introduction

Introduction  This room will introduce you to cyber threat intelligence (CTI) and various frameworks used to share intelligence. As security analysts, CTI is vital for investigating and reporting against adversary attacks with organisational stakeholders and external communities.
Learning Objectives 
- The basics of CTI and its various classifications.
- The lifecycle followed to deploy and use intelligence during threat investigations.
- Frameworks and standards used in distributing intelligence.

  Cyber Threat Intelligence Module  This is the first room in a new Cyber Threat Intelligence module. The module will also contain:

- [Threat Intelligence Tools](https://tryhackme.com/room/threatinteltools)
- [YARA](https://tryhackme.com/room/yara)
- [OpenCTI](https://tryhackme.com/room/opencti)
- [MISP](https://tryhackme.com/room/misp)

 

Answer the questions belowReady to get started!Complete

### **Answer the questions below**

**Question:** Ready to get started!

*Answer:* 

     No answer needed

---

# Task 2 | Cyber Threat Intelligence

Cyber Threat Intelligence (CTI) can be defined as evidence-based knowledge about adversaries, including their indicators, tactics, motivations, and actionable advice against them. These can be utilised to protect critical assets and inform cyber security teams and management business decisions.

 It would be typical to use the terms “data”, “information”, and “intelligence” interchangeably. However, let us distinguish between them to understand better how CTI comes into play.

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/c6ac1f3a2bcd93791876a3e07342eeae.png)

 **Data:**  Discrete indicators associated with an adversary, such as IP addresses, URLs or hashes.

 **Information:**  A combination of multiple data points that answer questions such as “How many times have employees accessed tryhackme.com within the month?”

 **Intelligence:**  The correlation of data and information to extract patterns of actions based on contextual analysis.

The primary goal of CTI is to understand the relationship between your operational environment and your adversary and how to defend your environment against any attacks. You would seek this goal by developing your cyber threat context by trying to answer the following questions:

 
- Who’s attacking you?
- What are their motivations?
- What are their capabilities?
- What artefacts and indicators of compromise (IOCs) should you look out for?

 With these questions, threat intelligence would be gathered from different sources under the following categories:

 
- **Internal:** 
- Corporate security events such as vulnerability assessments and incident response reports.
- Cyber awareness training reports.
- System logs and events.
- **Community:** 
- Open web forums.
- Dark web communities for cybercriminals.
- **External** 
- Threat intel feeds (Commercial & Open-source)
- Online marketplaces.
- Public sources include government data, publications, social media, financial and industrial assessments.

 Threat Intelligence Classifications

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/cd207b841ee45fd4e62eaf4266cc06ae.png)

 Threat Intel is geared towards understanding the relationship between your operational environment and your adversary. With this in mind, we can break down threat intel into the following classifications:   
- **Strategic Intel:**  High-level intel that looks into the organisation’s threat landscape and maps out the risk areas based on trends, patterns and emerging threats that may impact business decisions.
- **Technical Intel:**  Looks into evidence and artefacts of attack used by an adversary. Incident Response teams can use this intel to create a baseline attack surface to analyse and develop defence mechanisms.
- **Tactical Intel:**  Assesses adversaries’ tactics, techniques, and procedures (TTPs). This intel can strengthen security controls and address vulnerabilities through real-time investigations.
- **Operational Intel:**  Looks into an adversary’s specific motives and intent to perform an attack. Security teams may use this intel to understand the critical assets available in the organisation (people, processes and technologies) that may be targeted.

Answer the questions belowWhat does CTI stand for?Correct AnswerIP addresses, Hashes and other threat artefacts would be found under which Threat Intelligence classification?

Correct Answer

### **Answer the questions below**

**Question:** What does CTI stand for?

*Answer:* 

     Cyber Threat Intelligence

**Question:** IP addresses, Hashes and other threat artefacts would be found under which Threat Intelligence classification?

*Answer:* 

     Technical Intel

---

# Intro to Cyber Threat Intel


# Task 3 | CTI Lifecycle

![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/3ef6866baa7c627fe9a0e55bab05eb0c.png)

Threat intel is obtained from a data-churning process that transforms raw data into contextualised and action-oriented insights geared towards triaging security incidents. The transformational process follows a six-phase cycle:

 Direction Every threat intel program requires to have objectives and goals defined, involving identifying the following parameters:

 
- Information assets and business processes that require defending.
- Potential impact to be experienced on losing the assets or through process interruptions.
- Sources of data and intel to be used towards protection.
- Tools and resources that are required to defend the assets.

 This phase also allows security analysts to pose questions related to investigating incidents.

 Collection Once objectives have been defined, security analysts will gather the required data to address them. Analysts will do this by using commercial, private and open-source resources available. Due to the volume of data analysts usually face, it is recommended to automate this phase to provide time for triaging incidents.

 Processing Raw logs, vulnerability information, malware and network traffic usually come in different formats and may be disconnected when used to investigate an incident. This phase ensures that the data is extracted, sorted, organised, correlated with appropriate tags and presented visually in a usable and understandable format to the analysts. SIEMs are valuable tools for achieving this and allow quick parsing of data.

 Analysis Once the information aggregation is complete, security analysts must derive insights. Decisions to be made may involve:

- Investigating a potential threat through uncovering indicators and attack patterns.
- Defining an action plan to avert an attack and defend the infrastructure.
- Strengthening security controls or justifying investment for additional resources.

 Dissemination Different organisational stakeholders will consume the intelligence in varying languages and formats. For example, C-suite members will require a concise report covering trends in adversary activities, financial implications and strategic recommendations. At the same time, analysts will more likely inform the technical team about the threat IOCs, adversary TTPs and tactical action plans.

 Feedback The final phase covers the most crucial part, as analysts rely on the responses provided by stakeholders to improve the threat intelligence process and implementation of security controls. Feedback should be regular interaction between teams to keep the lifecycle working.

Answer the questions belowAt which phase of the CTI lifecycle is data converted into usable formats through sorting, organising, correlation and presentation?Correct AnswerDuring which phase do security analysts get the chance to define the questions to investigate incidents?

Correct Answer

### **Answer the questions below**

**Question:** At which phase of the CTI lifecycle is data converted into usable formats through sorting, organising, correlation and presentation?

*Answer:* 

     Processing

**Question:** During which phase do security analysts get the chance to define the questions to investigate incidents?

*Answer:* 

     Direction

---

# Task 4 | CTI Standards & Frameworks

Standards and frameworks provide structures to rationalise the distribution and use of threat intel across industries. They also allow for common terminology, which helps in collaboration and communication. Here, we briefly look at some essential standards and frameworks commonly used.

[MITRE]() ATT&CKThe [ATT&CK framework](https://tryhackme.com/room/mitre) is a knowledge base of adversary behaviour, focusing on the indicators and tactics. Security analysts can use the information to be thorough while investigating and tracking adversarial behaviour.

![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/5d94b9da7f9ddc77bd46895bc1b936d8.png)

 TAXII[The Trusted Automated eXchange of Indicator Information (TAXII)](https://oasis-open.github.io/cti-documentation/taxii/intro) defines protocols for securely exchanging threat intel to have near real-time detection, prevention and mitigation of threats. The protocol supports two sharing models:

- Collection: Threat intel is collected and hosted by a producer upon request by users using a request-response model.
- Channel: Threat intel is pushed to users from a central server through a publish-subscribe model.

 STIX[Structured Threat Information Expression (STIX)](https://oasis-open.github.io/cti-documentation/stix/intro) is a language developed for the "specification, capture, characterisation and communication of standardised cyber threat information". It provides defined relationships between sets of threat info such as observables, indicators, adversary TTPs, attack campaigns, and more.

 Cyber Kill ChainDeveloped by Lockheed Martin, the Cyber Kill Chain breaks down adversary actions into steps. This breakdown helps analysts and defenders identify which stage-specific activities occurred when investigating an attack. The phases defined are shown in the image below.

![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/ef67be43aaf8073a8309df3e160c7e36.png)

TechniquePurposeExamplesReconnaissanceObtain information about the victim and the tactics used for the attack.Harvesting emails, OSINT, and social media, network scansWeaponisationMalware is engineered based on the needs and intentions of the attack.Exploit with a backdoor, malicious office documentDeliveryCovers how the malware would be delivered to the victim's system.Email, weblinks, USBExploitationBreach the victim's system vulnerabilities to execute code and create scheduled jobs to establish persistence.
EternalBlue, Zero-Logon, etc.InstallationInstall malware and other tools to gain access to the victim's system.Password dumping, backdoors, remote access trojansCommand & ControlRemotely control the compromised system, deliver additional malware, move across valuable assets and elevate privileges.Empire, Cobalt Strike, etc.Actions on ObjectivesFulfil the intended goals for the attack: financial gain, corporate espionage, and data exfiltration.Data encryption, ransomware, public defacementOver time, the kill chain has been expanded using other frameworks such as ATT&CK and formulated a new Unified Kill Chain.

 The Diamond Model

 

![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/d31177261479b466ecbe964447ac4f84.svg)

The diamond model looks at intrusion analysis and tracking attack groups over time. It focuses on four key areas, each representing a different point on the diamond. These are:

 
- **Adversary:** The focus here is on the threat actor behind an attack and allows analysts to identify the motive behind the attack.
- **Victim:**  The opposite end of adversary looks at an individual, group or organisation affected by an attack.
- **Infrastructure:** The adversaries' tools, systems, and software to conduct their attack are the main focus. Additionally, the victim's systems would be crucial to providing information about the compromise.
- **Capabilities:**  The focus here is on the adversary's approach to reaching its goal. This looks at the means of exploitation and the TTPs implemented across the attack timeline

 An example of the diamond model in play would involve an adversary targeting a victim using phishing attacks to obtain sensitive information and compromise their system, as displayed on the diagram. As a threat intelligence analyst, the model allows you to pivot along its properties to produce a complete picture of an attack and correlate indicators.

Answer the questions belowWhat sharing models are supported by TAXII?Correct AnswerHintWhen an adversary has obtained access to a network and is extracting data, what phase of the kill chain are they on?

Correct Answer

### **Answer the questions below**

**Question:** What sharing models are supported by TAXII?

*Answer:* 

     Collection and Channel

**Question:** When an adversary has obtained access to a network and is extracting data, what phase of the kill chain are they on?

*Answer:* 

     Actions on Objectives

---


# Task 5 | Practical Analysis

View Site![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/8e3277d4996e27e57bcc63ae0705549e.png)

As part of the dissemination phase of the lifecycle, CTI is also distributed to organisations using published threat reports. These reports come from technology and security companies that research emerging and actively used threat vectors. They are valuable for consolidating information presented to all suitable stakeholders. Some notable threat reports come from [Mandiant](https://www.mandiant.com/resources), [Recorded Future](https://www.recordedfuture.com/resources/global-issues) and [AT&TCybersecurity](https://cybersecurity.att.com/).

 All the things we have discussed come together when mapping out an adversary based on threat intel. To better understand this, we will analyse a simplified engagement example. Click on the green “**View Site** ” button in this task to open the Static Site Lab and navigate through the security monitoring tool on the right panel and fill in the threat details.

Answer the questions belowWhat was the source email address?Correct AnswerWhat was the name of the file downloaded?

Correct AnswerAfter building the threat profile, what message do you receive?

Correct Answer

### **Answer the questions below**

**Question:** What was the source email address?

*Answer:* 

     vipivillain@badbank.com

**Question:** What was the name of the file downloaded?

*Answer:* 

     flbpfuh.exe

**Question:** After building the threat profile, what message do you receive?

*Answer:* 

     THM{NOW_I_CAN_CTI}

---
{% endraw %}
