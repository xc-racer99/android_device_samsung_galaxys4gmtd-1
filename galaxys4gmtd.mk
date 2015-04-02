#
# Copyright (C) 2012 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# This file is the device-specific product definition file for
# crespo. It lists all the overlays, files, modules and properties
# that are specific to this hardware: i.e. those are device-specific
# drivers, configuration files, settings, etc...

# Note that crespo is not a fully open device. Some of the drivers
# aren't publicly available in all circumstances, which means that some
# of the hardware capabilities aren't present in builds where those
# drivers aren't available. Such cases are handled by having this file
# separated into two halves: this half here contains the parts that
# are available to everyone, while another half in the vendor/ hierarchy
# augments that set with the parts that are only relevant when all the
# associated drivers are available. Aspects that are irrelevant but
# harmless in no-driver builds should be kept here for simplicity and
# transparency. There are two variants of the half that deals with
# the unavailable drivers: one is directly checked into the unreleased
# vendor tree and is used by engineers who have access to it. The other
# is generated by setup-makefile.sh in the same directory as this files,
# and is used by people who have access to binary versions of the drivers
# but not to the original vendor tree. Be sure to update both.


# These is the hardware-specific overlay, which points to the location
# of hardware-specific resource overrides, typically the frameworks and
# application settings that are stored in resourced.
DEVICE_PACKAGE_OVERLAYS := device/samsung/galaxys4gmtd/overlay

# These are the hardware-specific configuration files
PRODUCT_COPY_FILES := \
    device/samsung/galaxys4gmtd/prebuilt/etc/asound.conf:system/etc/asound.conf \
    device/samsung/galaxys4gmtd/prebuilt/etc/vold.fstab:system/etc/vold.fstab \
    device/samsung/galaxys4gmtd/prebuilt/etc/egl.cfg:system/lib/egl/egl.cfg

# Init files
# device/samsung/galaxys4gmtd/init.herring.rc:root/init.herring.rc
PRODUCT_COPY_FILES += \
    device/samsung/galaxys4gmtd/init.herring.rc:root/init.herring.rc \
    device/samsung/galaxys4gmtd/init.herring.usb.rc:root/init.herring.usb.rc \
    device/samsung/galaxys4gmtd/init.herring.usb.rc:recovery/root/usb.rc \
    device/samsung/galaxys4gmtd/lpm.rc:root/lpm.rc \
    device/samsung/galaxys4gmtd/ueventd.herring.rc:root/ueventd.herring.rc

# Keylayout and Keychars
PRODUCT_COPY_FILES += \
    device/samsung/galaxys4gmtd/cypress-touchkey.kl:system/usr/keylayout/cypress-touchkey.kl \
    device/samsung/galaxys4gmtd/prebuilt/usr/keylayout/sec_jack.kl:system/usr/keylayout/sec_jack.kl \
    device/samsung/galaxys4gmtd/prebuilt/usr/keylayout/AVRCP.kl:system/usr/keylayout/AVRCP.kl \
    device/samsung/galaxys4gmtd/prebuilt/usr/keylayout/aries-keypad.kl:system/usr/keylayout/aries-keypad.kl \
    device/samsung/galaxys4gmtd/prebuilt/usr/keylayout/melfas_touchkey.kl:system/usr/keylayout/melfas_touchkey.kl \
    device/samsung/galaxys4gmtd/prebuilt/usr/keylayout/qwerty.kl:system/usr/keylayout/qwerty.kl \
    device/samsung/galaxys4gmtd/prebuilt/usr/keylayout/Broadcom_Bluetooth_HID.kl:system/usr/keylayout/Broadcom_Bluetooth_HID.kl \
    device/samsung/galaxys4gmtd/prebuilt/usr/keychars/Broadcom_Bluetooth_HID.kcm.bin:system/usr/keychars/Broadcom_Bluetooth_HID.kcm.bin \
    device/samsung/galaxys4gmtd/prebuilt/usr/keychars/melfas_touchkey.kcm.bin:system/usr/keychars/melfas_touchkey.kcm.bin \
    device/samsung/galaxys4gmtd/prebuilt/usr/keychars/qwerty.kcm.bin:system/usr/keychars/qwerty.kcm.bin \
    device/samsung/galaxys4gmtd/s3c-keypad.kl:system/usr/keylayout/s3c-keypad.kl \
    device/samsung/galaxys4gmtd/prebuilt/usr/keychars/aries-keypad.kcm.bin:system/usr/keychars/aries-keypad.kcm.bin \
    device/samsung/galaxys4gmtd/prebuilt/usr/keychars/qwerty2.kcm.bin:system/usr/keychars/qwerty2.kcm.bin

# Generated kcm keymaps
PRODUCT_PACKAGES := \
    cypress-touchkey.kcm \
    s3c-keypad.kcm

