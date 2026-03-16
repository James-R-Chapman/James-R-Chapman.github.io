---
title:      "Phishing Emails in Action"
date:       2025-03-02T00:00:00-05:00
tags:       ["tryhackme"]
identifier: "20250302T000007"
Hubs: "TryHackMe/SOC Level 1/Phishing"
urls: (https://tryhackme.com/room/phishingemails2rytmuv)
id: 6c0a2746-0899-4a14-b6fb-76fffad21ebe
---

# Phishing Emails in Action

# Task 1 | Introduction

Now that we covered the basics concerning emails in [Phishing Emails 1](http://tryhackme.com/jr/phishingemails1tryoe), let's dive right into actual phishing email samples.

Each email sample showcased in this room will demonstrate different tactics used to make the phishing emails look legitimate. The more convincing the phishing email appears, the higher the chances the recipient will click on a malicious link, download and execute the malicious file, or even send the prince of some country a wire transfer.

Warning: The samples throughout this room contain information from actual spam and/or phishing emails. Proceed with caution if you attempt to interact with any IP, domain, attachment, etc.

### **Answer the questions below**

**Question:** Read the above.

*Answer:* 

     No answer needed

---

# Task 2 | Cancel your PayPal order

The email sample in this task will highlight the following techniques:

- **Spoofed email address**
- **URL shortening services**
- **HTML to impersonate a legitimate brand**

Here are some quick observations about this email sample:

1. This is an unusual email recipient address. This is not the email address associated with the Yahoo account.
2. This mismatch should immediately stand out. The sender's details (service@paypal.com) don't match the sender's email address (gibberish@sultanbogor.com).
3. The subject line hints that you made a purchase or a transaction of some sort. If you don't recall this account, then it will grab your attention. This social engineering tactic is to prompt you to interact with the email with haste.

![Image 1](https://assets.tryhackme.com/additional/phishing2.0/email1-details.png)

Now let's look at the contents of the email body.

**Email Body Text (Image 1)** :

![Image 2](https://assets.tryhackme.com/additional/phishing2.0/email-body-1.png)

**The second half of the same email body text (Image 2)** :

![Image 3](https://assets.tryhackme.com/additional/phishing2.0/email-body-2b.png)

The email body compliments the sender information and subject line. The email was designed as a legitimate email from PayPal.

There aren't any attachments associated with this email. The only interactive element in this email is the **Cancel the order**  button/link.

Let's investigate that further by reviewing the raw HTML source for the email...

**Email Hyperlinks** :

![Image 4](https://assets.tryhackme.com/additional/phishing2.0/cancel-order.png)

The link uses URL shortening services. It is not a good idea to click on the link if you don't know where the link is taking you.

Luckily, there are online tools that we can use to let us know the destination of a shortened URL.

![Image 5](https://assets.tryhackme.com/additional/phishing2.0/email1-url-shortener.png)

Strange. This link redirects to google.com.

**Note** : Tools to expand shortened URLs will be discussed in the Phishing Emails 3 room.

### **Answer the questions below**

**Question:** What phrase does the gibberish sender email start with?

*Answer:* 

     noreply

---

# Task 3 | Track your package

This email sample will highlight the following techniques:

1. **Spoofed email address**
2. **Pixel tracking**
3. Link manipulation

Here are some quick observations about this email sample:

1. The email is tailored to appear that it's sent from a mail distribution center of some sort.
2. The subject line adds to the pretense with a 'tracking number.'
3. The link in the email body matches the subject line.

![Image 6](https://assets.tryhackme.com/additional/phishing2.0/email2-details.png)

**Note** : In this email sample, Yahoo blocked the images from automatically loading. Any guesses as to why?

Typically one can hover the cursor over a link to see where the link is pointing to, but in this sample, that technique won't work because Yahoo disabled links in the email. We can look at the raw source code for the email and find out.

**Email Hyperlinks** :

![Image 7](https://assets.tryhackme.com/additional/phishing2.0/email2-hyperlinks.png)

Here we see an image file, and it's explicitly called **Tracking.png** . These trackers send information back to the spammer's server.

There are many reasons for spammers to embed tracking pixels (very small images) into their spam emails. To read more about this concept, refer to this post on The Verge [here](https://www.theverge.com/22288190/email-pixel-trackers-how-to-stop-images-automatic-download).

Now we can understand why Yahoo automatically blocked the images in this email. Many email providers do the same.

Back to the hyperlink, the link is pointing to a shady-looking domain. The only distribution center this domain can be associated with is malware, but further analysis is the only way to confirm that definitely.

### **Answer the questions below**

**Question:** What is the root domain for each URL? Defang the URL.

*Answer:* 

     devret[.]xyz

---

# Task 4 | Select your email provider to view document

This email sample will highlight the following techniques:

- Urgency
- HTML to impersonate a legitimate brand
- Link manipulation
- Credential harvesting
- Poor grammar and/or typos

Let's take a closer look...

![Image 8](https://assets.tryhackme.com/additional/phishing2.0/email6-details2.png)

Here are some quick observations about this email sample:

1. The email was sent on Thursday, July 15th, 2021.
2. A sense of urgency is introduced in this email. Notice that the link to download the fax document expires on the same day.
3. There is an action to perform. In this case, a button to download the fax.

![Image 9](https://assets.tryhackme.com/additional/phishing2.0/email6-phish1b.png)

The above image shows the victim is redirected to a page created to pass as OneDrive. Notice that the URL is not anything Microsoft-related.

There are two more links for the victim to interact with. The victim has to click either button to obtain the fax document that is set to expire.

![Image 10](https://assets.tryhackme.com/additional/phishing2.0/email6-phish2b.png)

The victim is directed to yet another site. This one was crafted to resemble Adobe. Again, notice the URL. It doesn't look like it's related to Adobe.

Also, notice the page title in the tab. It's called "Share Point Online", which is a Microsoft product. There are a couple of grammatical errors as well.

The victim has options to sign in with the email provider of their choice.

![Image 11](https://assets.tryhackme.com/additional/phishing2.0/email6-phish3.png)

Our victim chose to log in with Outlook because, per the instructions, "*To read the document, please enter with the valid email credentials that this file was sent to.* "; the email was viewed in Outlook.

![Image 12](https://assets.tryhackme.com/additional/phishing2.0/email6-phish4.png)

In this sample, we can tell that fake credentials were entered, but even if the victim would have entered valid credentials, the error message would be the same. This scenario happens because the victim is not really authenticating to an email provider. Instead, the credentials that were entered now reside on the criminal's server. The criminal's objective to harvest credentials has been met.

Lastly, notice more grammatical errors. All this work they put into this, you would think they would run a spell check.

This email sample was obtained from Any Run. If you wish to interact with the email and see the full analysis, refer to the link below.

- Analysis: [https://app.any.run/tasks/12dcbc54-be0f-4250-b6c1-94d548816e5c/#](https://app.any.run/tasks/12dcbc54-be0f-4250-b6c1-94d548816e5c/#)

### **Answer the questions below**

**Question:** This email sample used the names of a few major companies, their products, and logos such as OneDrive and Adobe. What other company name was used in this phishing email?

*Answer:* 

     Citrix

---

# Task 5 | Please update your payment details

This email sample will highlight the following techniques:

- Spoofed email address
- Urgency
- HTML to impersonate a legitimate brand
- Poor grammar and/or typos
- **Attachments**

Here are some quick observations about this email sample:

1. This email is made to appear that it's from Netflix Billing, but the sender address is z99@musacombi.online.
2. Here is the element of urgency. The account was suspended, so the victim must act quickly.
3. There is more of this sense of urgency in the email body.

![Image 13](https://assets.tryhackme.com/additional/phishing2.0/email3-details.png)

Also, notice the different misspellings of the word Netflix. Not sure what was the purpose of that.

Typically, you'll see this technique when it comes to [typosquatting](https://www.csoonline.com/article/3600594/what-is-typosquatting-a-simple-but-effective-attack-technique.html), but that wasn't the case here.

![Image 14](https://assets.tryhackme.com/additional/phishing2.0/email3-typos.png)

Ok, here is the meat and potatoes of this email. Apparently, the victim needs to open the attachment (PDF) to update their Netflix account.

![Image 15](https://assets.tryhackme.com/additional/phishing2.0/email3-body-attachment.png)

Notice the phone number for 'Netflix'. At first glance, that is an unusual phone number to send to a US-based victim.

![Image 16](https://assets.tryhackme.com/additional/phishing2.0/email3-attachment2.png)

The attachment contains an embedded link titled 'Update Payment Account'.

We'll look at this email attachment in closer detail in the upcoming Phishing Emails 3 room.

### **Answer the questions below**

**Question:** What should users do if they receive a suspicious email or text message claiming to be from Netflix?

*Answer:* 

     forward the message to phishing@netflix.com

---

# Task 6 | Your recent purchase

This email sample will highlight the following techniques:

- Spoofed email address
- Recipient is BCCed
- Urgency
- Poor grammar and/or typos
- Attachments

Here are some quick observations about this email sample:

1. This email is made to appear that it's from Apple Support, but the sender's address is gibberish@sumpremed.com.
2. This email wasn't sent directly to the victim's inbox but rather BCCed ([Blind Carbon Copy](https://www.technology.pitt.edu/help-desk/how-to-documents/using-blind-carbon-copy-bcc-feature-protect-privacy-email-addresses)). The recipient email looks like another spoofed email to appear as a legitimate Apple email address.
3. Here is the element of urgency. Action is required on behalf of the victim.

![Image 17](https://assets.tryhackme.com/additional/phishing2.0/email5-details2.png)

There are a few noticeable typos in both the sender and recipient email addresses: **donoreply**  and **payament** .

This particular email doesn't necessarily have an email body. It's totally blank. The email simply contains an attachment.

![Image 18](https://assets.tryhackme.com/additional/phishing2.0/email5-attachment.png)

This file extension you may not be familiar to you. A .[DOT](https://www.reviversoft.com/en/file-extensions/dot) file is page layout template files associated with Microsoft Word.

![Image 19](https://assets.tryhackme.com/additional/phishing2.0/email5-attachment2.png)

The above image shows what is contained within the attachment. You can see that the file contains a large image to resemble an App Store receipt.

Notice the link contains certain keywords related to Apple: **apps**  and **ios** .

### **Answer the questions below**

**Question:** What does BCC mean?

*Answer:* 

     Blind Carbon Copy

**Question:** What technique was used to persuade the victim to not ignore the email and act swiftly?

*Answer:* 

     Urgency

---

# Task 7 | DHL Express Courier Shipping notice

This email sample will highlight the following techniques:

- Spoofed email address
- HTML to impersonate a legitimate brand
- Attachments

Here are some quick observations about this email sample:

1. The sender's email doesn't match the company that is being impersonated, which in this case is DHL.
2. The subject line gives the impression that there is a package DHL will ship for you.
3. The HTML in the email body was designed to look like it was sent from DHL.

![Image 20](https://assets.tryhackme.com/additional/phishing2.0/email4-details.png)

Looking at the source code for the email, the link to view the email as a web page doesn't contain an actual destination URL.

![Image 21](https://assets.tryhackme.com/additional/phishing2.0/email4-body-1.png)

...

![Image 22](https://assets.tryhackme.com/additional/phishing2.0/email4-body-2.png)

The only element the victim can interact with in this email is the email attachment, which, in this case is an Excel document.

![Image 23](https://assets.tryhackme.com/additional/phishing2.0/email4-attachment.png)

The image below shows what is contained within the attachment.

![Image 24](https://assets.tryhackme.com/additional/phishing2.0/email4-attachment2.png)

The attachment runs a payload that throws an error.

![Image 25](https://assets.tryhackme.com/additional/phishing2.0/email4-attachment3.png)

We'll look at this email attachment in closer detail in the upcoming Phishing Emails 3 room.

### **Answer the questions below**

**Question:** What is the name of the executable that the Excel attachment attempts to run?

*Answer:* 

     regasms.exe

---

# Task 8 | Conclusion

In this room, we looked at various phishing samples.

Some of the samples shared similar techniques whereas, others introduced a new tactic for you to see and learn from.

Understanding how to detect phishing emails takes awareness training.

Visit the resources below to acquaint yourself with other signs to look out for in phishing emails.

Additional Resources:

- [https://www.knowbe4.com/phishing](https://www.knowbe4.com/phishing)[](https://www.knowbe4.com/phishing)
- [https://www.itgovernance.co.uk/blog/5-ways-to-detect-a-phishing-email](https://www.itgovernance.co.uk/blog/5-ways-to-detect-a-phishing-email)
- [https://cheapsslsecurity.com/blog/10-phishing-email-examples-you-need-to-see/](https://cheapsslsecurity.com/blog/10-phishing-email-examples-you-need-to-see/)
- [https://phishingquiz.withgoogle.com](https://phishingquiz.withgoogle.com/)[](https://phishingquiz.withgoogle.com/)

The next room in this module: [Phishing Emails 3](https://tryhackme.com/jr/phishingemails3tryoe)

### **Answer the questions below**

**Question:** Read the above.

*Answer:* 

     No answer needed

---

