---
layout: post
title: "TryHackMe  - Windows User Account Forensics"
date: 2025-09-04
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Advanced Endpoint Investigations/Windows Endpoint Investigation"
source_id: "389dcfc5-2544-451b-8457-544182e88923"
source_urls: "(https://tryhackme.com/room/windowsuseraccountforensics)"
source_path: "Advanced Endpoint Investigations/Windows Endpoint Investigation/TryHackMe  - Windows User Account Forensics.md"
---

{% raw %}


# TryHackMe | Windows User Account Forensics

## Task 1 | Introduction

Start MachineUser accounts play a crucial role in cyber security. They are access points to sensitive systems and data, making them a focus of most cyber attacks. To help us with our investigations, we need to understand better user accounts and the forensic artefacts they leave behind.

 This room delves into Windows forensics, focusing on user account activity and system interactions. We will be examining logs, network traffic, and GPO policies. All of these create system artefacts unique to Windows that can give us a better understanding of how an attack happened.

 

 Learning Objectives 
- Identify and analyze forensic artefacts related to user and system accounts in Windows.
- Understand the forensic aspects of the user account lifecycle, including creation, modification, and deletion.
- Detect malicious activities through behavioural analysis and threat detection techniques.
- Investigate Group Policy Objects (GPOs) for security insights and potential exploitation.
- Apply forensic analysis techniques in practical scenarios to enhance investigative skills.

 Room prerequisites In order to benefit from the content in this room, it is recommended to already have knowledge covering:

 
