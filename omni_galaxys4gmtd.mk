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

# Inherit Omni GSM telephony parts
$(call inherit-product, vendor/omni/config/gsm.mk)

# Bootanimation
TARGET_BOOTANIMATION_SIZE := 480x270

# Exclude live wallpapers
TARGET_EXCLUDE_LIVEWALLPAPERS := true

# Inherit from our custom product configuration
$(call inherit-product, vendor/omni/config/common.mk)

# Add Omni-specific overlays
DEVICE_PACKAGE_OVERLAYS += \
	device/samsung/galaxys4gmtd/overlay_omni \
	device/samsung/aries-common/overlay_omni

# Inherit AOSP device configuration
$(call inherit-product, device/samsung/galaxys4gmtd/aosp_galaxys4gmtd.mk)

# Inherit common Omni device configuration
$(call inherit-product, device/samsung/aries-common/device_base_omni.mk)

# Device identifier, must be after all includes
PRODUCT_NAME := omni_galaxys4gmtd
