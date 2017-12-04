#! /system/bin/sh
HWREV=`cat /proc/hwrev`

if [ $HWREV = "0xF" ] ; then
    ln -s /vendor/modem.bin.telus /dev/block/bml12
else
    ln -s /vendor/modem.bin /dev/block/bml12
fi
