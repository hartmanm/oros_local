#!/bin/bash

# Copyright (c) 2018 Michael Neill Hartman. All rights reserved.
# mnh_license@proton.me
# https://github.com/hartmanm

sudo chown m1 /media/ramdisk
sleep 2
cp -rp /media/m1/0rig_here_1/1bash.sh /media/ramdisk/1bash.sh
pkill -e 1bash
pkill -f 1bash
until `bash /media/ramdisk/1bash.sh`
do
sleep 4
done
# xterm -e /home/m1/2unix -geometry 100x80+300+300
