#!/tmp/busybox sh
#
# Universal Updater Script for Samsung Galaxy S Phones
# (c) 2011 by Teamhacksung
# GSM version
#

set -x
export PATH=/:/sbin:/system/xbin:/system/bin:/tmp:$PATH

# check if we're running on a bml or mtd device
if /tmp/busybox test -e /dev/block/bml7 ; then
# we're running on a bml device

    # make sure sdcard is mounted
    if ! /tmp/busybox grep -q /mnt/sdcard /proc/mounts ; then
        /tmp/busybox mkdir -p /mnt/sdcard
        /tmp/busybox umount -l /dev/block/mmcblk0p1
        if ! /tmp/busybox mount -t vfat /dev/block/mmcblk0p1 /mnt/sdcard ; then
            /tmp/busybox echo "Cannot mount sdcard."
            exit 1
        fi
    fi

    # remove old log
    rm -rf /mnt/sdcard/cyanogenmod_bml.log

    # everything is logged into /sdcard/cyanogenmod.log
    exec >> /mnt/sdcard/cyanogenmod_bml.log 2>&1

    # make sure efs is mounted
    if ! /tmp/busybox grep -q /efs /proc/mounts ; then
        /tmp/busybox mkdir -p /efs
        /tmp/busybox umount -l /dev/block/stl3
        if ! /tmp/busybox mount -t rfs /dev/block/stl3 /efs ; then
            /tmp/busybox echo "Cannot mount efs."
            exit 2
        fi
    fi

    # create a backup of efs
    if /tmp/busybox test -e /mnt/sdcard/backup/efs.tar ; then
        /tmp/busybox mv /mnt/sdcard/backup/efs.tar /mnt/sdcard/backup/efs-$$.tar
        /tmp/busybox mv /mnt/sdcard/backup/efs.tar.md5 /mnt/sdcard/backup/efs-$$.tar.md5
    fi
    /tmp/busybox rm -rf /mnt/sdcard/backup/efs.tar
    /tmp/busybox rm -rf /mnt/sdcard/backup/efs.tar.md5

    /tmp/busybox mkdir -p /mnt/sdcard/backup
    
    cd /efs
    /tmp/busybox tar cf /mnt/sdcard/backup/efs.tar *

    # Now we checksum the file. We'll verify later when we do a restore
    cd /mnt/sdcard/backup/
    /tmp/busybox md5sum -t efs.tar > efs.tar.md5

    # write the package path to sdcard cyanogenmod.cfg
    if /tmp/busybox test -n "$UPDATE_PACKAGE" ; then
        PACKAGE_LOCATION=${UPDATE_PACKAGE#/mnt}
        /tmp/busybox echo "$PACKAGE_LOCATION" > /mnt/sdcard/cyanogenmod.cfg
    fi

    # Scorch any ROM Manager settings to require the user to reflash recovery
    /tmp/busybox rm -f /mnt/sdcard/clockworkmod/.settings

    # write new kernel to boot partition
    /tmp/flash_image boot /tmp/boot.img
    if [ "$?" != "0" ] ; then
        exit 3
    fi
    /tmp/busybox sync

    /sbin/reboot now
    exit 0

elif /tmp/busybox test -e /dev/block/mtdblock0 ; then
# we're running on a mtd device

    # make sure sdcard is mounted
    /tmp/busybox mkdir -p /sdcard

    if ! /tmp/busybox grep -q /sdcard /proc/mounts ; then
        /tmp/busybox umount -l /dev/block/mmcblk0p1
        if ! /tmp/busybox mount -t vfat /dev/block/mmcblk0p1 /sdcard ; then
            /tmp/busybox echo "Cannot mount sdcard."
            exit 4
        fi
    fi

    # remove old log
    rm -rf /sdcard/cyanogenmod_mtd.log

    # everything is logged into /sdcard/cyanogenmod.log
    exec >> /sdcard/cyanogenmod_mtd.log 2>&1

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
	fi
    fi

    # unmount radio partition
    /tmp/busybox umount -l /dev/block/mtdblock6

    # if a cyanogenmod.cfg exists, then this is a first time install
    # let's format the volumes and restore radio and efs
    if ! /tmp/busybox test -e /sdcard/cyanogenmod.cfg ; then
        exit 0
    fi

    # remove the cyanogenmod.cfg to prevent this from looping
    /tmp/busybox rm -f /sdcard/cyanogenmod.cfg

    # unmount and format cache
    /tmp/busybox umount -l /cache
    /tmp/erase_image cache

    # unmount and format data
    /tmp/busybox umount /data
    /tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -a /data /dev/block/mtdblock3

    # restore efs backup
    if /tmp/busybox test -e /sdcard/backup/efs.tar ; then
        /tmp/busybox umount -l /efs
        /tmp/erase_image efs
        /tmp/busybox mkdir -p /efs

        # make sure we can mount /efs
        if ! /tmp/busybox grep -q /efs /proc/mounts ; then
            if ! /tmp/busybox mount -t yaffs2 /dev/block/mtdblock4 /efs ; then
                /tmp/busybox echo "Cannot mount efs."
                exit 6
            fi
        fi

        # verify the md5sum of efs.tar before restore
        cd /sdcard/backup/
        /tmp/busybox md5sum -c efs.tar.md5

        # save the exit status of md5sum
        MD5RESULT=$?
        if ! /tmp/busybox test $MD5RESULT; then
            echo "efs.tar could not be verified."
            exit 8
        fi

        # extract the tar file in the /efs partition
        cd /efs
        /tmp/busybox tar xf /sdcard/backup/efs.tar
        /tmp/busybox umount -l /efs
    else
        /tmp/busybox echo "Cannot restore efs."
        exit 7
    fi

    # flash boot image
    /tmp/erase_image boot
    /tmp/bml_over_mtd.sh boot 72 reservoir 4012 /tmp/boot.img

    exit 0
fi
