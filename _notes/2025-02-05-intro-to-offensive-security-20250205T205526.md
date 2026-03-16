---
layout: post
title: "Intro to Offensive Security"
date: 2025-02-05
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Introduction to Cyber Security"
identifier: "20250205T205526"
source_id: "b416dd03-ca2d-47ee-a21c-04aa77de02d4"
source_path: "Introduction to Cyber Security/20250205T205526--intro-to-offensive-security__tryhackme.md"
---

{% raw %}


### Introduction to Cyber Security > Intro to Offensive Security

### [TryHackMe | Intro to Offensive Security](https://tryhackme.com/r/room/introtooffensivesecurity)

## What is Offensive Security?

In short, offensive security is the process of breaking into computer systems, exploiting software bugs, and finding loopholes in applications to gain unauthorized access to them.

To beat a hacker, you need to behave like a hacker, finding vulnerabilities and recommending patches before a cybercriminal does, as you'll do in this room!  On the flip side, there is also defensive security, which is the process of protecting an organization's network and computer systems by analyzing and securing any potential digital threats; learn more in the digital forensics room.

In a defensive cyber role, you could be investigating infected computers or devices to understand how it was hacked, tracking down cybercriminals, or monitoring infrastructure for malicious activity.

## **Answer the questions below**

**Question:** Which of the following options better represents the process where you simulate a hacker's actions to find vulnerabilities in a system?
Offensive Security
Defensive Security

     Answer: Offensive Security


---

## Hacking your first machine

Before going into cyber security careers and what offensive security is, let's get you hacking (and yes, its legal, all exercises are fake simulations)

 Your first hack

 Start Machine When you first open this task on a desktop, your screen will automatically start the task's virtual machine and display it in a split screen. You'll use it to hack a fake bank application called FakeBank. You can also click on the **Start Machine** button to deploy it from a mobile device. If your screen doesn't split, use the blue **Show Split View** button at the top left of this page.

  Stuck? See image  

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/5f04259cf9bf5b57aed2c476-1717056988909)

 
  
 We will use a command-line application called "GoBuster" to brute-force FakeBank's website to find hidden directories and pages. GoBuster will take a list of potential page or directory names and tries accessing a website with each of them; if the page exists, it tells you.

 Step 1) Open a terminal

A terminal, also known as the command-line, allows us to interact with a computer without using a graphical user interface. On the machine, open the terminal using the Terminal icon: 

![Image 2]()

![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/5bec5dfd73790a7d06282266/room-content/443d573c553e59e4897aa99d2e77b679.png)

   Stuck? See video    

Step 2) Find hidden website pages

Most companies will have an admin portal page, giving their staff access to basic admin controls for day-to-day operations. For a bank, an employee might need to transfer money to and from client accounts. Often these pages are not made private, allowing attackers to find hidden pages that show, or give access to, admin controls or sensitive data.

Type the following command into the terminal to find potentially hidden pages on FakeBank's website using GoBuster (a command-line security application).

 ```
gobuster -u http://fakebank.com -w wordlist.txt dir
```

 The command will run and show you an output similar to this:

    GoBuster command to brute-force website pages  ```
           ubuntu@tryhackme:~/Desktop$ gobuster -u http://fakebank.com -w wordlist.txt dir
=====================================================
Gobuster v2.0.1
=====================================================
[+] Mode         : dir
[+] Url/Domain   : http://fakebank.com/
[+] Threads      : 10
[+] Wordlist     : wordlist.txt
[+] Status codes : 200,204,301,302,307,403
[+] Timeout      : 10s
=====================================================
2022/04/11 18:23:28 Starting gobuster
=====================================================
/images (Status: 301)
/DIRECTORY_NAME_OUTPUT (Status: 200)
=====================================================
2022/04/11 18:23:38 Finished
=====================================================

        


   *Don't worry if you have not used a terminal before - TryHackMe walks you through everything!* ```

In the command above, `-u` is used to state the website we're scanning, `-w` takes a list of words to iterate through to find hidden pages.

You will see that GoBuster scans the website with each word in the list, finding pages that exist on the site. GoBuster will have told you the pages it found in the list of page/directory names (indicated by Status: 200).

![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/5bec5dfd73790a7d06282266/room-content/73103edfb588a260fb9d336094ad5253.png)

Step 3) Hack the bank

You should have found a secret bank transfer page that allows you to transfer money between accounts at the bank (/bank-transfer). Type the hidden page into the FakeBank website on the machine.

  Stuck? See video     This page allows an attacker to steal money from any bank account, which is a critical risk for the bank. As an ethical hacker, you would (with permission) find vulnerabilities in their application and report them to the bank to fix before a hacker exploits them.

Transfer $2000 from the bank account 2276, to your account (account number 8881).

## **Answer the questions below**

**Question:** If your transfer was successful, you should now be able to see your new balance reflected on your account page. Go there now and confirm you got the money! (You may need to hit Refresh for the changes to appear)Above your account balance, you should now see a message indicating the answer to this question. Can you find the answer you need?

     Answer: BANK-HACKED


**Question:** If you were a penetration tester or security consultant, this is an exercise you’d perform for companies to test for vulnerabilities in their web applications; find hidden pages to investigate for vulnerabilities.

     Answer: 


**Question:** Terminate the machine by clicking the red "Terminate" button at the top of the page.

     Answer: 


---

# Intro to Offensive Security


## Careers in cyber security

How can I start learning?

People often wonder how others become hackers (security consultants) or defenders (security analysts fighting cybercrime), and the answer is simple. Break it down, learn an area of cyber security you're interested in, and regularly practice using hands-on exercises. Build a habit of learning a little bit each day on TryHackMe, and you'll acquire the knowledge to get your first job in the industry.

Trust us; you can do it! Just take a look at some people who have used TryHackMe to get their first security job:

- Paul went from a construction worker to a security engineer. [Read more](https://tryhackme.com/resources/blog/construction-worker-to-security-engineer-how-paul-used-tryhackme-to-land-his-first-job-in-security).
- Kassandra went from a music teacher to a security professional. [Read more](https://tryhackme.com/resources/blog/the-teacher-becomes-the-student).
- Brandon used TryHackMe while at school to get his first job in cyber. [Read more](https://tryhackme.com/resources/blog/brandons-success-story).

What careers are there?

The cyber careers room goes into more depth about the different careers in cyber. However, here is a short description of a few offensive security roles:

- Penetration Tester - Responsible for testing technology products for finding exploitable security vulnerabilities.
- Red Teamer - Plays the role of an adversary, attacking an organization and providing feedback from an enemy's perspective.
- Security Engineer - Design, monitor, and maintain security controls, networks, and systems to help prevent cyberattacks.

## **Answer the questions below**

**Question:** Read the above, and continue with the next room!

     Answer: 


---

{% endraw %}
