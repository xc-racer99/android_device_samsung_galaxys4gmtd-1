#
# Copyright (C) 2013 OmniROM Project
# Copyright (C) 2007 The Android Open Source Project
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

# BoardConfig.mk
#
# Product-specific compile-time definitions.
#

# Kernel Config
TARGET_KERNEL_CONFIG := omni_galaxys4gmtd_defconfig

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/samsung/galaxys4gmtd/bluetooth

# Recovery
BOARD_CUSTOM_RECOVERY_KEYMAPPING := ../../device/samsung/galaxys4gmtd/recovery/recovery_keys.c

TARGET_OTA_ASSERT_DEVICE := galaxys4g,galaxys4gmtd,SGH-T959V,SGH-T959W,SGH-T959P

# Use SuperSU
USE_SUPERSU := true

# Import the aries-common BoardConfigCommon.mk
include device/samsung/aries-common/BoardConfigCommon.mk

# Override stuff that doesn't match aries-common
BOARD_SECOND_CAMERA_DEVICE := /dev/video2
BOARD_CAMERA_FFC_FLIPPED := true
TARGET_RECOVERY_FSTAB := device/samsung/galaxys4gmtd/fstab.aries

# Use our own releasetools
TARGET_RELEASETOOLS_EXTENSIONS := device/samsung/telusgalaxys4gmtd

# SELinux
BOARD_SEPOLICY_DIRS += device/samsung/galaxys4gmtd/sepolicy

# Based on kernel header
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 629145600
BOARD_CACHEIMAGE_PARTITION_SIZE := 41943040

# We use a yaffs system image
TARGET_USERIMAGES_USE_YAFFS := true

# TWRP options
# Override some settings in aries-common as we don't have an external_sd/emmc
undefine TW_EXTERNAL_STORAGE_PATH
undefine TW_EXTERNAL_STORAGE_MOUNT_POINT
TW_INTERNAL_STORAGE_PATH := "/data/media"
TW_INTERNAL_STORAGE_MOUNT_POINT := "data"
RECOVERY_SDCARD_ON_DATA := true

# Use MTP in recovery
undefine TW_EXCLUDE_MTP
