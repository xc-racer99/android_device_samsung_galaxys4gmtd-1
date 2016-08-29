#
# Copyright (C) 2015 The Android Open-Source Project
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
#

# This file includes all definitions that apply to ALL galaxys4gmtd devices, and
# are also specific to galaxys4gmtd devices
#
# Everything in this directory will become public

ifeq ($(TARGET_PREBUILT_KERNEL),)
  LOCAL_KERNEL := device/samsung/galaxys4gmtd/zImage
else
  LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES := \
    $(LOCAL_KERNEL):kernel

DEVICE_PACKAGE_OVERLAYS += \
    device/samsung/galaxys4gmtd/overlay

PRODUCT_COPY_FILES += \
    device/samsung/galaxys4gmtd/config/asound.conf:system/etc/asound.conf

# Init files
PRODUCT_COPY_FILES += \
    device/samsung/galaxys4gmtd/rootdir/init.aries.rc:root/init.aries.rc \
    device/samsung/galaxys4gmtd/rootdir/init.aries.gps.rc:root/init.aries.gps.rc \
    device/samsung/galaxys4gmtd/rootdir/init.recovery.aries.rc:root/init.recovery.aries.rc \
    device/samsung/galaxys4gmtd/rootdir/ueventd.aries.rc:root/ueventd.aries.rc \
    device/samsung/galaxys4gmtd/rootdir/sbin/init.aries.gps.sh:root/sbin/init.aries.gps.sh

# FSTAB files
PRODUCT_COPY_FILES += \
    device/samsung/galaxys4gmtd/rootdir/fstab.aries:root/fstab.aries \
    device/samsung/galaxys4gmtd/recovery/twrp.fstab:recovery/root/etc/twrp.fstab

# Prebuilt kl and kcm keymaps
PRODUCT_COPY_FILES += \
    device/samsung/galaxys4gmtd/config/aries-keypad.kl:system/usr/keylayout/aries-keypad.kl \
    device/samsung/galaxys4gmtd/config/aries-keypad.kcm:system/usr/keychars/aries-keypad.kcm \
    device/samsung/galaxys4gmtd/config/cypress-touchkey.kl:system/usr/keylayout/cypress-touchkey.kl

# Misc files
PRODUCT_COPY_FILES += \
    device/samsung/galaxys4gmtd/bml_over_mtd.sh:bml_over_mtd.sh \
    device/samsung/galaxys4gmtd/post-install.sh:post-install.sh \
    device/samsung/galaxys4gmtd/updater.sh:updater.sh

# This device is hdpi
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := hdpi
# A list of dpis to select prebuilt apk, in precedence order.
PRODUCT_AAPT_PREBUILT_DPI := hdpi mdpi xhdpi xxhdpi

# GPS packages
PRODUCT_PACKAGES += \
    gpsd-shim

# HSPA+/HSUPA Overrides
PRODUCT_PROPERTY_OVERRIDES += \
    ro.ril.gprsclass=12 \
    ro.ril.hsdpa.category=14 \
    ro.ril.hsupa.category=6 \
    ro.ril.hsxpa=2 \
    net.tcp.buffersize.hsdpa=4094,87380,393216,4096,16384,110208

# Inherit Aries common device configuration.
$(call inherit-product, device/samsung/aries-common/device_base.mk)

# Inherit the vendor blobs
$(call inherit-product-if-exists, vendor/samsung/galaxys4gmtd/galaxys4gmtd-vendor.mk)
