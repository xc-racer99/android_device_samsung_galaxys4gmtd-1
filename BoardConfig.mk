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

# Import the aries-common BoardConfigCommon.mk
include device/samsung/aries-common/BoardConfigCommon.mk

# Override stuff that doesn't match aries-common
# Warning - unsetting this next one causes the build to fail
#TARGET_USERIMAGES_USE_EXT4 := false
BOARD_SECOND_CAMERA_DEVICE := /dev/video2
TARGET_PROVIDES_LIBCAMERA := true
TARGET_RECOVERY_FSTAB := device/samsung/galaxys4gmtd/fstab.aries

# SELinux
BOARD_SEPOLICY_DIRS := $(filter-out device/samsung/aries-common/sepolicy,$BOARD_SEPOLICY_DIRS)
BOARD_SEPOLICY_DIRS += \
	device/samsung/galaxys4gmtd/sepolicy

# Based on kernel header
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 403701760
BOARD_USERDATAIMAGE_PARTITION_SIZE := 545259520

# TWRP options
DEVICE_RESOLUTION := 480x800
TW_NO_REBOOT_BOOTLOADER := true
TW_FLASH_FROM_STORAGE := true
# Leave this as false for now, we can attempt to enable it later when we
# make sure that the ramdisk can be injected to
TW_INCLUDE_INJECTTWRP := false
# Override some settings in aries-common as we don't have an external_sd/emmc
undefine TW_INTERNAL_STORAGE_PATH
undefine TW_INTERNAL_STORAGE_MOUNT_POINT
TW_EXTERNAL_STORAGE_PATH := "/sdcard"
TW_EXTERNAL_STORAGE_MOUNT_POINT := "sdcard"
TW_DEFAULT_EXTERNAL_STORAGE := true
# Use MTP in recovery
undefine TW_EXCLUDE_MTP
