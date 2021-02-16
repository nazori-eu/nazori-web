+++
categories = ["Raspberry", "Server"]
date = "2020-12-01"
title = "WEP Cracking"
type = ["posts","post"]
[ author ]
  name = "nazori"
+++



### From charlesreid1 {#siteSub}

This page will walk through a WEP attack procedure using
[Aircrack](/wiki/Aircrack "Aircrack") on Kali Linux. I tested this out
on my home router by switching its encryption to WEP, and I had cracked
the WEP passkey a whopping 3 minutes later. Here's how.

Related: WEP cracking without any connected clients [Aircrack/WEP
Cracking No
Clients](/wiki/Aircrack/WEP_Cracking_No_Clients "Aircrack/WEP Cracking No Clients")

First I'll walk you through the need-to-know basics. Then we'll dive
into some command line on Kali and see how to do this.

Contents
--------

- [The Background](#the-background)
  - [Wireless Encryption](#wireless-encryption)
  - [Weakness 1: WEP](#weakness-1-wep)
  - [Weakness 2: Router Requests](#weakness-2-router-requests)
- [The Hardware](#the-hardware)
- [The Software](#the-software)
  - [Kali](#kali)
  - [Wireless](#wireless)
  - [Aircrack](#aircrack)
- [The Procedure](#the-procedure)
  - [Set Your Router to WEP](#set-your-router-to-wep)
  - [Check Your Wireless Devices](#check-your-wireless-devices)
  - [Switch Wireless Device to Monitor Mode](#switch-wireless-device-to-monitor-mode)
    - [Kali 2.x](#kali-2x)
    - [Kali 1.x](#kali-1x)
  - [Scan Networks](#scan-networks)
  - [Sheep Connects to the Network](#sheep-connects-to-the-network)
  - [Start the Attack](#start-the-attack)
    - [Window 1: Monitor Traffic on Network](#window-1-monitor-traffic-on-network)
    - [Window 2: Increase Network Traffic with Spoofed Packets](#window-2-increase-network-traffic-with-spoofed-packets)
    - [Window 3: Crack the WEP Passphrase](#window-3-crack-the-wep-passphrase)
- [Conclusion](#conclusion)
        Mode](#Switch_Wireless_Device_to_Monitor_Mode)
        -   [4.3.1 Kali 2.x](#Kali_2.x)
        -   [4.3.2 Kali 1.x](#Kali_1.x)
    -   [4.4 Scan Networks](#Scan_Networks)
    -   [4.5 Sheep Connects to the
        Network](#Sheep_Connects_to_the_Network)
    -   [4.6 Start the Attack](#Start_the_Attack)
        -   [4.6.1 Window 1: Monitor Traffic on
            Network](#Window_1:_Monitor_Traffic_on_Network)
        -   [4.6.2 Window 2: Increase Network Traffic with Spoofed
            Packets](#Window_2:_Increase_Network_Traffic_with_Spoofed_Packets)
        -   [4.6.3 Window 3: Crack the WEP
            Passphrase](#Window_3:_Crack_the_WEP_Passphrase)
-   [5 Conclusion](#Conclusion)

The Background
==============

Wireless Encryption
-------------------

When you configure your home router, you've got a myriad of different
options for your router security protocol. Some of these link into
business systems, some are for home routers, and a few are marked as
"less secure." (This tutorial will show you precisely why!) Each of
these different security protocols is simply a way for the traffic
that's being sent between the router and your computer to be encrypted,
so that no one else can read it. But as with any cryptosystem, the more
information (wireless packets) an attacker has, the better able they are
to attack the encryption. The less sophisticated that encryption, the
less information the attacker needs.

Weakness 1: WEP
---------------

With WEP 64 bit, the passphrase is a five-character key - pretty easy to
crack. This means an attacker can listen to traffic on the network, and
even though it's encrypted, still use it to determine the passphrase by
brute force.

The simplicity of the WEP security protocol is the first weakness that
this attack takes advantage of.

Weakness 2: Router Requests
---------------------------

While the WEP encryption protocol is pretty easy to crack, it requires a
lot of packets - a LOT of packets - so by itself, the first weakness
isn't very useful, since it might still take days just to gather enough
information to crack the passphrase.

Enter weakness number two: even if you're not on a network, you can
still send packets to the router. By spoofing the MAC address of a
device that's already connected to the network, you can confuse the
router by grabbing a packet, duplicating it, and sending a flood of
these duplicate packets "from" a device on the target computer (actually
sent from your computer). The router will then respond to that flood of
packets with a flood of its own response packets. Since all of these
packets are all encrypted, you've just tricked the router into giving
you a much faster source of encrypted packets with which to crack the
WEP passphrase.

The Hardware
============

You'll need three components for this attack: a target router running
WEP encryption, a laptop running the attack on Kali, and a third party
sheep (client) that will connect to the WEP network and make this attack
possible.

The Software
============

Kali
----

As mentioned above, for this attack you'll need a device running
[Kali](/wiki/Kali "Kali") Linux. The steps for putting your wireless
card in monitoring mode are slightly different between Kali 1 and Kali
2.

Wireless
--------

You'll also need a working wireless network device. Based on my many
[Kali](/wiki/Kali "Kali") adventures in wireless USB dongle land, I
recommend Panda brand wireless USB adapters, and using the wicd network
manager (do not use the built-in Gnome Network Manager!).

Aircrack
--------

This attack will utilize Aircrack, which comes with Kali Linux (it's one
of the top 10 Kali programs!).

[![KaliTop10.png](https://charlesreid1.com/w/images/thumb/0/01/KaliTop10.png/500px-KaliTop10.png)](https://charlesreid1.com/wiki/File:KaliTop10.png)

The Procedure
=============

Set Your Router to WEP
----------------------

The first step is to change your router's settings so that it uses the
WEP security protocol.

Check Your Wireless Devices
---------------------------

Once you've got your WEP wireless network, open up your Kali computer.
You can check the wireless devices available:

    $ iwconfig

Since I was running Kali on a MacBook, I had a built-in wireless device
`wlan0` from Broadcom that's a closed-source piece of shite, and I had a
Panda Wireless USB dongle `wlan2`.

Switch Wireless Device to Monitor Mode
--------------------------------------

The next step is to use Aircrack to put your wireless card into
monitoring mode. You can also change your MAC before bringing the device
online.

### Kali 2.x

    $ iwconfig
    $ ifconfig wlan0 down
    $ macchanger -r wlan0 # optional
    $ iwconfig wlan0 mode monitor
    $ ifconfig wlan0 up
    $ airodump-ng wlan0

Your monitoring device will still be named `wlan0` (you can change the
last command to call it `wlan0mon` if you want).

Now we can scan available networks and find our WEP router.

### Kali 1.x

    $ airmon-ng
    $ ifconfig wlan2 down
    $ macchanger -r wlan2 # optional
    $ ifconfig wlan2 up
    $ airmon-ng start wlan2
    $ airodump-ng wlan2

This may issue some warnings. What this command will do is drop your
`wlan2` device and replace it with a `wlan2mon` device. From this point
forward, we'll be issuing commands using that `wlan2mon` device.

Now we can scan available networks and find our WEP router.

Scan Networks
-------------

Now we'll scan available networks with Aircrack:

    $ airodump-ng wlan2mon

This will give us a list of wireless access points, their SSIDs, their
channels, and their MAC addresses. This is precisely what we'll need to
attack our WEP router.

Sheep Connects to the Network
-----------------------------

Before or while you are monitoring the network, you will have a new node
connect to the network - the third party you're connecting. Suppose it's
a hapless sheep streaming Pandora. The sheep joins the WEP network, and
packet traffic begins.

Start the Attack
----------------

Now you've got your target router's MAC address and channel number, and
you have someone on the network sending packets. You're ready to perform
the attack.

The attack will consist of packets sent to the sheep who joined the
network and is listening to some music. These packets will be fake
deauthorization packets. The sheep will think it has been kicked off the
network and will re-send its credentials to anyone listening.

You'll be opening a couple of windows on your Kali box.

### Window 1: Monitor Traffic on Network

In window number 1, start monitoring the traffic happening on the router
with BSSID AA:BB:CC:DD:EE on channel XX:

    $ airodump-ng -d AA:BB:CC:DD:EE -c XX -w aircrack_output wlan2mon

alternatively,

    $ airodump-ng --bssid AA:BB:CC:DD:EE --channel XX -w aircrack_output wlan2mon

which should result in something like this:

[![AircrackAirodump.png](https://charlesreid1.com/w/images/thumb/3/3e/AircrackAirodump.png/500px-AircrackAirodump.png)](https://charlesreid1.com/wiki/File:AircrackAirodump.png)

Let's break that command down:

    airodump-ng

This program listens to packet traffic on the network and dumps it all
into a `.cap` capture file. This is the raw packet dump that you'll use
to crack the WEP passphrase. Type `man airodump-ng` for help.

    -d AA:BB:CC:DD:EE
    --bssid AA:BB:CC:DD:EE

This is the MAC address of the router that you're targeting. Since there
may be multiple wireless networks around, airodump-ng needs to know what
wireless traffic to capture. This lets it know to capture all traffic
involving the base station with this MAC address.

    -c XX
    --channel XX

Here we specify the channel number that we found using `airmon-ng`.
Should be an integer from 1-12.

    -w aircrack_output

This will dump the results of our packet capture to
aircrack\_output-01.cap (and will increment the file number each time
this command is run).

    wlan2mon

This is the name of our wireless device.

The output of this command is refreshed every few seconds. As new
devices join the network, they'll show up on this screen, as will
statistics about their packet traffic.

Here's a network with no traffic and no clients connected:

[![AircrackAirodumpNoClient.png](https://charlesreid1.com/w/images/thumb/b/b2/AircrackAirodumpNoClient.png/500px-AircrackAirodumpNoClient.png)](https://charlesreid1.com/wiki/File:AircrackAirodumpNoClient.png)

and here's the same network, but with a connected client:

[![AircrackAirodumpClient.png](https://charlesreid1.com/w/images/thumb/7/75/AircrackAirodumpClient.png/500px-AircrackAirodumpClient.png)](https://charlesreid1.com/wiki/File:AircrackAirodumpClient.png)

### Window 2: Increase Network Traffic with Spoofed Packets

The second stage of this attack involves sending spoofed packets. These
packets look like they're coming from the device that's connected - but
they'll actually come from the Kali computer that's carrying out the
attack. The router responds to these spoofed packets as though they're
real, flooding the network with traffic and giving us the increase in
traffic that we need to sniff out the WPA passphrase.

To do this, we need two pieces of information: the MAC address of the
router, and the MAC address of the client that we're spoofing.

The first is easy: we already have the MAC address of the router.

The second piece of information will show up in the `airodump-ng`
command window, where we'll see our client show up when they connect to
the network. Their MAC address will be shown.

Once we have our information, we run the command:

    $ aireplay-ng -3 -b AA:BB:CC:DD:EE -h AB:BC:CD:DE:EF wlan2mon

This spoofs packets to look like they're coming from AB:BC:CD:DE:EF and
sends them to AA:BB:CC:DD:EE. It then floods the router with these fake
packets, and forces the router to respond with its own flood of packets,
giving Aircrack more information to work with when trying to crack the
passphrase.

[![AircrackAireplay.png](https://charlesreid1.com/w/images/thumb/a/a4/AircrackAireplay.png/500px-AircrackAireplay.png)](https://charlesreid1.com/wiki/File:AircrackAireplay.png)

### Window 3: Crack the WEP Passphrase

Now, we wait a few minutes for `aireplay-ng` to do its thing and for
`airodump-ng` to capture the results.

Once you have enough frames, in a third window, you'll crack the
passphrase using the network capture `.cap` file generated by
`airodump-ng`.

    $ aircrack-ng aircrack_output-01.cap

and you should see the resulting WEP passphrase printed out in plain
text!

[![AircrackCrackWEP.png](https://charlesreid1.com/w/images/thumb/a/a4/AircrackCrackWEP.png/500px-AircrackCrackWEP.png)](https://charlesreid1.com/wiki/File:AircrackCrackWEP.png)

There's my test passphrase: "billy"

Conclusion
==========

This was a warm-up exercise for me to learn some network spelunking and
figure out how to use Aircrack on Kali.

This is part of the [Kali Top 10](https://charlesreid1.com/wiki/Kali_Top_10 "Kali Top 10") page,
where I'm assembling notes for each of the top 10 Kali tools.
