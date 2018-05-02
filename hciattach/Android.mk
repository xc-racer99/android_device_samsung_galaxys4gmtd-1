LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

BLUEZ_VERSION := 5.49

ANDROID_VERSION := $(shell echo $(PLATFORM_VERSION) | awk -F. '{ printf "0x%02d%02d%02d",$$1,$$2,$$3 }')

# Specify common compiler flags
BLUEZ_COMMON_CFLAGS := -DVERSION=\"$(BLUEZ_VERSION)\" \
			-DANDROID_VERSION=$(ANDROID_VERSION) \
			-DANDROID_STORAGEDIR=\"/data/misc/bluetooth\" \
			-DHAVE_LINUX_IF_ALG_H \
			-DHAVE_LINUX_TYPES_H \

# Enable warnings enabled in autotools build
BLUEZ_COMMON_CFLAGS += -Wall -Wextra \
			-Wdeclaration-after-statement \
			-Wmissing-declarations \
			-Wredundant-decls \
			-Wcast-align \

# Disable warnings enabled by Android but not enabled in autotools build
BLUEZ_COMMON_CFLAGS += -Wno-pointer-arith \
			-Wno-missing-field-initializers \
			-Wno-unused-parameter \

LOCAL_SRC_FILES := \
	tools/hciattach.c \
	tools/hciattach_st.c \
	tools/hciattach_ti.c \
	tools/hciattach_tialt.c \
	tools/hciattach_ath3k.c \
	tools/hciattach_qualcomm.c \
	tools/hciattach_intel.c \
	tools/hciattach_bcm43xx.c \
	lib/bluetooth.c \
	lib/hci.c \

LOCAL_CFLAGS := $(BLUEZ_COMMON_CFLAGS)

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := hciattach

include $(BUILD_EXECUTABLE)
