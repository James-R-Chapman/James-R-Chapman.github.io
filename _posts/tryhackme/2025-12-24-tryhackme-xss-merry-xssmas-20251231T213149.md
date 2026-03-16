---
layout: post
title: "TryHackMe  - XSS - Merry XSSMas"
date: 2025-12-24
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Learn/XSS - Merry XSSMas"
identifier: "20251231T213149"
source_id: "accc9d98-bf84-4c0f-870c-d1d335049098"
source_urls: "(https://tryhackme.com/room/xss-aoc2025-c5j8b1m4t6)"
source_path: "20251231T213149--tryhackme-xss-merry-xssmas__tryhackme.md"
---


# TryHackMe | XSS - Merry XSSMas

## Task 1 | Introduction

The Story

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f9c7574e201fe31dad228fc/room-content/5f9c7574e201fe31dad228fc-1763406635391.png)

After last year's automation and tech modernisation, Santa's workshop got a new makeover. McSkidy has a secure message portal where you can contact her directly with any questions or concerns. However, lately, the logs have been lighting up with unusual activity, ranging from odd messages to suspicious search terms. Even Santa's letters appear to be scripts or random code. Your mission, should you choose to accept it: dig through the logs, uncover the mischief, and figure out who's trying to mess with McSkidy.

Learning Objectives

- Understand how XSS works
- Learn to prevent XSS attacks

Connecting to the Machine Before moving forward, review the questions in the connection card shown below:

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f9c7574e201fe31dad228fc/room-content/5f9c7574e201fe31dad228fc-1763407834347.png)

Start your target machine by clicking the **Start Machine** button below. The machine will need about 2 minutes to fully boot. Additionally, start your AttackBox by clicking the **Start AttackBox** button below. The AttackBox will start in split view. In case you can not see it, click the **Show Split View** button at the top of the page.

Set up your virtual environmentTo successfully complete this room, you'll need to set up your virtual environment. This involves starting both your AttackBox (if you're not using your VPN) and Target Machines, ensuring you're equipped with the necessary tools and access to tackle the challenges ahead.

