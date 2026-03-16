---
title: TryHackMe - IDOR - Santa’s Little IDOR
Date: 2025-12-24
Tags: #TryHackMe
identifier: 20251231T211716
Hubs: "TryHackMe/Learn/IDOR - Santa’s Little IDOR"
id: 6cc6f1d5-c1cd-4917-aff4-39505dd152c3
URLs: (https://tryhackme.com/room/idor-aoc2025-zl6MywQid9)
---

# TryHackMe | IDOR - Santa’s Little IDOR

## Task 1 | Introduction

The Story

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/66c44fd9733427ea1181ad58/room-content/66c44fd9733427ea1181ad58-1761575138937.svg)

The elves of Wareville are on high alert since McSkidy went missing. Recently, the support team has been receiving many calls from parents who can't activate vouchers on the TryPresentMe website. They also mentioned they are receiving many targeted phishing emails containing information that is not public. The support team is wary and has enlisted the help of the TBFC staff. When looking into this peculiar case, they discovered a suspiciously named account named Sir Carrotbane, which has many vouchers assigned to it. For now, they have deleted the account and retrieved the vouchers. But something is going on. Can you help the TBFC staff investigate the TryPresentMe website and fix the vulnerabilities?

Learning Objectives

- Understand the concept of authentication and authorization
- Learn how to spot potential opportunities for Insecure Direct Object References (IDORs)
- Exploit IDOR to perform horizontal privilege escalation
- Learn how to turn IDOR into SDOR (Secure Direct Object Reference)

Connecting to the Machine Before moving forward, review the questions in the connection card shown below:

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/66c44fd9733427ea1181ad58/room-content/66c44fd9733427ea1181ad58-1762448385881.svg)

Start your target VM by clicking the **Start Machine** button below. The machine will need about 2 minutes to fully boot. Additionally, start your AttackBox by clicking the **Start AttackBox** button below. The AttackBox will start in split view. In case you can not see it, click the Show Split view button at the top of the page. Inside your AttackBox, open a web browser and navigate to the TryPresentMe application at `http://MACHINE_IP`.

Set up your virtual environmentTo successfully complete this room, you'll need to set up your virtual environment. This involves starting both your AttackBox (if you're not using your VPN) and Target Machines, ensuring you're equipped with the necessary tools and access to tackle the challenges ahead.

