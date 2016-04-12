# Copyright (C) 2013 OmniROM Project
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

# low ram device
TARGET_LOW_RAM_DEVICE := true

# Get the long list of APNs
PRODUCT_COPY_FILES := device/samsung/aries-common/apns-full-conf.xml:system/etc/apns-conf.xml

# Inherit from the common Open Source product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)

# Inherit device configuration
$(call inherit-product, device/samsung/telusgalaxys4gmtd/device.mk)

# Device identifier
PRODUCT_RELEASE_NAME := TelusFascinate4G
PRODUCT_DEVICE := telusgalaxys4gmtd
PRODUCT_NAME := aosp_telusgalaxys4gmtd
PRODUCT_BRAND := SEC
PRODUCT_MANUFACTURER := SEC
PRODUCT_MODEL := SGH-T959P

# Build Launcher
PRODUCT_PACKAGES += \
	Launcher3