# Wifi utilities
PRODUCT_PACKAGES += \
    dhdutil \
    fw_bcm4329.bin \
    fw_bcm4329_apsta.bin

# Filesystem management tools
PRODUCT_PACKAGES += \
    bml_over_mtd \
    setup_fs

# These are the OpenMAX IL configuration files
PRODUCT_COPY_FILES += \
    device/samsung/galaxys4gmtd/sec_mm/sec_omx/sec_omx_core/secomxregistry:system/etc/secomxregistry \
    device/samsung/galaxys4gmtd/media_profiles.xml:system/etc/media_profiles.xml

# These are the OpenMAX IL modules
PRODUCT_PACKAGES += \
    libSEC_OMX_Core.s5pc110 \
    libOMX.SEC.AVC.Decoder.s5pc110 \
    libOMX.SEC.M4V.Decoder.s5pc110 \
    libOMX.SEC.M4V.Encoder.s5pc110 \
    libOMX.SEC.AVC.Encoder.s5pc110

# audio
PRODUCT_PACKAGES += \
    audio.primary.s5pc110 \
    audio_policy.s5pc110

# Misc other modules
PRODUCT_PACKAGES += \
    lights.s5pc110 \
    sensors.s5pc110 \
    audio.a2dp.default

# Libs
PRODUCT_PACKAGES += \
    camera.s5pc110 \
    libs3cjpeg \
    libstagefrighthw \
    hwcomposer.s5pc110

# Bluetooth MAC Address
PRODUCT_PACKAGES += \
    bdaddr_read

# Device specific packages
PRODUCT_PACKAGES += \
    SamsungServiceMode \
    SGS4GParts \
    tvouthack \
    CMFileManager \
    CMFileManagerThemes

# Usb accessory
PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

# Charger
PRODUCT_PACKAGES += \
    charger \
    charger_res_images

# Input device calibration files
PRODUCT_COPY_FILES += \
    device/samsung/galaxys4gmtd/prebuilt/usr/idc/qt602240_ts_input.idc:system/usr/idc/qt602240_ts_input.idc

# These are the hardware-specific features
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/base/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/base/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/base/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
	frameworks/base/data/etc/android.hardware.location.xml:system/etc/permissions/android.hardware.location.xml \
	frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/base/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/base/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/base/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml

# The OpenGL ES API level that is natively supported by this device.
# This is a 16.16 fixed point number
PRODUCT_PROPERTY_OVERRIDES := \
    ro.opengles.version=131072

# These are the hardware-specific settings that are stored in system properties.
# Note that the only such settings should be the ones that are too low-level to
# be reachable from resources or other mechanisms.
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=eth0 \
    wifi.supplicant_scan_interval=20 \
    ro.telephony.ril_class=SamsungRIL \
    ro.telephony.ril.v3=icccardstatus,datacall,signalstrength,facilitylock \
    mobiledata.interfaces=pdp0,gprs

# HSPA+/HSUPA overrides
PRODUCT_PROPERTY_OVERRIDES += \
    ro.ril.gprsclass=12 \
    ro.ril.hsdpa.category=14 \
    ro.ril.hsupa.category=6 \
    ro.ril.hsxpa=2 \
    net.tcp.buffersize.hsdpa = 4094,87380,393216,4096,16384,110208

# enable Google-specific location features,
# like NetworkLocationProvider and LocationCollector
#    ro.com.google.networklocation=1
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.locationfeatures=1 \
    ro.com.google.networklocation=1

# Extended JNI checks
# The extended JNI checks will cause the system to run more slowly, but they can spot a variety of nasty bugs
# before they have a chance to cause problems.
# Default=true for development builds, set by android buildsystem.
PRODUCT_PROPERTY_OVERRIDES += \
    ro.kernel.android.checkjni=0 \
    dalvik.vm.checkjni=false

# Override /proc/sys/vm/dirty_ratio on UMS
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vold.umsdirtyratio=20

# We have sacrificed /cache for a larger /system, so it's not large enough for dalvik cache
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dexopt-data-only=1

# Set default USB interface
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mass_storage

# enable repeatable keys in cwm
PRODUCT_PROPERTY_OVERRIDES += \
    ro.cwm.enable_key_repeat=true

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

include frameworks/base/build/phone-hdpi-512-dalvik-heap.mk

PRODUCT_COPY_FILES += \
    device/samsung/galaxys4gmtd/updater.sh:updater.sh  \
    device/samsung/galaxys4gmtd/postrecoveryboot.sh:recovery/root/sbin/postrecoveryboot.sh

# See comment at the top of this file. This is where the other
# half of the device-specific product definition file takes care
# of the aspects that require proprietary drivers that aren't
# commonly available
$(call inherit-product-if-exists, vendor/samsung/galaxys4gmtd/galaxys4gmtd-vendor.mk)
