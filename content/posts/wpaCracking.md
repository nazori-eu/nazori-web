+++
categories = ["Wireless attack"]
date = "2020-12-03"
title = "WPA Cracking"
type = ["posts","post"]
[ author ]
  name = "nazori"
+++

Here we will use [Aircrack-ng](https://www.aircrack-ng.org/) which is an
open-source software suite used to monitor wireless networks and "break"
the WEP and WPA keys of Wi-fi networks. The attack will take place in
several phases:

-   **Preparation** of your network card
-   **Analysis** of the Wi-fi target
-   **Capturing** a **WPA handshake** *(a connection to the Wi-fi
    network)* by disconnecting a device on the Wi-fi
-   **WPA handshake** password cracking by *bruteforce*

* * * * *

[](#preparation) Preparation
----------------------------

The first step is to activate the **monitor mode** of the network card
set up. To do this we list the available network cards with
`airmong-ng`. Open a terminal and type:\

``` {.highlight .shell}
airmon-ng
```

> If your network card does not display, it is not compatible. You have
> to buy one *(a USB Wi-fi dongle is enough)*.

In our case we see that we can use our **wlan0** network card. So we
activate the **monitor mode** with the following command::\

``` {.highlight .shell}
airmon-ng start wlan0
```

From here, the network card **wlan0** is no longer available *(you no
longer have internet)*, and a new network card appears. It can be found
by doing an `ifconfig`. In my case, it is **wlan0mon**..

[](#analysis) Analysis
----------------------

Now we can *sniff* the network packets that circulate around us with
`airodump`:\

``` {.highlight .shell}
airodump-ng wlan0mon
```

This command will find additional information on Wi-fi including:

-   the **BSSID**
-   the **CH**annel
-   the **AUTH**, the mode of authentication
-   the **ESSID**, the name of the router

Among all the lines, my network appears. Remember to write down the
information as it will be useful to us.\

``` {.highlight .plaintext}
 BSSID              PWR  Beacons    #Data, #/s  CH  MB   ENC  CIPHER AUTH ESSID

 18:D6:C7:85:7E:A0  -45        6        0    0   2  54e  WPA2 CCMP   PSK  TP-LINK_7EA0
```

[](#capturing-a-wpa-handshake) Capturing a WPA handshake
--------------------------------------------------------

A **WPA handshake** takes place when a device is connected to the Wi-fi.
Our goal is to capture one in order to recover the encrypted password.

-   sniff the Wi-fi and wait for a device to connect to the Wi-fi
-   sniff the Wi-fi and cause a disconnection and wait for the device to
    reconnect

In order to test, I will disconnect my **Blackberry** already connected
to it.

### [](#wifi-scan) Wi-fi Scan

So we scan the network with the `airodump-ng` command and options:

-   `-c` options to specify the channel
-   `--bssid`, my router's ID.
-   `w` the directory where the output files will be stored

``` {.highlight .shell}
airodump-ng -c 10 --bssid 18:D6:C7:85:7E:A0 -w tplink  wlan0mon
```

We leave this command in the background, it will produce 3 files, one of
which is of type *xml*. This is the one we are interested in because it
contains more details about the devices connected to the wi-fi. By
opening this one, we can find very easily the information of my
Blackberry. Here is an extract of the file:\

``` {.highlight .xml}
<client-mac>94:EB:CD:25:E0:C1</client-mac>
<client-manuf>BlackBerry RTS</client-manuf>
```

### [](#disconnection) Disconnection

Now that we have all the information, we will send a packet that will
**request disconnection** of my Blackberry. We use `aireplay-ng` with
the parameters:

-   `-0` to send a de-authentication signal.
-   `-a` To the BSSID of our Wi-fi.
-   `-c` The BSSID of the target
-   the network card used

``` {.highlight .shell}
aireplay-ng -0 2 -a 18:D6:C7:85:7E:A0 -c 94:EB:CD:25:E0:C1 wlan0mon
```

The device disconnects and reconnects automatically. The result is a
**WPA Handshake** which is contained in the *tplink.cpa* file.

[](#cracking) Cracking
----------------------

Now that we have obtained a packet containing the **encrypted WPA
password**, we just have to test several combinations until we find a
matching one: this is called a **bruteforce**.

### [](#the-dictionary) the dictionary

To find a password we need... passwords! You can find [multi-gigabyte
text files of the most commonly used
passwords](http://www.wirelesshack.org/wpa-wpa2-word-list-dictionaries.html).
In my case, I know that the password of my Wi-fi contains 8 digits. So
I'm going to use the `crunch` command to generate all the possible
combinations. `crunch` uses several parameters:

1.  the minimum length *(8)*
2.  the maximum length *(8)*
3.  the characters to be used *(0123...9)*

We're sending it all in a *passwords.txt* file.\

``` {.highlight .shell}
crunch 8 8 12345678 > passwords.txt
```

In a few seconds we get a file of **43046721 lines** weighing **369
MB**!!!!

### [](#the-bruteforce) The bruteforce

We're taking action. Here we're going to brute force the password. To do
this we use `aircrack-ng` which will encrypt the passwords one by one
and check if it matches the password of the network packet we captured
(Get yourself a coffee as it can be long).

To do this we use `aircrack-ng`.\

``` {.highlight .shell}
aircrack-ng -a2 -b 18:D6:C7:85:7E:A0 -w /root/Desktop/passwords.txt /root/Desktop/tplink.cap
```

And after a while::

[![Success](https://res.cloudinary.com/practicaldev/image/fetch/s--nthKMGR1--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/fynlzv1ig5di2w1tqat7.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--nthKMGR1--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/fynlzv1ig5di2w1tqat7.png)

[](#conclusion) Conclusion
--------------------------

Through this little test we see that it is very easy to "crack" a Wi-fi
with a WPA password. The tools at our disposal are easy to access and no
specific hardware is required. However by applying some simple rules we
can avoid this kind of risk.

Remember, the password used was only 8 numeric characters. The number of
combinations fit into a 380 MB file. If the password had included
alphabetic characters, the dictionary would have exceeded the terabyte.
The bruteforce would certainly have lasted several weeks.

So by applying a more complex password, we reduce the risk. By changing
it regularly, it is not possible to crack the combination quickly
enough.

Furthermore it is possible to adapt the wi-fi signal so that it is not
visible in the whole building.

As soon as possible, use the Ethernet cable, which is still the most
secure solution.