- [Sysmon](https://tryhackme.com/room/sysmon)
- [Windows Event Logs](https://tryhackme.com/room/windowseventlogs)
- [Active Directory and Domain accounts](https://tryhackme.com/room/breachingad)
- [Wireshark and Traffic Analysis](https://tryhackme.com/room/wiresharktrafficanalysis)

 Connecting to the Machine Start the virtual machine in split-screen view by clicking on the green “Start Machine” button on the upper right section of this task. If the VM is not visible, use the blue “Show Split View” button at the top of the page. Alternatively, you can connect to the VM using the credentials below via “Remote Desktop”.

  

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/be629720b11a294819516c1d4e738c92.png)

    **Username**  Administrator   **Password**  Passw0rd!   **IP**  MACHINE_IP

### **Answer the questions below**

**Question:** I have started the machine!

*Answer:* 

     No answer needed

---

## Task 2 | Windows Account Types

This task will examine the different types of Windows user accounts, their management, and their differences. This is important, as each type of account serves specific purposes and comes with unique security risks.

 Local User Accounts Local user accounts are unique to a specific computer, offering access to its resources and applications. They are managed directly on the computer, allowing users to log in, adjust settings, and work independently without a network.

 However, the simplicity of local user accounts comes with drawbacks. This is especially true for larger organizations, where it is harder to manage accounts at scale.

    **Security Risks**  **Mitigation Strategies**      Local accounts often have weaker password requirements, making them more prone to brute-force attacks. Enforce strong password policies, including regular updates and complexity requirements.   Local accounts can be unnecessarily granted administrative rights, increasing the risk of misuse. Apply the principle of least privilege by limiting administrative rights strictly to essential users.   Lack of centralized control can lead to inconsistencies in security settings, exposing systems to vulnerabilities. Regularly audit local accounts to ensure consistent application of security settings.   Without centralized logging, monitoring local user activities is more complicated. Implement centralized logging and monitoring solutions where possible, even for local accounts.    Domain Accounts Unlike local user accounts, domain accounts are centrally managed through a domain controller. This central management allows for easier user access administration, security policies, and resource sharing. Domain users can log into any computer within the domain using the same credentials, making accessing network resources and applications easier.

 All of this makes domain accounts essential for organizations operating in networked environments.

 While more convenient, domain accounts have their security considerations:

    **Security Risks**  **Mitigation Strategies**      A compromised domain controller can provide attackers with access to all connected systems and sensitive data, enabling lateral movement and data breaches. Harden and regularly patch domain controllers to protect against exploitation.   Domain accounts are primary targets for phishing campaigns aimed at stealing credentials, exploiting their network-wide privileges. Employ multifactor authentication (MFA) to reduce reliance on passwords and limit phishing effectiveness.   Centralized management of domain accounts increases the impact of insider threats. Implement strict access control measures and maintain rigorous oversight of privileged accounts.    System and Service Accounts System and service accounts are special accounts in the Windows operating system and various apps. They automatically perform tasks and are designed to ensure software services and system processes function securely and efficiently.

 System Accounts are default accounts in the operating system, like the Local System, Network Service, and Local Service accounts. They have certain rights that allow them to interact with system resources and carry out essential system tasks.

 On the other hand, service accounts are used by apps or services to interact with the operating system. They can be set by the software (like SQL Server using a service account for its operations) or made by administrators for specific services.

 Windows systems and service accounts can still face security threats despite being designed for secure operations.

    **Security Risks**  **Mitigation Strategies**      Service accounts with too many privileges can be used to gain unauthorized access or increase permissions in the system. Regularly audit and restrict service account privileges based strictly on operational requirements.   If service accounts are not configured properly, they can give attackers or harmful software the ability to run commands, access private information, or interrupt essential services. Utilise strong, complex passwords or passphrases for service accounts, and manage credentials securely.    Managed Service Accounts (MSAs) & Virtual Accounts Managed Service Accounts (MSAs) are specialised domain accounts designed for automated password management and simplified account administration. They are used to reducing administrative overhead and enhance security by automatically rotating passwords periodically without administrative intervention.

 Virtual Accounts are local service accounts that provide simplified account management by using credentials managed by Windows internally. These accounts eliminate the necessity for administrators to manage passwords explicitly and offer a secure way to run services with minimal privilege.

 Despite their secure nature, these accounts also face security risks.

    **Security Risks**  **Mitigation Strategies**      The accounts may be granted overly broad permissions, which can lead to the exploitation of the privileges Establishing clear security guidelines on assignment of roles and permissions.   Password management and internal credential handling properties make the accounts less visible to standard monitoring tools. Integration into centralised logging and continuous monitoring frameworks can be used to detect unusual behaviours.   The reliance on automated password rotation can create a single point of failure. Implementation of disaster recovery and redundancy plans for services that rely on MSAs or virtual accounts is crucial.

### **Answer the questions below**

**Question:** What type of accounts are used by the Windows operating system and various apps?

*Answer:* 

     System and Service Accounts

**Question:** What centrally manages local user accounts and domain accounts?

*Answer:* 

     Domain Controller

---

## Task 3 | Account Lifecycle Artefacts

Windows logs user-related events like creating, modifying, or deleting an account. These events also include user and administrator actions and possible malicious activities of potential intruders.

 In this task, we'll look at the artefacts created related to the lifecycle of user accounts, where to find them, and what they reveal about account-related actions. Understanding this data helps identify unauthorized account use, monitor account privilege changes, and detect attempts to hide malicious activities.

 Account Lifecycle The lifecycle of Windows user accounts generates a wealth of forensic information. Each stage offers distinct insights into user account management and potential security threats:

 **Account Creation**

 Creating new user accounts can either serve legitimate needs such as onboarding new employees and providing temporary contractor access, or be a way for attackers to infiltrate a system. Logged events detail the account's origin, creator's identity, timestamp, and initial account settings.

 The relevant Event IDs to take note of during this phase include:

 
- **Event ID 4720 -**  Denotes a user account was created
- **Event ID 4722 -**  Denotes a user account was enabled

 **Account Modification**

 This consist of changes made to accounts, such as password updates, privilege changes, or attribute alterations, which typically reflect routine administrative tasks. Unauthorised modifications may indicate attempts at privilege escalation or credential compromise. Therefore, forensic examination of these modification records is important.

 The relevant Event IDs to take note of during this phase include:

 
- **Event ID 4738 -**  Denotes a user account was modified
- **Event ID 4740 -**  Denotes a user account was locked due to repeated failed login attempts

 **Account Deletion**

 Deleting user accounts can be expected after an employee leaves an organisation. However, it can also signify an attacker trying to cover their tracks following malicious activities. Event logs document details about when and by whom accounts are removed.

 The relevant Event ID to take note of during this phase is:

 
- **Event ID 4726 -**  Denotes an account was deleted, documenting when and by whom an account was removed from the system

 User Artefacts in Windows Event Logs The primary source of forensic artefacts for accounts is the Windows Security Event Log. This can be accessed by searching for "Event Viewer" from the Windows search bar. The details of user account artefacts can be found under the folder `Windows Logs -> Security`

 The information found when analysing event logs includes:

 
- Names and domains of affected accounts
- Unique Security Identifiers (SIDs)
- Users or processes initiating the events
- Timestamps for each event.

 These events are logged on individual Windows systems for local accounts and domain controllers for domain accounts.

 ![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/3ef03973fecd9139d6c1c87dab06d461.png)

 User Artefacts in the Security Account Manager (SAM) The Security Account Manager (SAM) is a Windows database that stores the user's local account and system account info. It holds critical forensic data about account activities such as creation, alteration, and deletion. The SAM file, located at **`%SystemRoot%\\system32\\config\\SAM`** , is locked while Windows runs but can be accessed and examined from offline systems or forensic backups.

 The SAM provides the following forensic data:

 
- The account names of local users and associated unique identifiers for each user
- Group memberships and stored hashed representations of user passwords (not in plaintext)
- Status indicators showing if accounts are active, disabled, or expired
- Records of last login timestamps

 User Artefacts in the NT Directory Services Database (NTDS.dit) The NT Directory Services (NTDS) database, or NTDS.dit, stores detailed information about domain user accounts, groups, and other directory service data within a networked domain environment.

 The NTDS can provide the following information:

 
- Usernames and full names of domain users
- Security Identifiers (SIDs) for each user
- Detailed group memberships, including global, domain local, and universal groups
- Hashed representations of user passwords for domain accounts
- Account activation, disablement, and expiration status
- Login timestamps and failed login attempts
- Password last set and password expiration times
- Other domain objects like computers, groups, organizational units (OUs), and security policies
- Trust relationships with other domains

 Forensic examination of SAM and NTDS.dit files is crucial as they help identify unauthorized access, assess password security, and track user behaviour, which is essential for investigating security incidents and enhancing system security.

 Analyzing the NTDS.dit for User-Related Artefacts To analyze the user-related data of a domain controller, the NTDS.dit file can be exported and examined using the DSInternals PowerShell module, a powerful tool designed for interacting with Active Directory databases and related components in a forensic context.

 To start, open the VM and launch Powershell in Administrator mode.

 We first need to export the NTDS.dit file along with the SYSTEM hive. Enter the following command:

   PowerShell: Administrator Mode 
```PowerShell: Administrator Mode 
C:\> ntdsutil.exe "activate instance ntds" "ifm" "create full C:\Exports" quit quit
```

   Let's break down the command:

 
- **ntdsutil.exe -**  The command-line tool for Active Directory database management.
- **"activate instance ntds"** - Explicitly stating that the 'ntds' instance should be activated. This typically specifies which Active Directory database instance you want to work with.
- **"ifm"**  - Create a full installation media set and store it in the C:\Exports\ directory. The full option indicates that the system state data and the NTDS database will be included.
- **quit quit**  - These are two quit commands issued in succession. The first quit tells ntdsutil to exit the current context (in this case, the ifm context), and the second quit exits the utility itself. It's a way to exit the tool cleanly after executing the necessary commands.

 The SYSTEM hive contains the system's boot key, essential for decrypting specific data within the NTDS.dit file. Without the boot key from the SYSTEM hive, the security-related information within NTDS.dit, such as password hashes, remains encrypted and inaccessible, limiting the depth of forensic analysis that can be conducted on user account data and other domain-related information.

 **Note:**  *Once you have these exported files, you'll usually take them to your forensic analysis machine for analysis. But, for this exercise, we'll also be doing the analysis in this same VM.*

 In this exercise, we will be using the DSInternals PowerShell module. It is a suite of PowerShell cmdlets and utilities designed to work with Active Directory databases, particularly for forensic and security purposes. Also,  the NTDS.dit file, along with the SYSTEM hive, has already been exported for analysis to the `C:\Exports` directory.

 The command in DSInternals to extract the boot key is as follows:

   PowerShell: Administrator Mode 
```PowerShell: Administrator Mode 
C:\> $bootKey = Get-BootKey -SystemHivePath 'C:\Exports\registry\SYSTEM'
```

   What the command does is that it calls the `Get-BootKey` cmdlet from the DSInternals PowerShell module to extract the boot key from the specified SYSTEM hive, and then saves it to the `$bootKey` variable.

 To fetch the account details, we then call the `Get-ADDBAccount` cmdlet, passing the path to the NTDS.dit and the boot key:

   PowerShell: Administrator Mode 
```PowerShell: Administrator Mode 
C:\> Get-ADDBAccount -All -DBPath 'C:\Exports\Active Directory\NTDS.dit' -BootKey $bootKey
```

   Here is a short snippet of what the output would look like:

   PowerShell: Administrator Mode 
```PowerShell: Administrator Mode 
...
DistinguishedName: CN=Michael Ascot,CN=Users,DC=tryhatme,DC=com
Sid: S-1-5-**-**********-**********-********-**** Guid: 4ccc32f2-6695-43b8-8d9e-bb11b2e3bbc6
SamAccountName: m.ascot
SamAccountType: User
UserPrincipalName: m.ascot@tryhatme.com
PrimaryGroupId: 513
SidHistory:
Enabled: True
UserAccountControl: NormalAccount, PasswordNeverExpires
SupportedEncryptionTypes:
AdminCount: False
Deleted: False
LastLogonDate: 2/28/2024 6:45:20 PM
DisplayName: Michael Ascot
GivenName: Michael
Surname: Ascot
...
```

### **Answer the questions below**

**Question:** How many users were found using the DSInternals command?

*Answer:* 

     5

**Question:** What is the value of the "bootKey" variable?

*Answer:* 

     36c8d26ec0df8b23ce63bcefa6e2d821

**Question:** What is the SID of the domain user, m.ascot?

*Answer:* 

     S-1-5-21-1966530601-3185510712-10604624-1111

---

## Task 4 | Account Authentication Artefacts

Authentication is an essential security mechanism in network environments for verifying user or entity identities before granting access to resources. It ensures that only authorized users or systems can access specific data or services.

Protocols like Kerberos and NTLM are commonly used in Windows environments. These are designed to prove an entity's identity without transmitting sensitive information, like passwords, in plaintext over the network using encryption.

Authentication processes generate a lot of logs and forensic data, which we will explore below.

User Artefacts in Authentication Protocols

 Each authentication attempt, whether successful or not, generates specific event logs that are stored in the logs of domain controllers. These can be viewed using the Windows Event Log Viewer.

![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/40a97bafe4a5998b92021893c591d69d.png)

 Here are specific key Event IDs that you may want to look into:

 
- **Event ID 4624 -**  An account was successfully logged on.
- **Event ID 4625 -**  An account failed to log on.
- **Event ID 4768 -**  A Kerberos authentication ticket (TGT) was requested.
- **Event ID 4771 -**  Kerberos pre-authentication failed.

While these Event IDs alone do not confirm malicious activity, they are critical for further investigation and correlation with other security events.

For example, a series of failed logins (Event ID 4625) followed by a successful login (Event ID 4624) could suggest a brute-force attack. Similarly, unusual spikes in Kerberos ticket requests (Event ID 4768) might warrant a deeper look to ensure they align with legitimate user activities.

User Artefacts via Network Traffic Analysis

 Given that authentication involves network communication, it is only natural that we can also get forensic evidence by analyzing network traffic.

Artefacts from network traffic analysis include:

 
- IP Addresses and Hostnames: These identify who's involved in authentication, tracing request origin, and target.
- Authentication Protocols: These provide insights into used authentication mechanisms like Kerberos or NTLM, including fields that show the authentication type and security implications.
- Timestamps: Each packet's timestamp helps establish the sequence of events and the timing of authentication attempts.
- Success and Failure Indicators: Codes and messages in network packets state the outcome of authentication attempts, distinguishing between successful and failed attempts.
- Payload Data: Though usually encrypted, payload data can sometimes provide extra context about the request, particularly in unsecured transmissions.

It is important to note that inspecting authentication traffic does NOT reveal an attack like 'Pass the Hash' or 'Kerberoasting'. Whether malicious or not, these requests will look like normal traffic. Despite this, the artefacts gathered here will still be helpful when combined with other forensic data.

 Analyzing Network Traffic for Authentication Artefacts This next exercise will examine a captured *.pcap*  file sample from the[ official Wireshark website](https://wiki.wireshark.org/SampleCaptures#ntlmssp) to analyze an NTLM authentication event.

Go back to the VM and launch Wireshark using the desktop icon.

Navigate to **`File > Open`**  in Wireshark and select the pre-captured file under `C:\Captures\ntlm.pcapng` provided for this exercise.

![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/2610d90cc19b3d7728eaf28c0fc09369.png)

This capture shows a sequence of packets related to a Remote Procedure Call (RPC) using NTLM authentication.

NTLM authentication relies on a 3-way handshake:

1. The first stage of this handshake is **Negotiation,**  which can be seen in Frame 11
2. The second stage is the **Challenge**  in Frame 12
3. The third stage is **Authentication,**  which can be seen in frame No. 13.

Navigating through the information pane on the lower left, we can see information like the source IP, destination IP, domain name, user name, hostnames, and the challenge and response strings to prove the client's identity.

![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/40fe6cd85f9d0f8ad64b675495261d7e.png)

We can investigate other NTLM traffic, but because these are typically encrypted, we'd need to tell Wireshark to decrypt the traffic by specifying the user's NT Password.

For this exercise, let's say we already know the user's password, "admin".

On the main taskbar of Wireshark, click on `Edit > Preferences`. On the left sidebar of the Preferences window, navigate to `Protocols > NTLMSSP`, and then specify "admin" in the NT Password field. Press OK.

Now, all NTLMSSP-related traffic of the user will be decrypted using the password we've provided.

If you look at the contents of Frame 13 again, you will see that there is now more information. Like the block highlighted in the screenshot below:

![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/128066968a9bd5256f64dea91cb05426.png)

Another example is in Frame 18, which is a DsGetDomainControllerInfo response. Here is what it looked like before the password was provided:

![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/41f877b9b6307dd862b76afb61b0ee19.png)

 Here is after the password was provided:

![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/1aa381a1947ff07dcc8b99ecd587336a.png)

This is, of course, just an example of one authentication method. Other authentication methods would require a different approach, but hopefully, this gives you an idea of how to approach it.

### **Answer the questions below**

**Question:** What is the user name used for the NTLM authentication?

*Answer:* 

     admin

**Question:** What was the Server Challenge sent to the client during the Challenge stage of the NTLM handshake?

*Answer:* 

     212ba239356b3d82

**Question:** What is the Dns Name of the other result from the the DsGetDomainControllerInfo response?

*Answer:* 

     dcfr.lab.lan

---

## Task 5 | Group Policy Artefacts

Group Policy Objects (GPOs) manage settings for users and computers within a network domain. Their extensive reach and control over network resources have made them an attractive target. Forensic investigators need to understand how attackers exploit GPOs and utilise the artefacts left to uncover security incidents and prevent future attacks.

 GPO Attack Scenarios There are a lot of scenarios in which threat actors can exploit GPOs. Here are some of the common ones with their associated forensic artefacts:

 
- **Privilege Escalation:**  An adversary modifies a GPO to alter user rights or group memberships, granting themselves elevated privileges across the network.
- **Persistence and Lateral Movement:**  Attackers embed malicious scripts or deploy malware or tools through GPO login scripts that allow for maintenance of persistent access to a system or facilitate lateral movement within a network.
- **Security Policy Modification:**  Tampering with GPOs to weaken security settings, such as disabling firewall rules, antivirus software, or other security controls, making systems more vulnerable to attacks.
- **Reconnaissance:**  Attackers can embed scripts in GPOs that execute malicious activities, such as reconnaissance scripts that gather sensitive network information, aiding future targeted attacks.

 User Artefacts in Group Policies When Group Policy Object policies are changed or exploited, specific artefacts are left behind that can help analysts detect unauthorized changes, evaluate the security state, and comprehend policy execution.

 Essential GPO enforcement artefacts include:

 
- **Custom User Settings:**  Direct modifications to user-specific settings, such as desktop configurations, startup programs, and security configurations, leave traces in **`HKEY_CURRENT_USER`**  registry keys and within user profile directories.
- **Login Scripts:**  GPOs can dictate scripts to execute when a user logs in. These actions generate artefacts, including script files in the **`SYSVOL`**  folder and execution logs within user profiles, found under the **`User Configuration`**  settings of a GPO.
- **User Rights Assignments:**  Unauthorized alterations in user rights and permissions generate detectable changes within the **`Security`**  database at **`%SystemRoot%\security\database\secedit.sdb`** , offering insights into access control adjustments.
- **Security Policy Changes:**  System-wide modifications to security policies by GPOs are recorded in the registry under **`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies`** , reflected in the **`Local Security Policy`** .
- **System Services Configurations:**  System service adjustments, including startup type and permissions changes, are documented within the **`System`**  registry hive under **`HKEY_LOCAL_MACHINE\SYSTEM`** .
- **Network Configuration Adjustments:**  GPO-driven changes to network configurations manifest as modified registry settings in **`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList`**  and alterations in configuration files located in **`%SystemRoot%\System32\drivers\etc`** .

 Analyzing GPO Policies for Artefacts Return to the VM and open the Group Policy Management Console (GPMC) by clicking on the Start menu and typing **`Group Policy Management`**  into the search box.

 In the console tree on the left of the window, expand and navigate to the **`Forest: tryhatme.com > Domains > tryhatme.com > Group Policy Objects`**  folder to see a list of all GPOs. You'll see one Policy that stands out, which is "Super Important Policy". This does not seem to follow the company's naming convention, so it's worth investigating.

 ![Image 9](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/4afee1bd8c27cde223fd9f67e66447ed.png)

 We can see in the screenshot above that this Policy would apply to all authenticated users, more specifically, to the Administrator account.

 To see the current configurations of this Policy, right-click on "Super Important Policy" and click "Edit".

 In this exercise, changes have been made to specific policy configurations. Usually, we have to look for these changes ourselves, but in the interest of time, we'll just be guiding you on where to look.

 The first one is under `Computer Configuration > Policies > Administrative Templates > Network > Network Connections > Windows Defender Firewall > Domain Profile`. We can see that the setting for protecting network connections is set to "Disabled".

 ![Image 10](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/31d3bda109bcfa69c53d70a3eee644f8.png)

 This is, of course, a problem as this will effectively disable the Windows firewall for all machines, making it easier for threat actors to do lateral movement.

 Another configuration worth checking out is under `User Configuration > Policies > Windows Settings > Scripts (Logon/Logoff)`. Double-click on "Logon" and click on the "PowerShell Scripts" tab.

 ![Image 11](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/dd856223ed68520a2b099593078a1ba6.png)

 This Policy will run a PowerShell script as soon as the targeted users log on to a machine via their domain account. You can imagine what sort of damage can be done with this capability.

 To view the script, click the "Show Files" button at the bottom of the pop-up window. This will open the directory location of the current script. Open this script to see what it does.

 To answer the questions below, check out the configurations for the "**Default Domain Policy** ".

### **Answer the questions below**

**Question:** What is the name of the user specified as the apply target for this Policy?

*Answer:* 

     Michael Ascot

**Question:** Under Computer Configuration > Policies > Administrative Templates > Windows Components > Windows Defender Antivirus > Real-time Protection, what is the setting that was enabled?

*Answer:* 

     Turn off real-time protection

**Question:** There is an updated malicious startup PowerShell script. What is the filename of this script? (Without file extension)

*Answer:* 

     superimportant-updated

**Question:** What is the IP address of the C2 server the script would exfiltrate to?

*Answer:* 

     192.0.2.123

---

## Task 6 | Conclusion

Throughout this room, we examined the various artefacts generated from attacks targeting user accounts. This is by no means an exhaustive coverage as there are other places to look for within a Windows environment. We still hope that we were able to give you the basic knowledge of where to look for your investigations.

 If you’re interested in delving deeper and exploring more topics related to this, we recommend that you check out the [Windows Application Forensics](https://tryhackme.com/room/windowsapplications) room from the Incident Response module.

### **Answer the questions below**

**Question:** Users beware!

*Answer:* 

     No answer needed

---
{% endraw %}
