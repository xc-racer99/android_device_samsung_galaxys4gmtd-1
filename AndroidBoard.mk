LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)



#file := $(TARGET_RECOVERY_ROOT_OUT)/sbin/postrecoveryboot.sh
#ALL_PREBUILT += $(file)
#$(file) : $(LOCAL_PATH)/postrecoveryboot.sh | $(ACP)
#	$(transform-prebuilt-to-target)

# include the non-open-source counterpart to this file
-include vendor/samsung/galaxys4gmtd/AndroidBoardVendor.mk
