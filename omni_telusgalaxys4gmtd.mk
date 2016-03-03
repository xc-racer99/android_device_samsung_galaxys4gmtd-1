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

# Inherit from the common Open Source product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit Omni GSM telephony parts
$(call inherit-product, vendor/omni/config/gsm.mk)

# bootanimation
TARGET_BOOTANIMATION_SIZE := 640x362

# Exclude Live Wallpapers
TARGET_EXCLUDE_LIVEWALLPAPERS := true

# Inherit from our custom product configuration
$(call inherit-product, vendor/omni/config/common.mk)

# Inherit device configuration
$(call inherit-product, device/samsung/telusgalaxys4gmtd/device.mk)

# Device identifier
PRODUCT_RELEASE_NAME := TelusFascinate4G
PRODUCT_DEVICE := telusgalaxys4gmtd
PRODUCT_NAME := omni_telusgalaxys4gmtd
PRODUCT_BRAND := SEC
PRODUCT_MANUFACTURER := SEC
PRODUCT_MODEL := SGH-T959P

#Set build fingerprint / ID / Prduct Name ect.
PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=SGH-T959P TARGET_DEVICE=SGH-T959P BUILD_FINGERPRINT=samsung/SGH-T959P/SGH-T959P:2.3.4/GINGERBREAD/PTLKH2:user/release-keys PRIVATE_BUILD_DESC="SGH-T959P-user 2.3.4 GINGERBREAD PTLKH2 release-keys"
