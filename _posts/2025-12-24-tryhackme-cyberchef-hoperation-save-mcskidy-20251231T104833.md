---
layout: post
title: "TryHackMe  - CyberChef - Hoperation Save McSkidy"
date: 2025-12-24
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Learn/CyberChef - Hoperation Save McSkidy"
identifier: "20251231T104833"
source_id: "209c59c5-893a-48b7-8ef1-85184df9b29d"
source_urls: "(https://tryhackme.com/room/encoding-decoding-aoc2025-s1a4z7x0c3)"
source_path: "20251231T104833--tryhackme-cyberchef-hoperation-save-mcskidy__tryhackme.md"
---


# TryHackMe | CyberChef - Hoperation Save McSkidy

## Task 1 | Introduction

The Story

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763533892160.png)

_McSkidy is imprisoned in King Malhare's Quantum Warren. Sir BreachBlocker III was put in charge of securing the fortress and implemented several access controls to prevent any escape. His defenses are worthy of his name._

_However, McSkidy managed to send vital clues to his team using harmless bunny pictures. One message revealed that five locks needed to be disabled to secure an escape route. The locks can be broken by examining their logic and leveraging the system's built-in chat for the guards. They can be eluded in revealing vital details or even passwords. However, you will need to speak their language._

Learning Objectives

- Introduction to encoding/decoding
- Learn how to use CyberChef
- Identify useful information in web applications through HTTP headers

Connecting to the Machine ![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763965652654.png)

Start your target machine by clicking the **Start Machine** button below. The machine will need about 2 minutes to fully boot. Additionally, start your AttackBox by clicking the **Start AttackBox** button below. The AttackBox will start in split view. In case you can not see it, click the **Show Split View** button at the top of the page.

Set up your virtual environmentTo successfully complete this room, you'll need to set up your virtual environment. This involves starting both your AttackBox (if you're not using your VPN) and Target Machines, ensuring you're equipped with the necessary tools and access to tackle the challenges ahead.

