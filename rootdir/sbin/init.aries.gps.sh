#! /system/bin/sh
HWREV=`cat /proc/hwrev`

if [ $HWREV = "0xF" ] ; then
#   GPS_CHIPSET_STE_CG2900
#   STE: Added for CG2900 Support
#   +Scott.Re-setup permission right
    chown system:system /dev/cg2900_audio
    chmod 0770 /dev/cg2900_audio
    chown system:system /dev/cg2900_bt_audio
    chmod 0770 /dev/cg2900_bt_audio
    chown system:system /dev/cg2900_core
    chmod 0770 /dev/cg2900_core
    chown system:system /dev/cg2900_driver0
    chmod 0770 /dev/cg2900_driver0
    chown system:system /dev/cg2900_fm_audio
    chmod 0770 /dev/cg2900_fm_audio
    chown gps:system /dev/cg2900_gnss
    chmod 0770 /dev/cg2900_gnss
    chown system:system /dev/cg2900_hci_logger
    chmod 0770 /dev/cg2900_hci_logger
    chown system:system /dev/cg2900_us_ctrl
    chmod 0770 /dev/cg2900_us_ctrls

    setprop gps.variant cg2900

#   GPS_CHIPSET_STE_CG2900
#   STE: Added for CG2900 Support
#   +Scott.Re-setup permission right
    chown system:system /dev/s3c2410_serial1
    chmod 0770 /dev/s3c2410_serial1

    exit 0
fi

GPS_HWREV=`cat /sys/class/sec/gps/hwrev`

CONFIGFILE=system/vendor/etc/gps_ExtLNA.xml

case $GPS_HWREV in
     0)
           CONFIGFILE=/system/vendor/etc/gps_ExtLNA.xml
           ;;
     *)
           CONFIGFILE=/system/vendor/etc/gps.xml
           ;;
esac

exec /system/vendor/bin/gpsd-shim -c $CONFIGFILE