![Image 3](https://tryhackme.com/static/svg/attack-box-to-target-machine.e30b7a02.svg)

Attacker machine

![Image 4](data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTciIGhlaWdodD0iMTYiIHZpZXdCb3g9IjAgMCAxNyAxNiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTguODI1MiAwQzQuNDA2NDUgMCAwLjgyNTE5NSAzLjU4MTI1IDAuODI1MTk1IDhDMC44MjUxOTUgMTIuNDE4NyA0LjQwNjQ1IDE2IDguODI1MiAxNkMxMy4yNDM5IDE2IDE2LjgyNTIgMTIuNDE4NyAxNi44MjUyIDhDMTYuODI1MiAzLjU4MTI1IDEzLjI0MzkgMCA4LjgyNTIgMFpNOC44MjUyIDRDOS4zNzczOCA0IDkuODI1MiA0LjQ0NzgxIDkuODI1MiA1QzkuODI1MiA1LjU1MjE5IDkuMzc3MzggNiA4LjgyNTIgNkM4LjI3MzAxIDYgNy44MjUyIDUuNTUzMTIgNy44MjUyIDVDNy44MjUyIDQuNDQ2ODggOC4yNzIwNyA0IDguODI1MiA0Wk0xMC4wNzUyIDEySDcuNTc1MkM3LjE2MjcgMTIgNi44MjUyIDExLjY2NTYgNi44MjUyIDExLjI1QzYuODI1MiAxMC44MzQ0IDcuMTYxMTMgMTAuNSA3LjU3NTIgMTAuNUg4LjA3NTJWOC41SDcuODI1MkM3LjQxMTEzIDguNSA3LjA3NTIgOC4xNjQwNiA3LjA3NTIgNy43NUM3LjA3NTIgNy4zMzU5NCA3LjQxMjcgNyA3LjgyNTIgN0g4LjgyNTJDOS4yMzkyNiA3IDkuNTc1MiA3LjMzNTk0IDkuNTc1MiA3Ljc1VjEwLjVIMTAuMDc1MkMxMC40ODkzIDEwLjUgMTAuODI1MiAxMC44MzU5IDEwLjgyNTIgMTEuMjVDMTAuODI1MiAxMS42NjQxIDEwLjQ5MDggMTIgMTAuMDc1MiAxMloiIGZpbGw9IiM4NzhGQTIiLz4KPC9zdmc+Cg==)

Status:Connected via Attackbox Show Split ViewTarget machine

![Image 5](data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTciIGhlaWdodD0iMTYiIHZpZXdCb3g9IjAgMCAxNyAxNiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTguODI1MiAwQzQuNDA2NDUgMCAwLjgyNTE5NSAzLjU4MTI1IDAuODI1MTk1IDhDMC44MjUxOTUgMTIuNDE4NyA0LjQwNjQ1IDE2IDguODI1MiAxNkMxMy4yNDM5IDE2IDE2LjgyNTIgMTIuNDE4NyAxNi44MjUyIDhDMTYuODI1MiAzLjU4MTI1IDEzLjI0MzkgMCA4LjgyNTIgMFpNOC44MjUyIDRDOS4zNzczOCA0IDkuODI1MiA0LjQ0NzgxIDkuODI1MiA1QzkuODI1MiA1LjU1MjE5IDkuMzc3MzggNiA4LjgyNTIgNkM4LjI3MzAxIDYgNy44MjUyIDUuNTUzMTIgNy44MjUyIDVDNy44MjUyIDQuNDQ2ODggOC4yNzIwNyA0IDguODI1MiA0Wk0xMC4wNzUyIDEySDcuNTc1MkM3LjE2MjcgMTIgNi44MjUyIDExLjY2NTYgNi44MjUyIDExLjI1QzYuODI1MiAxMC44MzQ0IDcuMTYxMTMgMTAuNSA3LjU3NTIgMTAuNUg4LjA3NTJWOC41SDcuODI1MkM3LjQxMTEzIDguNSA3LjA3NTIgOC4xNjQwNiA3LjA3NTIgNy43NUM3LjA3NTIgNy4zMzU5NCA3LjQxMjcgNyA3LjgyNTIgN0g4LjgyNTJDOS4yMzkyNiA3IDkuNTc1MiA3LjMzNTk0IDkuNTc1MiA3Ljc1VjEwLjVIMTAuMDc1MkMxMC40ODkzIDEwLjUgMTAuODI1MiAxMC44MzU5IDEwLjgyNTIgMTEuMjVDMTAuODI1MiAxMS42NjQxIDEwLjQ5MDggMTIgMTAuMDc1MiAxMloiIGZpbGw9IiM4NzhGQTIiLz4KPC9zdmc+Cg==)

Status:OffStart Machine

### **Answer the questions below**

**Question:**

_Answer:_

     No answer needed

---

## Task 2 | Leave the Cookies, Take the Payload

Equipment Check For today's room we will be using a the web app found under http://MACHINE_IP. You can use the browser of your AttackBox to navigate to it. You will see a page as shown below:

![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/6890a24ce8a6d10e9ad22d67/room-content/6890a24ce8a6d10e9ad22d67-1761292275782.png)

Let's review some key material regarding potential attacks on websites like this portal, specifically [Cross-Site Scripting (XSS)](https://tryhackme.com/room/axss).

XSS is a web application vulnerability that lets attackers (or evil bunnies) inject malicious code (usually JavaScript) into input fields that reflect content viewed by other users (e.g., a form or a comment in a blog). When an application doesn't properly validate or escape user input, that input can be interpreted as code rather than harmless text. This results in malicious code that can steal credentials, deface pages, or impersonate users. Depending on the result, there are various types of XSS. In today’s task, we focus on **Reflected XSS** and **Stored XSS** .

Reflected XSS You see reflected variants when the injection is immediately projected in a response. Imagine a toy search function in an online toy store, you search via:

`https://trygiftme.thm/search?term=gift`

But imagine you send this to your friend who is looking for a gift for their nephew (please don't do this):

`https://trygiftme.thm/search?term=<script>alert( atob("VEhNe0V2aWxfQnVubnl9") )</script>`

If your friend clicks on the link, it will execute code instead.

**Impact**

You could act, view information, or modify information that your friend or any user could do, view, or access. It's usually exploited via phishing to trick users into clicking a link with malicious code injected.

Stored XSS A Stored XSS attack occurs when malicious script is saved on the server and then loaded for every user who views the affected page. Unlike Reflected XSS, which targets individual victims, Stored XSS becomes a "set-and-forget" attack, anyone who loads the page runs the attacker’s script.

To understand how this works, let’s use the example of a simple blog where users can submit comments that get displayed below each post.

Normal Comment Submission

```
POST /post/comment HTTP/1.1
Host: tgm.review-your-gifts.thm

postId=3
name=Tony Baritone
email=tony@normal-person-i-swear.net
comment=This gift set my carpet on fire but my kid loved it!
```

The server stores this information and displays it whenever someone visits that blog post.

Malicious Comment Submission (Stored XSS Example) If the application does not sanitize or filter input, an attacker can submit JavaScript instead of a comment:

```
POST /post/comment HTTP/1.1
Host: tgm.review-your-gifts.thm

postId=3
name=Tony Baritone
email=tony@normal-person-i-swear.net
comment=<script>alert(atob("VEhNe0V2aWxfU3RvcmVkX0VnZ30="))</script> + "This gift set my carpet on fire but my kid loved it!"
```

Because the comment is saved in the database, every user who opens that blog post will automatically trigger the script. This lets the attacker run code as if they were the victim in order to perform malicious actions such as:

- Steal session cookies
- Trigger fake login popups
- Deface the page

Protecting against XSS Each service is different, and requires a well-thought-out, secure design and implementation plan, but key practices you can implement are:

- **Disable dangerous rendering raths:** Instead of using the `innerHTML` property, which lets you inject any content directly into HTML, use the `textContent` property instead, it treats input as text and parses it for HTML.
- **Make cookies inaccessible to JS:** Set session cookies with the [HttpOnly](https://owasp.org/www-community/HttpOnly), [Secure](https://owasp.org/www-community/controls/SecureCookieAttribute), and [SameSite](https://owasp.org/www-community/SameSite) attributes to reduce the impact of XSS attacks.
- **Sanitise input/output and encode:**
- - In some situations, applications may need to accept limited HTML input—for example, to allow users to include safe links or basic formatting. However it's critical to sanitize and encode all user-supplied data to prevent security vulnerabilities. Sanitising and encoding removes or escapes any elements that could be interpreted as executable code, such as scripts, event handlers, or JavaScript URLs while preserving safe formatting.

To exploit XSS vulnerabilities, we need some type of input field to inject code. There is a search section, let's start there.

Exploiting Reflected XSS To exploit reflected XSS, we can use test payloads to check if the app runs the code injected. If you want to test more advanced payloads, there are [cheat sheets](https://portswigger.net/web-security/cross-site-scripting/cheat-sheet) online that you can use to craft them. For now, we'll pick the following payload:

`<script>alert('Reflected Meow Meow')</script>`

Inject the code by adding the payload to the search bar and clicking " **Search Messages** ". If it shows the alert text, we have confirmed reflected XSS. So, what happened?

- - The search input is reflected directly in the results without encoding
- The browser interprets your HTML/JavaScript as executable code
- An alert box appeared, demonstrating successful XSS execution

You can track the behaviour and how the system interprets your actions by checking the " **System Logs** " tab at the bottom of the page:

![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/61a7523c029d1c004fac97b3/room-content/61a7523c029d1c004fac97b3-1760342225658.png)

Now that we have confirmed reflected XSS, let's investigate if it's susceptible to stored XSS. This vector must be different, as it needs to be persisted. Looking at the website, we can see that you are able to send messages, which are stored on the server for McSkidy to view later (as opposed to searching, which is stored temporarily on the client side).

Navigate to the message form, and enter the malicious payload we used before (others work too):

`<script>alert('Stored Meow Meow')</script>`

Click the " **Send Message** " button. Because messages are stored on the server, every time you navigate to the site or reload, the alert will display.

Wrapping Up So it's confirmed! The site is vulnerable to XSS; it's no wonder that unusual payloads have been detected in the logs. The team will now harden the site to prevent future malicious code from being injected.

### **Answer the questions below**

**Question:**

_Answer:_

     stored

**Question:**

_Answer:_

     THM{Evil_Bunny}

**Question:**

_Answer:_

     THM{Evil_Stored_Egg}

**Question:**

_Answer:_

     No answer needed

---
