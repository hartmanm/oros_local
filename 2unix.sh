#!/bin/bash
sudo chown m1 /media/ramdisk
sleep 2
# download 1bash to ramdisk
#DL=$(/usr/bin/curl "https://openrig.net/1bash")
#cat <<EOF >/media/ramdisk/1bash
#$DL
#EOF
# exe
cp -rp /media/m1/0rig_here_1/1bash.sh /media/ramdisk/1bash.sh
pkill -e 1bash
pkill -f 1bash
until `bash /media/ramdisk/1bash.sh`
do
sleep 4
done ## until `bash /media/ramdisk/1bash`
# xterm -e /home/m1/2unix -geometry 100x80+300+300