![Image 3](https://tryhackme.com/static/svg/attack-box-to-target-machine.e30b7a02.svg)

Attacker machine

![Image 4](data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTciIGhlaWdodD0iMTYiIHZpZXdCb3g9IjAgMCAxNyAxNiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTguODI1MiAwQzQuNDA2NDUgMCAwLjgyNTE5NSAzLjU4MTI1IDAuODI1MTk1IDhDMC44MjUxOTUgMTIuNDE4NyA0LjQwNjQ1IDE2IDguODI1MiAxNkMxMy4yNDM5IDE2IDE2LjgyNTIgMTIuNDE4NyAxNi44MjUyIDhDMTYuODI1MiAzLjU4MTI1IDEzLjI0MzkgMCA4LjgyNTIgMFpNOC44MjUyIDRDOS4zNzczOCA0IDkuODI1MiA0LjQ0NzgxIDkuODI1MiA1QzkuODI1MiA1LjU1MjE5IDkuMzc3MzggNiA4LjgyNTIgNkM4LjI3MzAxIDYgNy44MjUyIDUuNTUzMTIgNy44MjUyIDVDNy44MjUyIDQuNDQ2ODggOC4yNzIwNyA0IDguODI1MiA0Wk0xMC4wNzUyIDEySDcuNTc1MkM3LjE2MjcgMTIgNi44MjUyIDExLjY2NTYgNi44MjUyIDExLjI1QzYuODI1MiAxMC44MzQ0IDcuMTYxMTMgMTAuNSA3LjU3NTIgMTAuNUg4LjA3NTJWOC41SDcuODI1MkM3LjQxMTEzIDguNSA3LjA3NTIgOC4xNjQwNiA3LjA3NTIgNy43NUM3LjA3NTIgNy4zMzU5NCA3LjQxMjcgNyA3LjgyNTIgN0g4LjgyNTJDOS4yMzkyNiA3IDkuNTc1MiA3LjMzNTk0IDkuNTc1MiA3Ljc1VjEwLjVIMTAuMDc1MkMxMC40ODkzIDEwLjUgMTAuODI1MiAxMC44MzU5IDEwLjgyNTIgMTEuMjVDMTAuODI1MiAxMS42NjQxIDEwLjQ5MDggMTIgMTAuMDc1MiAxMloiIGZpbGw9IiM4NzhGQTIiLz4KPC9zdmc+Cg==)

Status:Connected via AttackboxTarget machine

![Image 5](data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTciIGhlaWdodD0iMTYiIHZpZXdCb3g9IjAgMCAxNyAxNiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTguODI1MiAwQzQuNDA2NDUgMCAwLjgyNTE5NSAzLjU4MTI1IDAuODI1MTk1IDhDMC44MjUxOTUgMTIuNDE4NyA0LjQwNjQ1IDE2IDguODI1MiAxNkMxMy4yNDM5IDE2IDE2LjgyNTIgMTIuNDE4NyAxNi44MjUyIDhDMTYuODI1MiAzLjU4MTI1IDEzLjI0MzkgMCA4LjgyNTIgMFpNOC44MjUyIDRDOS4zNzczOCA0IDkuODI1MiA0LjQ0NzgxIDkuODI1MiA1QzkuODI1MiA1LjU1MjE5IDkuMzc3MzggNiA4LjgyNTIgNkM4LjI3MzAxIDYgNy44MjUyIDUuNTUzMTIgNy44MjUyIDVDNy44MjUyIDQuNDQ2ODggOC4yNzIwNyA0IDguODI1MiA0Wk0xMC4wNzUyIDEySDcuNTc1MkM3LjE2MjcgMTIgNi44MjUyIDExLjY2NTYgNi44MjUyIDExLjI1QzYuODI1MiAxMC44MzQ0IDcuMTYxMTMgMTAuNSA3LjU3NTIgMTAuNUg4LjA3NTJWOC41SDcuODI1MkM3LjQxMTEzIDguNSA3LjA3NTIgOC4xNjQwNiA3LjA3NTIgNy43NUM3LjA3NTIgNy4zMzU5NCA3LjQxMjcgNyA3LjgyNTIgN0g4LjgyNTJDOS4yMzkyNiA3IDkuNTc1MiA3LjMzNTk0IDkuNTc1MiA3Ljc1VjEwLjVIMTAuMDc1MkMxMC40ODkzIDEwLjUgMTAuODI1MiAxMC44MzU5IDEwLjgyNTIgMTEuMjVDMTAuODI1MiAxMS42NjQxIDEwLjQ5MDggMTIgMTAuMDc1MiAxMloiIGZpbGw9IiM4NzhGQTIiLz4KPC9zdmc+Cg==)

Status:OffStart Machine

### **Answer the questions below**

**Question:**

_Answer:_

     No answer needed

---

## Task 2 | IDOR on the Shelf

It’s Dangerously Obvious, Really Have you ever seen a link that looks like this: `https://awesome.website.thm/TrackPackage?packageID=1001`?

When you saw a link like this, have you ever wondered what would happen if you simply changed the packageID to 11 or 12? In its simplest form, this can be a potential case for IDOR.

IDOR stands for **Insecure Direct Object Reference** and is a type of access control vulnerability. Web applications often use references to determine what data to return when you make a request. However, if the web server doesn't perform checks to ensure you are allowed to view that data before sending it, it can lead to serious sensitive information disclosure. A good question to ask then is:

_Why does this happen so often?_

We need to understand references and web development a bit more to answer this. Let's take a look at what a table storing these package numbers from our link example could look like:

    packageID person address status     1001 Alice Smith 123 Main St, Springfield Delivered   1002 Bob Johnson 42 Elm Ave, Shelbyville In Transit   1003 Carol White 9 Oak Rd, Capital City Out for Delivery   1004 Daniel Brown 77 Pine St, Ogdenville Pending   1005 Eve Martinez 5 Maple Ln, North Haverbrook Returned    If the user wants to know the status of their package and makes a web request, the simplest method is to allow the user to supply their packageID. We recover data from the database using the simplest SQL query of:

`SELECT person, address, status FROM Packages WHERE packageID = value;`

However, since packageID is a sequential number, it becomes pretty obvious to guess the packageIDs of other customers, and since the web application isn't verifying that the person making the request **is the same** person as the one who owns the package, an IDOR vulnerability appears, allowing attackers to recover the details for packages belonging to other users. Even worse is when a feature like this doesn't require a user to authenticate, then there would be no way to even tell who is making the request! To dive a bit deeper, we need to understand authentication, authorization, and privilege escalation.

**A note from one of the co-authors of this task:** I am not a fan of the vulnerability name IDOR. I prefer the name authorization Bypass. If you want to understand my reasoning, expand here, but you don't have to be bored with the details! It Doesn’t Obviously Relate The full term, Insecure Direct Object Reference, sounds fancy, but it doesn’t really describe what’s going wrong. The “Direct Object Reference” part just means that a system uses an ID (like `/user/1`) to point to something. That’s not the problem. The real issue is that the system doesn’t check whether the person making the request is allowed to access it.

A lot of people try to “fix” IDORs by hiding or encoding IDs. For example, changing `/user/1` to `/user/ea21f09b2`. That might make it look harder to guess, but if the server still isn’t checking permissions, it’s just as insecure. The vulnerability isn’t about how the object is referenced, it’s about missing authorization checks.

That’s why I prefer to call it an Authorization Bypass instead. It explains exactly what’s happening: someone is bypassing the rules that decide who can see or change something. Whether the ID is a number, a hash, or a random string, the risk stays the same if the server doesn’t verify access. You can read more [here](https://www.mwrcybersec.com/whats-the-deal-with-idor) if you want.

Identity Defines Our Reach To understand the root cause of IDOR, it is important to understand the basic principles of authentication and authorization:

- **Authentication:** The process by which you verify who you are. For example, supplying your username and password.
- **Authorization:** The process by which the web application verifies your permissions. For example, are you allowed to visit the admin page of a web application, or are you allowed to make a payment using a specific account?

You may think that authentication only happens once when you supply your username and password, but that is actually not the case! After providing your credentials, you receive a cookie or a token, called session information. Every subsequent request you make to the application includes this session information, which is verified by the application. This initial verification process is still authentication and happens for each request. This is why websites will often redirect you back to the login page. It means your session information has expired, and thus, you need to reauthenticate with your credentials to receive new session information.

Authorization cannot happen before authentication. If the application doesn't know who you are, it cannot verify what permissions your user has. This is very important to remember. If your IDOR doesn't require you to authenticate (login or provide session information), such as in our package tracking example, we will have to fix authentication first before we can fix the authorization issue of making sure that users can only get information about packages they own.

The last bit of theory to cover is privilege escalation types:

- **Vertical privilege escalation:** This refers to privilege escalation where you gain access to more features. For example, you may be a normal user on the application, but can perform actions that should be restricted for an administrator.
- **Horizontal privilege escalation:** This refers to privilege escalation where you use a feature you are authorized to use, but gain access to data that you are not allowed to access. For example, you should only be able to see your accounts, not someone else's accounts.

IDOR is usually a form of horizontal privilege escalation. You are allowed to make use of the track package functionality. But you should be restricted to only performing that tracking action for packages you own. Now that we understand the theory, let's look at how to exploit IDOR practically!

Iterate Digits, Observe Responses Let's start with the simplest example of IDOR. On the web application, let's authenticate to the application using the details below.

Credentials

Username niels Password TryHackMe#2025 IP address/Website http://MACHINE_IP Once authenticated, you should see a dashboard like this:

![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/6093e17fa004d20049b6933e/room-content/6093e17fa004d20049b6933e-1759960849816.png)

Let's start by using the **Developer Tools** of our browser to better understand what is happening in the background. Right-click on the page and click **Inspect** , then click on the **Network** tab as shown below:

![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/66c44fd9733427ea1181ad58/room-content/66c44fd9733427ea1181ad58-1762364712898.png)

Now let's refresh the page and see what requests are being made. It should look something like this:

![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/66c44fd9733427ea1181ad58/room-content/66c44fd9733427ea1181ad58-1762173380915.png)

Let's take a closer look at the `view_accountinfo` request. Click on it and you will see the following:

![Image 9](https://tryhackme-images.s3.amazonaws.com/user-uploads/66c44fd9733427ea1181ad58/room-content/66c44fd9733427ea1181ad58-1762434874129.png)

In the above image we can see that the `user_id` with the value of 10 was used for the request. If we click and expand the **Response** tab, we can see that this `user_id` corresponds to our user:

![Image 10](https://tryhackme-images.s3.amazonaws.com/user-uploads/6093e17fa004d20049b6933e/room-content/6093e17fa004d20049b6933e-1759961699539.png)

This tells us that the application is using our `user_id` as the reference for getting details. Let's see what happens when we change this. In the Developer Tools, navigate to the **Storage** tab and expand the **Local Storage** dropdown on the left side and click the URL inside it:

![Image 11](https://tryhackme-images.s3.amazonaws.com/user-uploads/66c44fd9733427ea1181ad58/room-content/66c44fd9733427ea1181ad58-1762435018129.png)

Let's change the `user_id` to 11 and see what happens. Double-click on the **Value** field of the `auth_user` data entry, update the `user_id` to 11 and save it by pressing **Enter** . Now refresh the page. All of a sudden it seems like you are a completely different user!

This is the simplest form of IDOR. Simply changing the `user_id` to something else means we can see other users' data. Some IDORs might be slightly more hidden. Just because you don't see a direct number doesn't mean it doesn't exist! Let's dive deeper. To continue onto the next challenges of the task, **go and change the id back to 10 using the same steps you followed above** . Alternatively, you can log out of the application and log back in using the username and password.

In Disguise: Obvious References Sometimes, IDOR may not be as simple as just a number. In certain cases, encoding may have been used. On the loaded profile, click the eye icon next to the first child as shown on the image below.

![Image 12](https://tryhackme-images.s3.amazonaws.com/user-uploads/66c44fd9733427ea1181ad58/room-content/66c44fd9733427ea1181ad58-1762365624869.png)

Now go back to the **Network** tab and take a look at the requests being made; you should see a request like this:

![Image 13](https://tryhackme-images.s3.amazonaws.com/user-uploads/66c44fd9733427ea1181ad58/room-content/66c44fd9733427ea1181ad58-1762174472236.png)

Simply put, the `Mg==` is just the base64 encoded version of the number `2`. You could still perform IDOR using this request, but you would have to base64 encode the number first.

In Digests, Objects Remain Encoding isn't the only thing that can be used to hide potential IDOR vulnerabilities. Sometimes the values may look like a hash, such as MD5 or SHA1. If you want to see what that would look like, take a look at the request that happens when you click the edit icon next to a child.

![Image 14](https://tryhackme-images.s3.amazonaws.com/user-uploads/66c44fd9733427ea1181ad58/room-content/66c44fd9733427ea1181ad58-1762174472380.png)

While the string may look random, upon further investigation, you can see that it is a type of hash. If we understand what value was used to generate the hash, we can perform an IDOR attack by simply replicating the hashing function. Using something like a [hash identifier](https://hashes.com/en/tools/hash_identifier) can help you quickly understand what hashing algorithm is being used and can often tell you what data was hashed.

It's Deterministic, Obviously Reproducible Sometimes you have to dig quite deep for IDOR. Sometimes IDOR is not as clear. Sometimes the IDOR stems from the actual algorithm being used. In this last case, let's take a look at our vouchers. While the values may look random, we need to investigate what algorithm was used to generate them. Their format looks like a UUID, so let's use a website such as [UUID Decoder](https://www.uuidtools.com/decode) to try to understand what UUID format was used. Copy one of the vouchers to the website for decoding, and you should see something like this:

![Image 15](https://tryhackme-images.s3.amazonaws.com/user-uploads/6093e17fa004d20049b6933e/room-content/6093e17fa004d20049b6933e-1759961699555.png)

While these look completely random, we can see that the UUID version 1 was used. The issue with UUID 1 is that if we know the exact date when the code was generated, we can recover the UUID. For example, suppose we knew the elves always generated vouchers between 20:00 - 21:00. In that case, we can create UUIDs for that entire time period (3600 UUIDs since we have 60 minutes, and 60 seconds in a minute), which we could use in a brute force attack to aim to recover a valid voucher and get more gifts.

Now that we have seen the various IDORs that can be found, let's discuss how to fix them and avoid them!

Improve Design, Obliterate Risk Now that we learned about what IDOR is, let's discuss how to fix it. The best way to stop IDOR is to make sure the server checks who is asking for the data every time. It's not enough to hide or change the ID number; the system must confirm that the logged-in user is authorized to see or change that information.

Don't rely on tricks like Base64 or hashing the IDs; those can still be guessed or decoded. Instead, keep all the real permission checks on the server. Whenever a request comes in, check: _"Does this user own or have permission to view this item?"_

Use random or hard-to-guess IDs for public links, but remember that random IDs alone don't make your app safe. Always test your app by trying to open another user's data and making sure it's blocked. Finally, record and monitor failed access attempts; they can be early signs of someone trying to exploit an IDOR.

### **Answer the questions below**

**Question:**

_Answer:_

     Insecure Direct Object Reference

**Question:**

_Answer:_

     Horizontal

**Question:**

_Answer:_

     15

**Question:**

_Answer:_

     No answer needed

**Question:**

_Answer:_

     No answer needed

**Question:**

_Answer:_

     No answer needed

---
