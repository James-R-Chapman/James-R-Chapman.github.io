---
title:      "Hunt Me I - Payment Collectors"
date:       2025-06-17T00:00:00-04:00
tags:       ["tryhackme"]
identifier: "20250617T000000"
Hubs: "TryHackMe/SOC Level 2/Threat Hunting"
urls: (https://tryhackme.com/room/paymentcollectors)
id: b70ffb99-8c68-4dc6-a479-4ededfbc09af
---

# Hunt Me I: Payment Collectors

## Task 1 | Introduction and Scenario

Start MachineOn **Friday, September 15, 2023** , Michael Ascot, a Senior Finance Director from SwiftSpend, was checking his emails in **Outlook**  and came across an email appearing to be from Abotech Waste Management regarding a monthly invoice for their services. Michael actioned this email and downloaded the attachment to his workstation without thinking.

 ![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/6490641ea027b100564fe00a/room-content/1324483d59e28d04fbc0ec5579da6c90.png)

 The following week, Michael received another email from his contact at Abotech claiming they were recently hacked and to carefully review any attachments sent by their employees. However, the damage has already been done. Use the attached Elastic instance to hunt for malicious activity on Michael's workstation and within the SwiftSpend domain!

 Connection Details

 First, click **Start Machine**  to start the VM attached to this task. You may access the VM using the AttackBox or your VPN connection. You can start the AttackBox by pressing the **Start AttackBox**  button on the top-right of this room. **Note:**  The Elastic Stack may take up to 5 minutes to fully start up. If you receive any errors, give it a few minutes and refresh the page.

 Once online, navigate to [http://MACHINE_IP](http://machine_ip/) using a web browser.

 You should see the Elastic login page. Please log in using the following credentials:

   

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/be629720b11a294819516c1d4e738c92.png)

   **Username** elastic **Password** elastic

### **Answer the questions below**

**Question:** What was the name of the ZIP attachment that Michael downloaded?

*Answer:* 

     Invoice_AT_2023-227.zip

**Question:** What was the contained file that Michael extracted from the attachment?

*Answer:* 

     Payment_Invoice.pdf.lnk.lnk

**Question:** What was the name of the command-line process that spawned from the extracted file attachment?

*Answer:* 

     powershell.exe

**Question:** What URL did the attacker use to download a tool to establish a reverse shell connection?

*Answer:* 

     https://raw.githubusercontent.com/besimorhino/powercat/master/powercat.ps1

**Question:** What port did the workstation connect to the attacker on?

*Answer:* 

     19282

**Question:** What was the first native Windows binary the attacker ran for system enumeration after obtaining remote access?

*Answer:* 

     systeminfo.exe

**Question:** What is the URL of the script that the attacker downloads to enumerate the domain?

*Answer:* 

     https://raw.githubusercontent.com/PowerShellEmpire/PowerTools/master/PowerView/powerview.ps1

**Question:** What was the name of the file share that the attacker mapped to Michael's workstation?

*Answer:* 

     SSF-FinancialRecords

**Question:** What directory did the attacker copy the contents of the file share to?

*Answer:* 

     C:\Users\michael.ascot\downloads\exfiltration

**Question:** What was the name of the Excel file the attacker extracted from the file share?

*Answer:* 

     ClientPortfolioSummary.xlsx

**Question:** What was the name of the archive file that the attacker created to prepare for exfiltration?

*Answer:* 

     exfilt8me.zip

**Question:** What is the MITRE ID of the technique that the attacker used to exfiltrate the data?

*Answer:* 

     T1048

**Question:** What was the domain of the attacker's server that retrieved the exfiltrated data?

*Answer:* 

     haz4rdw4re.io

**Question:** The attacker exfiltrated an additional file from the victim's workstation. What is the flag you receive after reconstructing the file?

*Answer:* 

     THM{1497321f4f6f059a52dfb124fb16566e}

---

