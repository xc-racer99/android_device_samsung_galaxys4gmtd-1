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

DEVICE_PACKAGE_OVERLAYS := device/samsung/galaxys4gmtd/overlay

# These are the hardware-specific configuration files
PRODUCT_COPY_FILES := \
	device/samsung/galaxys4gmtd/etc/asound.conf:system/etc/asound.conf

# Init files
PRODUCT_COPY_FILES += \
	device/samsung/galaxys4gmtd/ramdisk/init.target.rc:root/init.target.rc \
	device/samsung/galaxys4gmtd/ramdisk/init.aries.gps.rc:root/init.aries.gps.rc

# Prebuilt kl keymaps
PRODUCT_COPY_FILES += \
	device/samsung/galaxys4gmtd/keys/aries-keypad.kl:system/usr/keylayout/aries-keypad.kl \
	device/samsung/galaxys4gmtd/keys/cypress-touchkey.kl:system/usr/keylayout/cypress-touchkey.kl

# Inherit common configuration
$(call inherit-product, device/samsung/aries-common/device_base.mk)

# Proprietary
$(call inherit-product-if-exists, vendor/samsung/galaxys4gmtd/galaxys4gmtd-vendor.mk)
