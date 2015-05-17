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
TARGET_KERNEL_CONFIG := cyanogenmod_telusgalaxys4gmtd_defconfig

# Recovery
BOARD_CUSTOM_RECOVERY_KEYMAPPING := ../../device/samsung/telusgalaxys4gmtd/recovery/recovery_keys.c

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/samsung/telusgalaxys4gmtd/bluetooth

TARGET_OTA_ASSERT_DEVICE := telusgalaxys4g,telusgalaxys4gmtd,SGH-T959P,galaxys4gmtd

# header overrides
TARGET_SPECIFIC_HEADER_PATH := device/samsung/telusgalaxys4gmtd/overlay/include

# Import the aries-common BoardConfigCommon.mk
include device/samsung/aries-common/BoardConfigCommon.mk

# Override stuff that doesn't match aries-common
TARGET_USERIMAGES_USE_EXT4 := false
BOARD_SECOND_CAMERA_DEVICE := /dev/video2
TARGET_PROVIDES_LIBCAMERA := true

# Based on kernel header
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 403701760
BOARD_USERDATAIMAGE_PARTITION_SIZE := 545259520
