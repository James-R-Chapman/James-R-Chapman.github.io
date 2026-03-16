---
Date: 2025-11-09
Tags: #TryHackMe
Hubs: "TryHackMe/SOC Level 1/Blue Team Introduction"
URLs: (https://tryhackme.com/room/humansattackvectors)
---

# TryHackMe | Humans as Attack Vectors

## Task 1 | Introduction

The Security Operations Center (SOC) might sound technical and impressive, but what does it really protect us from? In this room, you will dive into the methods of modern attackers and explore how they target the weakest cyber security element - humans.

 Learning Objectives 
- Learn the role of the human element in cyber security
- Understand the SOC role in detecting and mitigating attacks
- Practice the acquired knowledge in two realistic scenarios

 Prerequisites 
- Complete the [Junior Security Analyst](https://tryhackme.com/room/jrsecanalystintrouxo) room

### **Answer the questions below**

**Question:** 

*Answer:* 

     No answer needed

---

## Task 2 | The Human Element

*You're an attacker trying to break into a company. Would you rather:*

 
- *Spend days exploiting vulnerabilities and trying to bypass firewall defenses?*
- *Or just send a phishing email to the IT administrator - and get the access you need?*

 A computer network is like a fortress with towering stone walls and heavily armored gates. One way to conquer it is to breach through the gates, but another, a much simpler way - just ask the gatekeeper to open the door for you. In the cyber world, humans are often these naive "gatekeepers" - the weakest link in cyber security and those who help threat actors the most.

 ![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1753200335167.png)

 Why Humans Are Targeted Humans are targeted because of the **access** they can provide - to websites, mailboxes, or databases. Some threat actors hunt for a specific access, while others are not so selective and just breach as many accounts as they can and decide how to use them later. Here are just a few examples of what threat actors hope for when trying to breach humans:

    Attack Example Next Step of Attackers   Breach Google account of the HR manager Steal and sell the entire employee database   Trick a wealthy person into running malware Hijack a web banking session from their PC   Breach the IT administrator's VPN account Access the heart of a big corporate network   Trick a government worker into sharing secrets Use the information to simplify the next attacks

### **Answer the questions below**

**Question:** 

*Answer:* 

     Humans

**Question:** 

*Answer:* 

     Access

---

## Task 3 | Attacks on Humans

Attacks targeting humans share a common trait: they rely on manipulating the victim into helping the attacker, whether knowingly or not. This tactic is known as **social engineering** , and it works by exploiting human psychology rather than technical flaws. For the tactic to succeed, it is designed to be:

 
- **Trustworthy:** The attacker must appear legitimate so the victim trusts them
- **Emotional:**  The attack must trigger feelings like urgency, fear, or curiosity

 Phishing Attacks You receive an email saying, "*Your account has been compromised. Click here for details!* " When you click on the link, it takes you to a fake login page that looks real, but sends your credentials to the attacker. That's phishing in action. Email phishing is the most common form of social engineering, with an estimated [3.4 billion](https://aag-it.com/the-latest-phishing-statistics/#:~:text=with%20an%20estimated%203.4%20billion%20spam%20emails%20sent%20every%20day) malicious emails sent daily.

 ![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1752707092322.svg)

 Malware Downloads Ever searched for and installed the application on your PC? Well, you might have just installed [malware](https://www.esentire.com/blog/fake-deepseek-site-infects-mac-users-with-atomic-stealer#:~:text=The%20infection%20process%20begins%20when%20the%20user%20is%20redirected) on your computer. To make these attacks more successful, threat actors use innovative techniques like fake CAPTCHAs, malicious QR codes, and SEO poisoning.

 ![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1752708645490.svg)

 Deepfakes The rapid rise of AI-generated video or audio has become more effective in impersonating family members, colleagues, or corporate partners. [In one case](https://edition.cnn.com/2024/02/04/asia/deepfake-cfo-scam-hong-kong-intl-hnk), a finance worker received a deepfake video call from someone appearing to be their boss and got tricked into wiring $25 million for an "urgent business deal".

 **Impersonation**

 Even without deepfakes, the attackers are quite successful in pretending to be someone else (impersonating someone). Many [recent ransomware attacks](https://thehackernews.com/2024/12/black-basta-ransomware-evolves-with.html#:~:text=make%20initial%20contact%20with%20prospective%20targets) started with a simple phone call from attackers impersonating a corporate IT department and asking victims to take over their accounts for a quick "system repair".

 **Other Attacks**

 This task covered some popular social engineering methods, but there are many more! USB drop campaigns, physical attacks, insider threats, and even fake job offers - all of them are a constant risk to the employees, and you as a SOC analyst should be ready to respond!

### **Answer the questions below**

**Question:** 

*Answer:* 

     Social Engineering

**Question:** 

*Answer:* 

     Impersonation

---

## Task 4 | Defending Humans

Defending against threats involves two key tasks: **Mitigation** and **Detection** . Mitigation aims to prevent or reduce the chance and impact of attacks, for example by training employees or deploying a good anti-phishing solution. However, no matter how good mitigation measures are, one day they are bypassed. That's where your SOC skills are vital to detect and investigate advanced attacks that slip through:

 ![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1752782755988.svg)

 Defending Humans As a SOC analyst, your task is to **detect** and investigate attacks, and you'll have the whole [SOC Level 1](https://tryhackme.com/path/outline/soclevel1) path to learn it. However, you'll soon be tired of analyzing all the never-ending attacks and might think about how to automatically prevent common threats. This is why knowing key **mitigation** measures is essential. If your mitigation ideas are approved by IT and top management, you'll ease the SOC routine and make your company more secure! Here are a few examples of how to protect employees:

    Mitigation Description   **Anti-phishing solution**  SOC routine becomes easier with a tool that blocks phishing emails before the users even notice   **Antivirus / EDR solution**  A reliable antivirus on all corporate hosts is a great measure to prevent humans from running malware   **"Trust but verify" principle**  Instruct your employees how to detect deepfakes and verify suspicious requests from "CEO" or "IT"   **Security awareness training**  Teach your employees how to detect phishing and reinforce training through phishing simulations

### **Answer the questions below**

**Question:** 

*Answer:* 

     Mitigation

**Question:** 

*Answer:* 

     Security Awareness Training

---

## Task 5 | Practice

Every organization faces constant attacks targeting its employees. However, the role of the SOC in responding to these attacks can vary. In some teams, analysts just monitor alerts. In others, they are deeply involved in the company's processes. Analysts may:

 
- Keep tight connections with the other teams, like IT or HR
- Propose security improvements and run company-wide trainings
- Or even answer hotline calls from employees suspecting the attack

 Practice View Site For this lab, imagine yourself as a SOC analyst at TryHackMe. Open the security dashboard by clicking the **View Site**  button, protect your coworkers at **Employees at Risk** , and make TryHackMe more secure at **Security Policy**  tab. Once completed, claim the flags and answer the task questions!

 ![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1753288984482.png)

### **Answer the questions below**

**Question:** 

*Answer:* 

     THM{anyone_else_at_risk?}

**Question:** 

*Answer:* 

     THM{human_protection_expert!}

---

## Task 6 | Conclusion

In this room, you explored attacks on humans, the weakest element in cyber security. You have discovered how and why attackers target people and how you, as a SOC analyst, can detect and prevent it. But your journey shouldn't stop here. As threats evolve, staying informed about the latest attack trends is key to your success in the SOC. Here are a few great sites to follow:

 
- Krebs on Security - [https://krebsonsecurity.com](https://krebsonsecurity.com/)
- The Hacker News - [https://thehackernews.com](https://thehackernews.com/)
- BleepingComputer - [https://www.bleepingcomputer.com](https://www.bleepingcomputer.com/)

### **Answer the questions below**

**Question:** 

*Answer:* 

     No answer needed

---

