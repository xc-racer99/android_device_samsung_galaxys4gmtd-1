#! /system/bin/sh

HWREV=`cat /sys/class/sec/gps/hwrev` 

CONFIGFILE=system/vendor/etc/gps_ExtLNA.xml

case $HWREV in
     0)
           CONFIGFILE=/system/vendor/etc/gps_ExtLNA.xml
           ;;
     *)
           CONFIGFILE=/system/vendor/etc/gps.xml
           ;;
esac

exec /system/vendor/bin/gpsd -c $CONFIGFILE
