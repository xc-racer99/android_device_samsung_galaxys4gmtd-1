#
# Copyright 2015 The Android Open Source Project
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
# Sample: This is where we'd set a backup provider if we had one
# $(call inherit-product, device/sample/products/backup_overlay.mk)

# Low ram device
TARGET_LOW_RAM_DEVICE := true

# Use 44.1 kHz UI sounds
$(call inherit-product-if-exists, frameworks/base/data/sounds/AudioPackage13.mk)

# Inherit from the common Open Source product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)

# Device identifier
PRODUCT_NAME := aosp_galaxys4gmtd
PRODUCT_DEVICE := galaxys4gmtd
PRODUCT_BRAND := Samsung
PRODUCT_MODEL := galaxys4g
PRODUCT_MANUFACTURER := samsung

# Inherit device configuration
$(call inherit-product, device/samsung/galaxys4gmtd/device.mk)
