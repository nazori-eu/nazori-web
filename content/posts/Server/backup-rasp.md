+++
categories = ["Raspberry"]
date = "2020-06-27"
slug = "Back up your Raspberry Pi"
title = "Back up your Raspberry Pi"
type = ["posts","post"]
[ author ]
  name = "nazori"
+++

Copy the SD card image
The simplest way to back up your Raspberry Pi is to copy the entire SD card as an image.

This technique is the reverse of flashing your SD card when installing an OS to it. Instead of copying an image file from your computer to the SD card, you copy the entire SD card to an image file on your computer.

This is, in fact, how image files are created in the first place.
Power down your Raspberry Pi and remove the SD card. Place it into an SD card reader and connect it to your computer.

In Windows, you back up the SD card using [Win32 Disk Imager](https://sourceforge.net/projects/win32diskimager/).

Open the program and click Yes to the security alert window. Enter C:\raspberrypi.img in the Image File text box and click Read. The SD card will be written to the image file. When it says ‘Read Successful’, you can click OK.