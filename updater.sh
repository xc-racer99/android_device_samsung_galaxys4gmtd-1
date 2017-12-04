#!/tmp/busybox sh
#
# Universal Updater Script for Samsung Galaxy S Phones
# (c) 2011 by Teamhacksung
# Galaxy S 4G UBI Version
#

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
# we're running on an mtd device with UBI

    # everything is logged into /sdcard/aries.log
    set_log /sdcard/aries_ubi.log

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
