---
layout: post
title: "Offensive Security Intro"
date: 2025-02-05
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Cyber Security 101/Start Your Cyber Security Journey"
identifier: "20250205T211406"
source_id: "e9fff937-66cd-4321-8dbd-1c5cfac91b3e"
source_path: "Cyber Security 101/Start Your Cyber Security Journey/20250205T211406--offensive-security-intro__tryhackme.md"
---

{% raw %}


### Cyber Security 101 > Start Your Cyber Security Journey > Offensive Security Intro

### [TryHackMe | Offensive Security Intro](https://tryhackme.com/r/room/offensivesecurityintro)

## What is Offensive Security?

"To outsmart a hacker, you need to think like one."

 This is the core of "Offensive Security." It involves breaking into computer systems, exploiting software bugs, and finding loopholes in applications to gain unauthorized access. The goal is to understand hacker tactics and enhance our system defences.

 Beginning Your Learning Journey

 In this TryHackMe room, you will be guided through hacking your first website in a legal and safe environment. The goal is to show you how an ethical hacker operates.

 But before we do that, let's review by answering the questions below. Type your answer in the text box after the question and click the "Submit" button. When you're done, proceed to Task 2.

### **Answer the questions below**

---

## Hacking your first machine

Here at TryHackMe, we use Virtual Machines to create simulated environments that serve as practical complements to rooms.

In this room, we have prepared a fake bank application called Fakebank that you can safely hack. To start this machine, click on the **Start Machine**  button below.

 Start Machine Your screen should be split in half, showing this content on the left and the newly launched machine on the right. If you hide it later, you can always click on the **Show Split View**  button at the top to display it again. You should see a browser window showing the website below:

 ![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/63588b5ef586912c7d03c4f0-1716285774320)

 If you don't see the one shown above, use the **"Show Split View"**  button at the top of this page.

  Stuck? See image  

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/63588b5ef586912c7d03c4f0-1718704003145)

 
  
 Your First Hack We will use a command-line application called "[Gobuster](https://github.com/OJ/gobuster)" to brute-force FakeBank's website to find hidden directories and pages. Gobuster will take a list of potential page or directory names and try accessing a website with each of them; if the page exists, it tells you.

**Step 1. Open A Terminal**

A terminal, also known as the command line, allows us to interact with a computer without using a graphical user interface. On the machine, open the terminal by clicking on the Terminal icon 

![Image 3]()

on the right of the screen.

![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/63588b5ef586912c7d03c4f0-1716285683968)

**Step 2. Use Gobuster To Find Hidden Website Pages**

Most companies have an admin portal page, giving their staff access to basic admin controls for day-to-day operations. For a bank, an employee might need to transfer money to and from client accounts. Due to human error or negligence, there may be instances when these pages are not made private, allowing attackers to find hidden pages that show or give access to admin controls or sensitive data.

To begin, type the following command into the terminal to find potentially hidden pages on FakeBank's website using Gobuster (a command-line security application).

 ```
gobuster -u http://fakebank.thm -w wordlist.txt dir
```

 The command will run and show you an output similar to this:

    Gobuster command to brute-force website pages  ```
           ubuntu@tryhackme:~/Desktop$ gobuster -u http://fakebank.thm -w wordlist.txt dir

=====================================================
Gobuster v2.0.1              OJ Reeves (@TheColonial)
=====================================================
[+] Mode         : dir
[+] Url/Domain   : http://fakebank.thm/
[+] Threads      : 10
[+] Wordlist     : wordlist.txt
[+] Status codes : 200,204,301,302,307,403
[+] Timeout      : 10s
=====================================================
2024/05/21 10:04:38 Starting gobuster
=====================================================
/images (Status: 301)
/bank-transfer (Status: 200)
=====================================================
2024/05/21 10:04:44 Finished
=====================================================

        
```

   In the command above, `-u` is used to state the website we're scanning, `-w` takes a list of words to iterate through to find hidden pages.

You will see that Gobuster scans the website with each word in the list, finding pages that exist on the site. Gobuster will have told you the pages in the list of page/directory names (indicated by Status: 200).

![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/63588b5ef586912c7d03c4f0-1716286052350)

**Step 3. Hack The Bank**

You should have found a secret bank transfer page that allows you to transfer money between bank accounts (`/bank-transfer`). Type the hidden page into the FakeBank website using the browser's address bar.

![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/63588b5ef586912c7d03c4f0-1716286251760)

From this page, an attacker has authorized access and can steal money from any bank account. As an ethical hacker, you would (with permission) find vulnerabilities in their application and report them to the bank to fix them before a hacker exploits them.

Your mission is to transfer $2000 from bank account 2276 to your account (account number 8881). If your transfer was successful, you should now be able to see your new balance reflected on your account page.

Go there now and confirm you got the money! (You may need to hit Refresh for the changes to appear)

### **Answer the questions below**

---

# Offensive Security Intro


## Careers in cyber security

In this room, we've talked about offensive security and guided you through hacking your first website in a safe environment. You learned how to use Gobuster to find hidden pages in the target website and transferred a considerable amount of (fake) money to your account.
This is just a glimpse of the challenges you can expect as a member of the offensive security team. However, We want to reiterate that an ethical hacker's goal is to identify loopholes and report them so that the defensive security team can fix them.
Speaking of defensive security, Intro to Defensive Security is the next room in this module. Learn about what the other team does by following this link [here](https://tryhackme.com/jr/defensivesecuritysa).
If you want to skip ahead and learn more about the topics discussed in this room, the following rooms are recommended:
- [Web Enumeration](https://tryhackme.com/r/room/webenumerationv2) - Learn the methodology of enumerating websites by using tools such as Gobuster, Nikto and WPScan
- [Become a Hacker](https://tryhackme.com/r/room/becomeahackeroa) - Learn how TryHackMe can help you become a hacker.

### **Answer the questions below**

---

{% endraw %}
