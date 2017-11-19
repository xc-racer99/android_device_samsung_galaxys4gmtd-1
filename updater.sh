#!/tmp/busybox sh
#
# Universal Updater Script for Samsung Galaxy S Phones
# (c) 2011 by Teamhacksung
# GSM version
#

HWREV=`/tmp/busybox cat /proc/hwrev`

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

# ui_print
OUTFD=$(\
    /tmp/busybox ps | \
    /tmp/busybox grep -v "grep" | \
    /tmp/busybox grep -o -E "/tmp/updater .*" | \
    /tmp/busybox cut -d " " -f 3\
);

ui_print() {
    if [ "${OUTFD}" != "" ]; then
        echo "ui_print ${1} " 1>&"${OUTFD}";
        echo "ui_print " 1>&"${OUTFD}";
    else
        echo "${1}";
    fi
}

set -x
export PATH=/:/sbin:/system/xbin:/system/bin:/tmp:$PATH

if /tmp/busybox test -e /dev/block/ubiblock0_0 ; then
# we're running on an mtd device

    # everything is logged into /sdcard/aries.log
    set_log /sdcard/aries_ubi.log

    # create mountpoint for radio partition
    /tmp/busybox mkdir -p /radio

    # copy modem.bin to radio partition
    /tmp/busybox umount -l /dev/block/ubiblock0_3
    if is_telus_galaxys4g ; then
        /tmp/busybox mv /tmp/modem.bin.telusgalaxys4gmtd /tmp/modem.bin
    fi
    /tmp/busybox chown radio:radio /tmp/modem.bin
    /tmp/busybox chcon u:object_r:rild_file:s0 /tmp/modem.bin
    /tmp/mksquashfs /tmp/modem.bin /tmp/radio.squash -noappend
    /tmp/ubiupdatevol /dev/ubi0_3 /tmp/radio.squash

    # uncpio boot.img and make a squashfs
    /tmp/busybox mkdir /tmp/ramdisk
	cd /tmp/ramdisk
	/tmp/busybox cpio -ui < /tmp/ramdisk.cpio
	cd /
	/tmp/mksquashfs /tmp/ramdisk /tmp/ramdisk.squash -noappend
    /tmp/busybox rm -rf /tmp/ramdisk
    /tmp/ubiupdatevol /dev/ubi0_1 /tmp/ramdisk.squash

    # flash boot image
    /tmp/erase_image boot
    /tmp/bml_over_mtd.sh boot 72 reservoir 4012 /tmp/boot.img

    exit 0
else
    ui_print "This only works on devices that have been converted to UBI"
    exit 1
fi