![Image 3](https://tryhackme.com/static/svg/attack-box-to-target-machine.e30b7a02.svg)

Attacker machine

![Image 4](data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTciIGhlaWdodD0iMTYiIHZpZXdCb3g9IjAgMCAxNyAxNiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTguODI1MiAwQzQuNDA2NDUgMCAwLjgyNTE5NSAzLjU4MTI1IDAuODI1MTk1IDhDMC44MjUxOTUgMTIuNDE4NyA0LjQwNjQ1IDE2IDguODI1MiAxNkMxMy4yNDM5IDE2IDE2LjgyNTIgMTIuNDE4NyAxNi44MjUyIDhDMTYuODI1MiAzLjU4MTI1IDEzLjI0MzkgMCA4LjgyNTIgMFpNOC44MjUyIDRDOS4zNzczOCA0IDkuODI1MiA0LjQ0NzgxIDkuODI1MiA1QzkuODI1MiA1LjU1MjE5IDkuMzc3MzggNiA4LjgyNTIgNkM4LjI3MzAxIDYgNy44MjUyIDUuNTUzMTIgNy44MjUyIDVDNy44MjUyIDQuNDQ2ODggOC4yNzIwNyA0IDguODI1MiA0Wk0xMC4wNzUyIDEySDcuNTc1MkM3LjE2MjcgMTIgNi44MjUyIDExLjY2NTYgNi44MjUyIDExLjI1QzYuODI1MiAxMC44MzQ0IDcuMTYxMTMgMTAuNSA3LjU3NTIgMTAuNUg4LjA3NTJWOC41SDcuODI1MkM3LjQxMTEzIDguNSA3LjA3NTIgOC4xNjQwNiA3LjA3NTIgNy43NUM3LjA3NTIgNy4zMzU5NCA3LjQxMjcgNyA3LjgyNTIgN0g4LjgyNTJDOS4yMzkyNiA3IDkuNTc1MiA3LjMzNTk0IDkuNTc1MiA3Ljc1VjEwLjVIMTAuMDc1MkMxMC40ODkzIDEwLjUgMTAuODI1MiAxMC44MzU5IDEwLjgyNTIgMTEuMjVDMTAuODI1MiAxMS42NjQxIDEwLjQ5MDggMTIgMTAuMDc1MiAxMloiIGZpbGw9IiM4NzhGQTIiLz4KPC9zdmc+Cg==)

Status:Connected via Attackbox Show Split ViewTarget machine

![Image 5](data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTciIGhlaWdodD0iMTYiIHZpZXdCb3g9IjAgMCAxNyAxNiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTguODI1MiAwQzQuNDA2NDUgMCAwLjgyNTE5NSAzLjU4MTI1IDAuODI1MTk1IDhDMC44MjUxOTUgMTIuNDE4NyA0LjQwNjQ1IDE2IDguODI1MiAxNkMxMy4yNDM5IDE2IDE2LjgyNTIgMTIuNDE4NyAxNi44MjUyIDhDMTYuODI1MiAzLjU4MTI1IDEzLjI0MzkgMCA4LjgyNTIgMFpNOC44MjUyIDRDOS4zNzczOCA0IDkuODI1MiA0LjQ0NzgxIDkuODI1MiA1QzkuODI1MiA1LjU1MjE5IDkuMzc3MzggNiA4LjgyNTIgNkM4LjI3MzAxIDYgNy44MjUyIDUuNTUzMTIgNy44MjUyIDVDNy44MjUyIDQuNDQ2ODggOC4yNzIwNyA0IDguODI1MiA0Wk0xMC4wNzUyIDEySDcuNTc1MkM3LjE2MjcgMTIgNi44MjUyIDExLjY2NTYgNi44MjUyIDExLjI1QzYuODI1MiAxMC44MzQ0IDcuMTYxMTMgMTAuNSA3LjU3NTIgMTAuNUg4LjA3NTJWOC41SDcuODI1MkM3LjQxMTEzIDguNSA3LjA3NTIgOC4xNjQwNiA3LjA3NTIgNy43NUM3LjA3NTIgNy4zMzU5NCA3LjQxMjcgNyA3LjgyNTIgN0g4LjgyNTJDOS4yMzkyNiA3IDkuNTc1MiA3LjMzNTk0IDkuNTc1MiA3Ljc1VjEwLjVIMTAuMDc1MkMxMC40ODkzIDEwLjUgMTAuODI1MiAxMC44MzU5IDEwLjgyNTIgMTEuMjVDMTAuODI1MiAxMS42NjQxIDEwLjQ5MDggMTIgMTAuMDc1MiAxMloiIGZpbGw9IiM4NzhGQTIiLz4KPC9zdmc+Cg==)

Status:OffStart Machine **Note:** For a better experience, open the AttackBox in a separate tab (full-screen option).

### **Answer the questions below**

**Question:**

_Answer:_

     No answer needed

---

## Task 2 | Important Concepts

Encoding and Decoding Encoding is a method to transform data to ensure compatibility between different systems. It differs from encryption in purpose and process.

      Encoding Encryption     **Purpose**  Compatibility

Usability Security
Confidentiality **Process** Standardized Algorithm + Key **Security** No Yes **Speed** Fast Slow **Examples** Base64 TLS Decoding is the process of converting encoded data back to its original, readable, and usable form.

CyberChef Overview [CyberChef](https://cyberchef.io/) is also known as the Cyber Swiss Army Knife. Ready to cook some recipes?

    Area Description     Operations Repository of diverse CyberChef capabilities   Recipe Fine-tune and chain the operations area   Input Here you provide the input for your recipe   Output Here is the output of your recipe    Simple Example Try your first recipe:

- Open either the online [CyberChef](https://cyberchef.io/) version in your regular browser, or use the offline CyberChef version available in the bookmarks section of the AttackBox. Drag and drop the `To Base64` operation from the **Operations** area on the left side to the **Recipe** area in the center, and add `IamRoot` into the **Input** area.

- Add another operation, `From Base64`, to show the initial input again, showcasing chain operations.

  **Note:** You can enable/disable an operation in the recipe by toggling the middle button on the right of the operation.

![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1762941123967.png)

Congratulations! You took the first steps to become a master Chef.

Inspecting Web Pages Besides the rendered content of a web page, your browser usually receives and can show additional information.

For this challenge, you will get the chance to have a deeper look at that information and put it to good use.

To do this, depending on your browser, you can access the functionality as shown below:

    Browser Menu path     Chrome `More tools` > `Developer tools`   Firefox `Menu` (☰) > `More tools` > `Web Developer Tools`   Microsoft Edge `Settings and more (...)` > `More tools` > `Developer tools`   Opera `Developer` > `Developer tools`   Safari `Develop` > `Show Web Inspector` (Requires enabling the "Develop" menu in `Preferences` > `Advanced`)     **Note:**  For a better experience, you can reposition the console on the right side of the browser. Look for the three dots on the right side of the console.

![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1762941124118.png)

### **Answer the questions below**

**Question:**

_Answer:_

     No answer needed

---

## Task 3 | First Lock - Outer Gate

Key Information If not already, start the target machine, give it a few minutes to boot up, and then, from the AttackBox, you can access the web app at `http://MACHINE_IP:8080`.

McSkidy revealed some vital clues in his message. You will have to leverage any useful piece of information in order to break the locks.

Below are key points to look out for:

- **Chat is Base64 encoded** . Try decoding this in CyberChef. This will be leveraged to extract useful information from the guards. Be aware that from Lock 3 onwards, the guards will take a longer time to respond.

![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1761561410887.png)

- **Guard name** . This logic will persist throughout the levels. Make sure to note down the guard’s name for each level.

![Image 9](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1761136162115.png)

- **Headers** . Again, inspecting the page but switching to the ‘_Network_ ’ tab this time. Make sure to refresh the page once after switching to this tab and select the first response.

![Image 10](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1764069898747.png)

- **Login Logic** . You will inspect the page and switch to the ‘_Debugger_ ’ tab. Match the lock with the respective logic. You can also find helpful comments that explain what you need to cook in CyberChef.

![Image 11](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1761136162547.png)

![Image 12](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763631263323.png)

First Lock - Outer Gate Ok, it’s time to siege the fortress. Ready?

1. First, identify the guard name and encode it to Base64. You will use this as the username input.

2. Next, using the information from the page headers, identify the magic question and encode it in Base64 as well.

![Image 13](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763622327932.png)

3. Use the encode magic question in the chat. The guard will answer with the encoded level password.

4. Now, switch to the ‘_Debugger_ ’ tab and identify the login logic. In this case, the password is encoded to Base 64.

![Image 14](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763622523221.png)

5. By decoding the answer from the guard, you will have the plaintext password.

6. Use the encoded username and plaintext password to log in.

Excellent work! One lock is down, and only four remain to be broken.

### **Answer the questions below**

**Question:**

_Answer:_

     Iamsofluffy

---

## Task 4 | Second Lock - Outer Wall

![Image 15](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763631294782.png)

Second Lock - Outer Wall Excellent job breaking that first level.

This level nudges the difficulty up a little bit, but don’t worry, you will figure it out. Let’s go!

1. Again, identify the guard's name and save the encoded output for later.

2. Then, extract and encode the magic question and retrieve the encoded password from the guard.

![Image 16](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763623056230.png)

3. Looking again at the login logic, you see that the encoding is applied twice this time. That means you have to decode from Base64 twice.

4. Go ahead and log in with the newfound password and the saved username.

![Image 17](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763623056841.png)

You are getting closer to securing an escape route; only three locks remain. Keep up the good work.

### **Answer the questions below**

**Question:**

_Answer:_

     Itoldyoutochangeit!

---

## Task 5 | Third Lock - Guard House

![Image 18](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763631323714.png)

Third Lock - Guard House So far, so good. As you saw in the previous level, the login logic begins to use chained operations.

This will be the trend for this and the following levels.

1. As always, collect all the needed information (encoded username, encoded password from the guard, XOR key).

![Image 19](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763623688692.png)

**Note:** From this lock onwards, there is no magic question, but sometimes you can ask the guard nicely to give you the password. It will still need to be decoded as per the login logic. Be aware that the guard may sometimes fall asleep or take a long time to respond (~2-3 minutes) so keeping the message short will help get the answer. Even a simple 'Password please.' will go a long way.

2. If you look at the login logic, there is a slight twist. The password is first XOR’ed with a key and then encoded to Base64.

Theory Time XOR is a popular operation that, besides the input data, also uses a key. The process involves a bitwise exclusive OR between the data and key.

![Image 20](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763638274313.png)

You might ask, “_Ok, but how do I reverse this?_ ”. Well, skipping the long math explanation, XOR has a magic property: when you XOR the result with the key again, the new result will be the initial data. Go ahead, try this in CyberChef. Put two XOR operations one after another, use the same key for both, and the output should be identical.

![Image 21](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763536921553.png)

3. With this newfound knowledge, build the needed recipe to find the plaintext password.

![Image 22](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763625972684.png)

![Image 23](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1764064441038.png)

4. Use the credentials and unlock the next level.

### **Answer the questions below**

**Question:**

_Answer:_

     BugsBunny

---

## Task 6 | Fourth Lock - Inner Castle

![Image 24](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763632423450.png)

Fourth Lock - Inner Castle We are almost there. In this level, Sir BreachBlocker III throws you a curveball. Let’s see how to tackle this.

1. But first, go ahead and look at the login logic as before. We will not be needing header information for this one.

![Image 25](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763626852157.png)

2. After asking the guard for the password and looking at it's reply, it seems a bit odd. At the same time, the login logic shows the use of a MD5 hash.

![Image 26](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763626851107.png)

Theory Time MD5, or Message-Digest Algorithm 5, is a cryptographic algorithm that produces a fixed-size hash value. While this is supposed to be a one-way function, meaning you cannot reverse it, precomputed hashes can be leveraged to identify the input.

3. Putting the two together, the plaintext password is passed through MD5, and you have the hash. This looks like a job for [CrackStation](https://crackstation.net/).

4. Go ahead and open the site and paste the hash to retrieve the password.

![Image 27](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763626852611.png)

5. Use the credentials and advance to the final level.

Fantastic. One more lock and you will ensure McSkidy has safe passage and escapes.

### **Answer the questions below**

**Question:**

_Answer:_

     passw0rd1

---

## Task 7 | Fifth Lock - Prison Tower

![Image 28](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763631352514.png)

Fifth Lock - Prison Tower Ready for the final hurdle?

As the defenses weaken, you receive another hidden message from McSkidy:

_“I can see you are ready to break the last lock. Be aware that Sir BreachBlocker III implemented different mechanisms for the last lock, which change occasionally. Make sure you match the correct approach when decoding the password.”_

That sounds tricky, but do not despair. You will find a way.

1. Let’s start. Extract the information as before, noting down the encoded guard name.

![Image 29](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763627625991.png)

2. Additionally, note the recipe ID from the header and match the corresponding login logic. Below is a quick cheat sheet for decoding each recipe.

    Recipe ID Reverse Logic 1 From Base64 ⇒ Reverse ⇒ ROT13 2 From Base64 ⇒ From Hex ⇒ Reverse 3 ROT13 ⇒ From Base64 ⇒ XOR(extracted key) 4 ROT13 ⇒ From Base64 ⇒ ROT47 3. Build the reverse recipe with CyberChef and extract the final password.

Finally, the last lock has been breached, and you provided a safe path for McSkidy to escape.

### **Answer the questions below**

**Question:**

_Answer:_

     51rBr34chBl0ck3r

**Question:**

_Answer:_

     THM{M3D13V4L_D3C0D3R_4D3P7}

---

## Task 8 | Epilogue

![Image 30](https://tryhackme-images.s3.amazonaws.com/user-uploads/68baea2454c82afe90fd7020/room-content/68baea2454c82afe90fd7020-1763536556206.png)

_As McSkidy passed by the Inner Castle, she heard a thunderous voice: “Why should Christmas have all the fun?”_

_McSkidy managed to get back to Wareville just in time as TBFC was about to be hit by another disaster._

### **Answer the questions below**

**Question:**

_Answer:_

     No answer needed

**Question:**

_Answer:_

     No answer needed

---
