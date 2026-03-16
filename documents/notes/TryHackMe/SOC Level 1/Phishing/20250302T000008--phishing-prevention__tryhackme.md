---
title:      "Phishing Prevention"
date:       2025-03-02T00:00:00-05:00
tags:       ["tryhackme"]
identifier: "20250302T000008"
Hubs: "TryHackMe/SOC Level 1/Phishing"
urls: (https://tryhackme.com/room/phishingemails4gkxh)
id: cc035739-4ec4-4c53-a14e-6baab1952326
---

# Phishing Prevention

# Task 1 | Introduction

There are various actions a defender can take to help protect the users from falling victim to a malicious email.

Some examples of these actions are listed below:

- Email Security (SPF, DKIM, DMARC)
- SPAM Filters (flags or blocks incoming emails based on reputation)
- Email Labels (alert users that an incoming email is from an outside source)
- Email Address/Domain/URL Blocking (based on reputation or explicit denylist)
- Attachment Blocking (based on the extension of the attachment)
- Attachment Sandboxing (detonating email attachments in a sandbox environment to detect malicious activity)
- Security Awareness Training (internal phishing campaigns)

Per **MITRE ATT&CK**  **Framework** , [Phishing for Information](https://attack.mitre.org/techniques/T1598#mitigations) is described as an attempt to trick targets into divulging information, and contains three sub-techniques.

Visit the above link, and look at the **Mitigation**  section under **Software Configuration** .

 ![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/6490641ea027b100564fe00a/room-content/c5c01c4c241614db982bf15299dedae3.png)

 In this room, we will focus specifically on Email Security (SPF, DKIM, DMARC) from the actions noted above.

Let's begin!

### **Answer the questions below**

**Question:** After visiting the link in the task, what is the MITRE ID for the "Software Configuration" mitigation technique?

*Answer:* 

     M1054

---

# Task 2 | SPF (Sender Policy Framework)

What is the **Sender Policy Framework**  (**SPF** )?

Per [dmarcian](https://dmarcian.com/what-is-spf/), "*Sender Policy Framework (SPF) is used to authenticate the sender of an email. With an SPF record in place, Internet Service Providers can verify that a mail server is authorized to send email for a specific domain. An SPF record is a DNS TXT record containing a list of the IP addresses that are allowed to send email on behalf of your domain.* "

Below is a visual workflow for SPF.

![Image 2](https://assets.tryhackme.com/additional/phishing4/dmarcian-spf.png)

**Note:**  Credit to dmarcian for the above image.

How does a basic SPF record look like?

`v=spf1 ip4:127.0.0.1 include:_spf.google.com -all`

An explanation for the above record:

- `v=spf1`****  -> This is the start of the SPF record
- `ip4:127.0.0.1`****  -> This specifies which IP (in this case version IP4 & not IP6) can send mail
- `include:_spf.google.com`****  -> This specifies which domain can send mail
- `-all`****  -> non-authorized emails will be rejected

Refer to the SPF Record Syntax on dmarcian [here](https://dmarcian.com/spf-syntax-table/) and [here](https://dmarcian.com/what-is-the-difference-between-spf-all-and-all/).

Let's look at Twitter's SPF record using dmarcian's SPF Surveyor [tool](https://dmarcian.com/spf-survey/).

![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/5de58e2bfac4a912bcc7a3e9/room-content/66c0270a75718fd985664b223e549cde.png)

Refer to this resource on [dmarcian](https://dmarcian.com/create-spf-record/) on how to create your own SPF records.

Let's look at another sample.

The image below is from [Google Admin Toolbox Messageheader](https://toolbox.googleapps.com/apps/messageheader/), which was used to analyze a malicious email.

![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/5de58e2bfac4a912bcc7a3e9/room-content/5d9bea5f9fd4e1409d4cb28bfdfea94e.png)

The above image shows the status of an SPF record check. It reports back as **softfail** .

**Note** : Even though this task uses [dmarcian](https://dmarcian.com/) for SPF-related information and online checks, many other companies do the same.

### **Answer the questions below**

**Question:** Referencing the dmarcian SPF syntax table, what prefix character can be added to the "all" mechanism to ensure a "softfail" result?

*Answer:* 

     ~

**Question:** What is the meaning of the -all tag?

*Answer:* 

     fail

---

# Task 3 | DKIM (DomainKeys Identified Mail)

What is **DKIM** ?

Per [dmarcian](https://dmarcian.com/what-is-dkim/), "*DKIM stands for DomainKeys Identified Mail and is used for the authentication of an email that’s being sent. Like SPF, DKIM is an open standard for email authentication that is used for DMARC alignment. A DKIM record exists in the DNS, but it is a bit more complicated than SPF. DKIM’s advantage is that it can survive forwarding, which makes it superior to SPF and a foundation for securing your email.* "

How does a DKIM record look like?

`v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxTQIC7vZAHHZ7WVv/5x/qH1RAgMQI+y6Xtsn73rWOgeBQjHKbmIEIlgrebyWWFCXjmzIP0NYJrGehenmPWK5bF/TRDstbM8uVQCUWpoRAHzuhIxPSYW6k/w2+HdCECF2gnGmmw1cT6nHjfCyKGsM0On0HDvxP8I5YQIIlzNigP32n1hVnQP+UuInj0wLIdOBIWkHdnFewzGK2+qjF2wmEjx+vqHDnxdUTay5DfTGaqgA9AKjgXNjLEbKlEWvy0tj7UzQRHd24a5+2x/R4Pc7PF/y6OxAwYBZnEPO0sJwio4uqL9CYZcvaHGCLOIMwQmNTPMKGC9nt3PSjujfHUBX3wIDAQAB`

An explanation of the above record:

- `v=DKIM1`**** -> This is the version of the DKIM record. This is optional.
- `k=rsa`****  -> This is the key type. The default value is RSA. RSA is an encryption algorithm (cryptosystem).
- `p=`****  -> This is the public key that will be matched to the private key, which was created during the DKIM setup process.

Refer to the DKIM resource [here](https://dmarcian.com/dkim-selectors/) and [here](https://help.returnpath.com/hc/en-us/articles/222481088-DKIM-DNS-record-overview) for additional information.

The below image is a snippet of an email header for an email flagged as spam that contained a potentially malicious attachment.

![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/5de58e2bfac4a912bcc7a3e9/room-content/334dbef5ba955a23b7e84629b85eb26a.png)

### **Answer the questions below**

**Question:** Which email header shows the status of whether DKIM passed or failed?

*Answer:* 

     Authentication-Results

---

# Task 4 | DMARC (Domain-Based Message Authentication, Reporting, and Conformance)

What is **DMARC** ?

Per [dmarcian](https://dmarcian.com/start-dmarc/), "*DMARC, (Domain-based Message Authentication Reporting, & Conformance) an open source standard, uses a concept called alignment to tie the result of two other open source standards, SPF (a published list of servers that are authorized to send email on behalf of a domain) and DKIM (a tamper-evident domain seal associated with a piece of email), to the content of an email. If not already deployed, putting a DMARC record into place for your domain will give you feedback that will allow you to troubleshoot your SPF and DKIM configurations if needed.* "

How does a basic DMARC record look like?

`v=DMARC1; p=quarantine; rua=mailto:postmaster@website.com `

An explanation of the above record:

- `v=DMARC1`****  -> Must be in all caps, and it's not optional
- `p=quarantine`****  -> If a check fails, then an email will be sent to the spam folder (DMARC Policy)
- `rua=mailto:postmaster@website.com`****  -> Aggregate reports will be sent to this email address

Refer to the DMARC resources [here](https://dmarcian.com/dmarc-record/) and [here](https://dmarc.org/overview/) for additional information on DMARC tags. Review the following resource about DMARC [Alignment](https://dmarcian.com/alignment/).

Let's use the **Domain Health Checker**  from [dmarcian.com](https://dmarcian.com/domain-checker/) and check the DMARC status of **microsoft.com** .

![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/5de58e2bfac4a912bcc7a3e9/room-content/9b94a157faf86848b26093efb30c2126.png)

And the results are...

![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/5de58e2bfac4a912bcc7a3e9/room-content/72bc9ea8efe179361c958a951f9db9fb.png)

Microsoft passed all checks. We can drill down into **DMARC** , **SPF** , or **DKIM**  to get more details.

**DMARC** :

![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/5de58e2bfac4a912bcc7a3e9/room-content/d0b2fc15e23d1466ff98efc98afef61e.png)

In the details above, we can see that all emails that fail the DMARC check will be rejected.

### **Answer the questions below**

**Question:** Which DMARC policy would you use not to accept an email if the message fails the DMARC check?

*Answer:* 

     p=reject

---

# Task 5 | S/MIME (Secure/Multipurpose Internet Mail Extensions)

What is **[S/MIME](https://docs.microsoft.com/en-us/exchange/security-and-compliance/smime-exo/smime-exo)** ?

Per Microsoft, "*S/MIME (Secure/Multipurpose internet Mail Extensions) is a widely accepted protocol for sending digitally signed and encrypted messages* ."

As you can tell from the definition above, the 2 main ingredients for S/MIME are:

1. **Digital Signatures**
2. **Encryption**

Using [Public Key Cryptography](https://www.ibm.com/docs/en/ztpf/2023?topic=concepts-public-key-cryptography), S/MIME guarantees data integrity and nonrepudiation.

- If Bob wishes to use S/MIME, then he'll need a digital certificate. This digital certificate will contain his public key.
- With this digital certificate, Bob can "sign" the email message with his private key.
- Mary can then decrypt Bob's message with Bob's public key.
- Mary will do the same (send her certificate to Bob) when she replies to his email, and Bob complete the same process on his end.
- Both will now have each other's certificates for future correspondence.

The illustration below will help you understand how public key cryptography works.

![Image 9](https://tryhackme-images.s3.amazonaws.com/user-uploads/5c549500924ec576f953d9fc/room-content/27cb0b439d172324f453e57c9cbf7ac0.png)

Refer to this Microsoft documentation [here](https://docs.microsoft.com/en-us/exchange/security-and-compliance/smime-exo/smime-exo) for more information on S/MIME and steps on how to configure Office 365 to send/receive S/MIME emails.

### **Answer the questions below**

**Question:** What is nonrepudiation? (The answer is a full sentence, including the ".")

*Answer:* 

     The uniqueness of a signature prevents the owner of the signature from disowning the signature.

---

# Task 6 | SMTP Status Codes

Start MachineDeploy the machine attached to this task; it will be visible in the split-screen view once it is ready.

If you don't see a virtual machine load then click the Show Split View button.

![Image 10](https://assets.tryhackme.com/additional/phishing4/p4-split-view.png)

In this task, you'll examine a PCAP file with SMTP traffic. You'll only focus on SMTP codes in this task.

You must be familiar with [Wireshark](https://tryhackme.com/room/wireshark) and packet analysis to answer the questions below.

Here are two resources to assist you with this task:

- [https://www.wireshark.org/docs/dfref/s/smtp.html](https://www.wireshark.org/docs/dfref/s/smtp.html)
- [https://www.mailersend.com/blog/smtp-codes](https://www.mailersend.com/blog/smtp-codes)

### **Answer the questions below**

**Question:** What Wireshark filter can you use to narrow down the packet output using SMTP status codes?

*Answer:* 

     smtp.response.code

**Question:** Per the network traffic, what was the message for status code 220? (Do not include the status code (220) in the answer)

*Answer:* 

     [domain] Service ready

**Question:** One packet shows a response that an email was blocked using spamhaus.org. What were the packet number and status code? (no spaces in your answer)

*Answer:* 

     156,553

**Question:** Based on the packet from the previous question, what was the message regarding the mailbox?

*Answer:* 

     mailbox name not allowed

**Question:** What is the status code that will typically precede a SMTP DATA command?

*Answer:* 

     354

---

# Task 7 | SMTP Traffic Analysis

In this task, you'll move beyond SMTP codes and analyze trivial SMTP traffic.

The reference below may assist you with this task:

- [https://www.wireshark.org/docs/dfref/i/imf.html](https://www.wireshark.org/docs/dfref/i/imf.html)

### **Answer the questions below**

**Question:** What port is the SMTP traffic using?

*Answer:* 

     25

**Question:** How many packets are specifically SMTP?

*Answer:* 

     512

**Question:** What is the source IP address for all the SMTP traffic?

*Answer:* 

     10.12.19.101

**Question:** What is the filename of the third file attachment?

*Answer:* 

     attachment.scr

**Question:** How about the last file attachment?

*Answer:* 

      .zip

---

# Task 8 | SMTP and C&C Communication

Now we'll take a look at how SMTP has been abused by adversaries for C2 (Command and Control) communications.

**MITRE ATT&CK** :

- **Techinique 1071 > Sub-Technique 3** : [https://attack.mitre.org/techniques/T1071/003/](https://attack.mitre.org/techniques/T1071/003/)[](https://attack.mitre.org/techniques/T1071/003/)

Per MITRE, "*Adversaries may communicate using application layer protocols associated with electronic mail delivery to avoid detection/network filtering by blending in with existing traffic. Commands to the remote system, and often the results of those commands, will be embedded within the protocol traffic between the client and server.* "

Several notable groups, such as **APT 28** , **APT 32** , and **Turla** , to name a few, have used this technique.

**Recommended mitigation (per MITRE)** :

"*Network intrusion detection and prevention systems that use network signatures to identify traffic for specific adversary malware can be used to mitigate activity at the network level.* "

**Detection opportunity (per MITRE)** :

"*Analyze packet contents to detect application layer protocols that do not follow the expected protocol standards regarding syntax, structure, or any other variable adversaries could leverage to conceal data.* "

**Note** : We will cover Network Intrusion Prevention and Detection in future rooms.

### **Answer the questions below**

**Question:** Per MITRE ATT&CK, which software is associated with using SMTP and POP3 for C2 communications?

*Answer:* 

     Zebrocy

---

# Task 9 | Conclusion

We'll wrap up this room by sharing a phishing incident response playbook. This playbook will give you an idea of what steps should be considered and executed given this scenario.

A **playbook**  is a defined process that should be followed in a specific situation, in this case, a phishing incident.

Phishing IR Playbook:

- [https://github.com/counteractive/incident-response-plan-template/blob/master/playbooks/playbook-phishing.md](https://github.com/counteractive/incident-response-plan-template/blob/master/playbooks/playbook-phishing.md) 
[](https://www.incidentresponse.com/playbooks/phishing)

Lastly, the PCAP file used in this room was from **Malware Traffic Analysis** . You can explore more details about this PCAP or other samples.

SMTP PCAP Credit:

- [https://www.malware-traffic-analysis.net/2018/12/19/index.html](https://www.malware-traffic-analysis.net/2018/12/19/index.html)

### **Answer the questions below**

**Question:** Click and continue learning!

*Answer:* 

     No answer needed

---

