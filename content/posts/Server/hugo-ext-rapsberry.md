+++
categories = ["Raspberry", "Hugo"]
date = "2020-07-05"
title = "Hugo extended on Raspberry Pi"
type = ["posts","post"]
[ author ]
  name = "nazori"
+++

 ## Enable snaps on Raspberry Pi and install Hugo

Snaps are applications packaged with all their dependencies to run on all popular Linux distributions from a single build. They update automatically and roll back gracefully.

Snaps are discoverable and installable from the Snap Store, an app store with an audience of millions.

    $ sudo apt update
    $ sudo apt install snapd

    $ sudo reboot

    $ sudo snap install hugo

This way you will get the extended version of Hugo by default. The extended version is needed for some themes that use scss.