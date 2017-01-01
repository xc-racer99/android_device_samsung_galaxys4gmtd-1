# Boot animation
TARGET_SCREEN_HEIGHT := 800
TARGET_SCREEN_WIDTH := 480

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

$(call inherit-product, device/samsung/galaxys4gmtd/aosp_galaxys4gmtd.mk)

# Device identifier. This must come after all inclusions
PRODUCT_NAME := lineage_galaxys4gmtd
