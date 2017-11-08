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

# Kernel Config
TARGET_KERNEL_CONFIG := custom_galaxys4gmtd_defconfig

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/samsung/galaxys4gmtd/bluetooth

TARGET_OTA_ASSERT_DEVICE := galaxys4g,galaxys4gmtd,telusgalaxys4g,telusgalaxys4gmtd,SGH-T959P,SGH-T959V,SGH-T959W

# Import the aries-common BoardConfigCommon.mk
include device/samsung/aries-common/BoardConfigCommon.mk

# Override stuff that doesn't match aries-common
BOARD_SECOND_CAMERA_DEVICE := /dev/video2
BOARD_CAMERA_FFC_FLIPPED := true
TARGET_RECOVERY_FSTAB := device/samsung/galaxys4gmtd/rootdir/fstab.aries

# Header overrides
TARGET_SPECIFIC_HEADER_PATH := device/samsung/galaxys4gmtd/overlay/include

# Releasetools
TARGET_RELEASETOOLS_EXTENSIONS := device/samsung/galaxys4gmtd

# SELinux
BOARD_SEPOLICY_DIRS += device/samsung/galaxys4gmtd/sepolicy

# Based on kernel header
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 629145600
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := squashfs
BOARD_CACHEIMAGE_PARTITION_SIZE := 319815680
BOARD_SYSTEMIMAGE_SQUASHFS_COMPRESSOR := gzip

# TWRP
RECOVERY_SDCARD_ON_DATA := true
TW_EXTERNAL_STORAGE_MOUNT_POINT :=
TW_EXTERNAL_STORAGE_PATH :=
TW_INTERNAL_STORAGE_MOUNT_POINT :=
TW_INTERNAL_STORAGE_PATH :=
