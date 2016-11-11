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

if /tmp/busybox test -e /tmp/update_binary ; then
    OUTFD=$(\
        /tmp/busybox ps | \
        /tmp/busybox grep -v "grep" | \
        /tmp/busybox grep -o -E "update_binary(.*)" | \
        /tmp/busybox cut -d " " -f 3\
    );
fi

ui_print() {
    if [ "${OUTFD}" != "" ]; then
        echo "ui_print ${1} " 1>&"${OUTFD}";
        echo "ui_print " 1>&"${OUTFD}";
    else
        echo "${1}";
    fi
}

# warning repartitions
warn_repartition() {
    if ! /tmp/busybox test -e /tmp/.accept_wipe ; then
        /tmp/busybox touch /tmp/.accept_wipe;
        ui_print ""
        ui_print "========================================"
        ui_print "ATTENTION"
        ui_print ""
        ui_print "This VERSION uses an incompatible"
        ui_print "partition layout"
        ui_print "Your SD card will be wiped completely"
        ui_print "So, make your backups then just"
        ui_print "run this zip again to confirm install"
        ui_print ""
        ui_print "ATTENTION"
        ui_print "========================================"
        ui_print ""
        exit 9
    fi
    /tmp/busybox rm -fr /tmp/.accept_wipe;
}

set -x
export PATH=/:/sbin:/system/xbin:/system/bin:/tmp:$PATH

# make sure there's not 3 partitions, we can't handle that many
if /tmp/busybox test -e /dev/block/mmcblk0p3 ; then
    ui_print "You have 3+ partitions"
    ui_print "Please go down to 2 or fewer"
    ui_print "and the run this again"
fi

# check if we're running on a bml or mtd device
if /tmp/busybox test -e /dev/block/bml7 ; then
    # we're running on a bml device

    # warn repartition
    warn_repartition

    # make sure sdcard is mounted
    check_mount /sdcard /dev/block/mmcblk0p1 vfat

    # everything is logged into /mnt/sdcard/aries_bml.log
    set_log /sdcard/aries_bml.log

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

    # write the package path to sdcard aries.cfg
    if /tmp/busybox test -n "$UPDATE_PACKAGE" ; then
        PACKAGE_LOCATION=${UPDATE_PACKAGE#/mnt}
        /tmp/busybox echo "$PACKAGE_LOCATION" > /sdcard/aries.cfg

        # Make sure that the zip file gets flashed upon reboot
        /tmp/busybox echo "install_zip(\"$PACKAGE_LOCATION\");" > /sdcard/extendedcommand
        /tmp/busybox echo "install $PACKAGE_LOCATION" > /sdcard/openrecoveryscript
    fi

    # Scorch any ROM Manager settings to require the user to reflash recovery
    /tmp/busybox rm -f /sdcard/clockworkmod/.settings
    /tmp/busybox rm -f /sdcard/TWRP/.settings

    # Copy the recovery ramdisk to the SD
    /tmp/busybox cp /tmp/ramdisk-recovery.img /sdcard/ramdisk-recovery.img

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

elif /tmp/busybox test -e /dev/block/mtdblock0 ; then
# we're running on an mtd device

    # everything is logged into /tmp/aries.log
    set_log /tmp/aries_mtd.log

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
            if is_telus_galaxys4g ; then
                /tmp/busybox cp /tmp/modem.bin.telusgalaxys4gmtd /radio/modem.bin
            else
                /tmp/busybox cp /tmp/modem.bin /radio/modem.bin
            fi
            /tmp/busybox sync
        fi
    fi

    # unmount radio partition
    /tmp/busybox umount -l /dev/block/mtdblock6

    # format the ramdisk partitions and copy the ramdisks to them
    /tmp/busybox umount -l /dev/block/mtdblock1
    /tmp/erase_image ramdisk
    check_mount /ramdisk /dev/block/mtdblock1 yaffs2
    /tmp/busybox cp /tmp/ramdisk.img /ramdisk/ramdisk.img

    # don't overwrite the recovery if it already exists
    check_mount /ramdisk-recovery /dev/block/mtdblock5 yaffs2
    if ! /tmp/busybox test -e /ramdisk-recovery/ramdisk-recovery.img ; then
        /tmp/busybox umount -l /dev/block/mtdblock5
        /tmp/erase_image ramdisk-recovery
        check_mount /ramdisk-recovery /dev/block/mtdblock5 yaffs2
        /tmp/busybox cp /tmp/ramdisk-recovery.img /ramdisk-recovery/ramdisk-recovery.img
    fi

    /tmp/busybox sync

    # unmount the ramdisk partitions
    /tmp/busybox umount -l /dev/block/mtdblock1
    /tmp/busybox umount -l /dev/block/mtdblock5

    # flash boot image
    /tmp/erase_image boot
    /tmp/bml_over_mtd.sh boot 72 reservoir 4012 /tmp/boot.img

    # unmount and format system (recovery seems to expect system to be unmounted)
    /tmp/busybox umount -l /system
    /tmp/erase_image system

    # if a aries.cfg exists, then this is an update from BML
    # lets check if it doesn't exist
    if ! /tmp/busybox test -e /sdcard/aries.cfg ; then
	# Use blkid to determine fstab on mmcblk0p1, if its vfat then need to format
        if [ "$(/tmp/busybox blkid '/dev/block/mmcblk0p1' | /tmp/busybox awk -F 'TYPE=' '{print $2}' | /tmp/busybox sed -e 's/"//g')" == "vfat" ] ; then
            # We're running an old parition system, format userdata, cache, and second parition on sd card

            # warn repartition
            warn_repartition

            /tmp/busybox echo "Updating partition scheme, formatting SD card, datadata, and cache"
            /tmp/busybox umount -l /datadata
            /tmp/erase_image datadata

            /tmp/busybox umount -l /cache
            /tmp/erase_image cache

            # make sure we format sd after reboot, also reboots to recovery
            /tmp/busybox mount -t yaffs2 /dev/block/mtdblock3 /cache
            /tmp/busybox touch /cache/.format_sd
            /tmp/busybox umount -l /cache
        else
            /tmp/busybox echo "Updating ROM, Not formating /cache and /data, not restoring /efs"
        fi

        exit 0
    fi

    /tmp/busybox echo "Updating from a BML rom. Format /cache and /data, and attempt to restore /efs"

    # remove the aries.cfg to prevent this from looping
    /tmp/busybox rm -f /sdcard/aries.cfg

    # unmount and format system (recovery seems to expect system to be unmounted)
    /tmp/busybox umount -l /system
    /tmp/erase_image system

    # make sure sdcard is mounted
    check_mount /sdcard /dev/block/mmcblk0p1 vfat

    /tmp/busybox rm -f /sdcard/extendedcommand
    /tmp/busybox rm -f /sdcard/openrecoveryscript

    # remove the recovery ramdisk from the SD
    /tmp/busybox rm -f /sdcard/ramdisk-recovery.img

    # unmount and format cache
    /tmp/busybox umount -l /cache
    /tmp/erase_image cache

    # make sure we format sd after reboot (also reboots to recovery so SuperSU, gapps, etc can be installed)
    /tmp/busybox mount -t yaffs2 /dev/block/mtdblock3 /cache
    /tmp/busybox touch /cache/.format_sd
    /tmp/busybox umount -l /cache

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
fi
