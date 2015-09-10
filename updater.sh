#!/tmp/busybox sh
#
# Universal Updater Script for Samsung Galaxy S Phones
# (c) 2011 by Teamhacksung
# GSM version
#

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

set_log() {
    rm -rf $1
    exec >> $1 2>&1
}

set -x
export PATH=/:/sbin:/system/xbin:/system/bin:/tmp:$PATH

# check if we're running on a bml or mtd device
if /tmp/busybox test -e /dev/block/bml7 && /tmp/busybox test -e /dev/block/mmcblk0p2 ; then
    # we're running on a bml device with a second sd card partition

    # make sure sdcard is mounted
    check_mount /sdcard /dev/block/mmcblk0p1 vfat

    # everything is logged into /mnt/sdcard/omni_bml.log
    set_log /sdcard/omni_bml.log

    # make sure efs is mounted
    check_mount /efs /dev/block/stl3 rfs

    # create a backup of efs
    if /tmp/busybox test -e /sdcard/backup/efs.tar ; then
        /tmp/busybox mv /sdcard/backup/efs.tar /sdcard/backup/efs-$$.tar
        /tmp/busybox mv /sdcard/backup/efs.tar.md5 /sdcard/backup/efs-$$.tar.md5
    fi
    /tmp/busybox rm -f /sdcard/backup/efs.tar
    /tmp/busybox rm -f /sdcard/backup/efs.tar.md5

    /tmp/busybox mkdir -p /sdcard/backup

    cd /efs
    /tmp/busybox tar cf /sdcard/backup/efs.tar *

    # Now we checksum the file. We'll verify later when we do a restore
    cd /sdcard/backup/
    /tmp/busybox md5sum -t efs.tar > efs.tar.md5

    # write the package path to sdcard omni.cfg
    if /tmp/busybox test -n "$UPDATE_PACKAGE" ; then
        PACKAGE_LOCATION=${UPDATE_PACKAGE#/mnt}
        /tmp/busybox echo "$PACKAGE_LOCATION" > /sdcard/omni.cfg

        # Make sure that the zip file gets flashed upon reboot
        /tmp/busybox echo "install_zip(\"$PACKAGE_LOCATION\");" > /sdcard/extendedcommand
        /tmp/busybox echo "install $PACKAGE_LOCATION" > /sdcard/openrecoveryscript
    fi

    # Scorch any ROM Manager settings to require the user to reflash recovery
    /tmp/busybox rm -f /sdcard/clockworkmod/.settings
    /tmp/busybox rm -f /sdcard/TWRP/.settings

    # write new kernel to boot partition
    /tmp/flash_image boot /tmp/boot.img
    if [ "$?" != "0" ] ; then
        /tmp/busybox echo "Failed to write kernel to boot partition"
        exit 3
    fi
    /tmp/busybox echo "Successfully wrote kernel to boot partition"
    /tmp/busybox sync
    /tmp/busybox umount /sdcard
    /tmp/busybox sleep 10

    /sbin/reboot
    exit 0

elif /tmp/busybox test -e /dev/block/mtdblock0 && /tmp/busybox test -e /dev/block/mmcblk0p2 ; then
# we're running on an mtd device with a second parition

    # make sure sdcard is mounted
    check_mount /sdcard /dev/block/mmcblk0p1 vfat

    # everything is logged into /sdcard/omni.log
    set_log /sdcard/omni_mtd.log

    # create mountpoint for radio partition
    /tmp/busybox mkdir -p /radio

    # make sure radio partition is mounted
    if ! /tmp/busybox grep -q /radio /proc/mounts ; then
        /tmp/busybox umount -l /dev/block/mtdblock6
        if ! /tmp/busybox mount -t yaffs2 /dev/block/mtdblock6 /radio ; then
            /tmp/busybox echo "Cannot mount radio partition."
            exit 5
        fi
    fi

    # if modem.bin doesn't exist on radio partition, format the partition and copy it
    if ! /tmp/busybox test -e /radio/modem.bin ; then
        /tmp/busybox umount -l /dev/block/mtdblock6
        /tmp/erase_image radio
        if ! /tmp/busybox mount -t yaffs2 /dev/block/mtdblock6 /radio ; then
            /tmp/busybox echo "Cannot copy modem.bin to radio partition."
            exit 5
        else
            /tmp/busybox cp /tmp/modem.bin /radio/modem.bin
            /tmp/busybox sync
        fi
    fi

    # unmount radio partition
    /tmp/busybox umount -l /dev/block/mtdblock6

    # flash boot image
    /tmp/erase_image boot
    /tmp/bml_over_mtd.sh boot 72 reservoir 4012 /tmp/boot.img

    # unmount and format system (recovery seems to expect system to be unmounted)
    /tmp/busybox umount -l /system
    /tmp/erase_image system

    # if a omni.cfg exists, then this is an update from BML
    # lets check if it doesn't exist
    if ! /tmp/busybox test -e /sdcard/omni.cfg ; then
        if [ "$(/tmp/busybox cat /sys/class/mtd/mtd3/name)" != "datadata" ] ; then
            # We're running an old parition system, format userdata, cache, and second parition on sd card
            /tmp/busybox echo "Updating partition scheme, formatting old userdata, old sd-ext, and cache; not restoring efs"
            # unmount and format data
            /tmp/busybox umount -l /sd-ext
            /tmp/make_ext4fs -b 4096 -l -16384 -a /data /dev/block/mmcblk0p2
            # unmount and format cache
            /tmp/busybox umount -l /cache
            /tmp/erase_image cache
            if [ "$(/tmp/busybox cat /sys/class/mtd/mtd3/name)" == "userdata" ] ; then
                # Confirmation of old filesystem
                /tmp/busybox umount -l /data
                /tmp/erase_image userdata
                exit 0
            else
                /tmp/busybox echo "Unrecognized parition scheme - aborting!"
                exit 9
            fi
        else
            /tmp/busybox echo "Updating omni, Not formating /cache and /data, not restoring /efs"
            exit 0
        fi
    fi

    /tmp/busybox echo "Updating from a BML rom. Format /cache and /data, and attempt to restore /efs"

    # remove the omni.cfg to prevent this from looping
    /tmp/busybox rm -f /sdcard/omni.cfg
    /tmp/busybox rm -f /sdcard/extendedcommand
    /tmp/busybox rm -f /sdcard/openrecoveryscript

    # unmount and format cache
    /tmp/busybox umount -l /cache
    /tmp/erase_image cache

    # unmount and format data
    /tmp/busybox umount -l /data
    /tmp/make_ext4fs -b 4096 -l -16384 -a /data /dev/block/mmcblk0p2

    # unmount and format datadata
    /tmp/busybox umount -l /datadata
    /tmp/erase_image datadata
 
    # restart into recovery so the user can install further packages such as gapps and SuperSU before booting
    /tmp/busybox touch /cache/.startrecovery

    # restore efs backup
    if /tmp/busybox test -e /sdcard/backup/efs.tar ; then
        /tmp/busybox umount -l /efs
        /tmp/erase_image efs
        /tmp/busybox mkdir -p /efs

        # make sure we can mount /efs
        check_mount /efs /dev/block/mtdblock4 yaffs2

        # verify the md5sum of efs.tar before restore
        cd /sdcard/backup/
        /tmp/busybox md5sum -c efs.tar.md5

        # save the exit status of md5sum
        MD5RESULT=$?
        if ! /tmp/busybox test $MD5RESULT; then
            echo "efs.tar could not be verified."
            exit 7
        fi

        # extract the tar file in the /efs partition
        cd /efs
        /tmp/busybox tar xf /sdcard/backup/efs.tar
        /tmp/busybox umount -l /efs
    else
        /tmp/busybox echo "/sdcard/backup/efs.tar does not exist. Not restoring efs."
        exit 8
    fi

    exit 0

else
    /tmp/busybox echo "Incompatible layout - make sure you have a secondary parition on your SD card"
    exit 2
fi
