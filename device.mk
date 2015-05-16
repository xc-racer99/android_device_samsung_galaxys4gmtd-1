# Copyright (C) 2010 The Android Open Source Project
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

DEVICE_PACKAGE_OVERLAYS := device/samsung/telusgalaxys4gmtd/overlay

# These are the hardware-specific configuration files
PRODUCT_COPY_FILES := \
	device/samsung/telusgalaxys4gmtd/etc/asound.conf:system/etc/asound.conf

# Init files
PRODUCT_COPY_FILES += \
	device/samsung/telusgalaxys4gmtd/ramdisk/init.aries.rc:root/init.aries.rc

# Prebuilt kl keymaps
PRODUCT_COPY_FILES += \
	device/samsung/telusgalaxys4gmtd/keys/aries-keypad.kl:system/usr/keylayout/aries-keypad.kl \
	device/samsung/telusgalaxys4gmtd/keys/cypress-touchkey.kl:system/usr/keylayout/cypress-touchkey.kl

# We unfortunately need our own updater.sh and fstab
PRODUCT_COPY_FILES += \
	device/samsung/telusgalaxys4gmtd/updater.sh:updater.sh \
	device/samsung/telusgalaxys4gmtd/vold.fstab:system/etc/vold.fstab \
	device/samsung/telusgalaxys4gmtd/fstab.aries:root/fstab.aries

# Inherit common configuration
$(call inherit-product, device/samsung/aries-common/device_base.mk)

# Fm app
PRODUCT_PACKAGES += \
	FmRxApp \
	FmTxApp \
	fmradioif \
	FmService \
	FmRadio

# Proprietary
$(call inherit-product-if-exists, vendor/samsung/telusgalaxys4gmtd/telusgalaxys4gmtd-vendor.mk)
