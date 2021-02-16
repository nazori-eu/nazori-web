+++
categories = ["Pentest", "Web"]
date = "2021-02-13"
title = "SQL basics"
type = ["posts","post"]
[ author ]
  name = "nazori"
+++


A SQL injection attack consists of insertion or “injection” of a SQL query via the input data from the client to the application.


SQL injection errors occur when:

   1. Data enters a program from an untrusted source.
   2. The data used to dynamically construct a SQL query

The main consequences are:

  *  Confidentiality: Since SQL databases generally hold sensitive data, loss of confidentiality is a frequent problem with SQL Injection vulnerabilities.
  
  *  Authentication: If poor SQL commands are used to check user names and passwords, it may be possible to connect to a system as another user with no previous knowledge of the password.
  
  *  Authorization: If authorization information is held in a SQL database, it may be possible to change this information through the successful exploitation of a SQL Injection vulnerability.
  
  *  Integrity: Just as it may be possible to read sensitive information, it is also possible to make changes or even delete this information with a SQL Injection attack.


## How to open Metasploit database
```
┌──(root💀kali)-[~]
└─# mysql -u root -h 10.0.2.4
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 22
Server version: 5.0.51a-3ubuntu5 (Ubuntu)

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| dvwa               |
| metasploit         |
| mysql              |
| owasp10            |
| tikiwiki           |
| tikiwiki195        |
+--------------------+
7 rows in set (0.001 sec)

```

* Select the database
  
```


MySQL [(none)]> use owasp10;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
MySQL [owasp10]> show tables;
+-------------------+
| Tables_in_owasp10 |
+-------------------+
| accounts          |
| blogs_table       |
| captured_data     |
| credit_cards      |
| hitlog            |
| pen_test_tools    |
+-------------------+
6 rows in set (0.001 sec)
```

* Show content of the table
  
```
MySQL [owasp10]> SELECT * FROM accounts;

+-----+----------+--------------+-----------------------------+----------+
| cid | username | password     | mysignature                 | is_admin |
+-----+----------+--------------+-----------------------------+----------+
|   1 | admin    | adminpass    | Monkey!                     | TRUE     |
|   2 | adrian   | somepassword | Zombie Films Rock!          | TRUE     |
|   3 | john     | monkey       | I like the smell of confunk | FALSE    |
|   4 | jeremy   | password     | d1373 1337 speak            | FALSE    |
|   5 | bryce    | password     | I Love SANS                 | FALSE    |
|   6 | samurai  | samurai      | Carving Fools               | FALSE    |
|   7 | jim      | password     | Jim Rome is Burning         | FALSE    |
|   8 | bobby    | password     | Hank is my dad              | FALSE    |
|   9 | simba    | password     | I am a cat                  | FALSE    |
|  10 | dreveil  | password     | Preparation H               | FALSE    |
|  11 | scotty   | password     | Scotty Do                   | FALSE    |
|  12 | cal      | password     | Go Wildcats                 | FALSE    |
|  13 | john     | password     | Do the Duggie!              | FALSE    |
|  14 | kevin    | 42           | Doug Adams rocks            | FALSE    |
|  15 | dave     | set          | Bet on S.E.T. FTW           | FALSE    |
|  16 | ed       | pentest      | Commandline KungFu anyone?  | FALSE    |
|  17 | nazori   | jeje         | lol                         | NULL     |
+-----+----------+--------------+-----------------------------+----------+
17 rows in set (0.001 sec)

```