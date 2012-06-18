LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

TARGET_FRAMES_DIR := $(TARGET_OUT)/media/charging
LOCAL_FRAMES_DIR := $(LOCAL_PATH)/charging

copy_from := \
	charging-0.bgra \
	charging-10.bgra \
	charging-20.bgra \
	charging-30.bgra \
	charging-40.bgra \
	charging-50.bgra \
	charging-60.bgra \
	charging-70.bgra \
	charging-80.bgra \
	charging-90.bgra \
	charging-100.bgra

copy_to   := $(addprefix $(TARGET_FRAMES_DIR)/,$(copy_from))
copy_from := $(addprefix $(LOCAL_FRAMES_DIR)/,$(copy_from))

$(copy_to) : $(TARGET_FRAMES_DIR)/% : $(LOCAL_FRAMES_DIR)/% | $(ACP)
	$(transform-prebuilt-to-target)

#ALL_PREBUILT += $(copy_to)

include $(CLEAR_VARS)

LOCAL_MODULE := playlpm
LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := playlpm.c

LOCAL_SHARED_LIBRARIES := liblog libcutils
LOCAL_PRELINK_MODULE := false

include $(BUILD_EXECUTABLE)
