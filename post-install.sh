#!/tmp/busybox sh
#
# Post-install script for Galaxy S 4G devices
# (c) 2016 xc-racer99
#
HWREV=`/tmp/busybox cat /proc/hwrev`

check_mount() {
    if ! /tmp/busybox grep -q $1 /proc/mounts ; then
        /tmp/busybox mkdir -p $1
        /tmp/busybox umount -l $2
        if ! /tmp/busybox mount -t $3 $2 $1 ; then
            /tmp/busybox echo "Cannot mount $1."
            exit 1
        fi
    fi
}

is_telus_galaxys4g() {
    if /tmp/busybox test -e /proc/hwrev ; then
        if [ $HWREV = "0xF" ] ; then
            return 0
        else
            return 1
        fi
    fi

    MODEL=`getprop ro.product.model`
    if [ $MODEL = "SGH-T959P" ] ; then
        return 0
    else
        return 1
    fi

    # if we got here, then we're a T959V as a T959P won't get here
    return 1
}

set_log() {
    rm -rf $1
    exec >> $1 2>&1
}

set -x
export PATH=/:/sbin:/system/xbin:/system/bin:/tmp:$PATH

# everything is logged into /mnt/sdcard/aries_post-install.log
set_log /sdcard/aries_post-install.log

# make sure /system is mounted
check_mount /system /dev/block/mtdblock2 yaffs2

if is_telus_galaxys4g ; then
    /tmp/busybox echo "This is a T959P, setting up proper files"

    # rename T959P-specific files
    /tmp/busybox mv /system/lib/libclientgps.so.telusgalaxys4gmtd /system/lib/libclientgps.so
    /tmp/busybox mv /system/vendor/lib/hw/gps.aries.so.telusgalaxys4gmtd /system/vendor/lib/hw/gps.aries.so
    /tmp/busybox mv /system/vendor/firmware/nvram_net.txt.telusgalaxys4gmtd /system/vendor/firmware/nvram_net.txt

    # remove T959V-specific files
    /tmp/busybox rm /system/vendor/bin/gpsd-shim
    /tmp/busybox rm /system/vendor/bin/samsung-gpsd

    # set ro.build.product to T959P
    /tmp/busybox sed -i -- 's/ro.product.model=galaxys4g/ro.product.model=SGH-T959P/g' /system/build.prop
else
    /tmp/busybox echo "This is a T959V, setting up proper files"

    # remove T959P-specific files
    /tmp/busybox rm /system/lib/libclientgps.so.telusgalaxys4gmtd
    /tmp/busybox rm /system/vendor/lib/hw/gps.aries.so.telusgalaxys4gmtd
    /tmp/busybox rm /system/vendor/firmware/nvram_net.txt.telusgalaxys4gmtd
    /tmp/busybox rm /system/vendor/bin/agpsd
    /tmp/busybox rm /system/vendor/bin/ste-cg29xx_ctrl

    # set ro.build.product to T959V
    /tmp/busybox sed -i -- 's/ro.product.model=galaxys4g/ro.product.model=SGH-T959V/g' /system/build.prop
fi

# Remove rild.rc - we redefine it
/tmp/busybox rm /system/etc/init/rild.rc
