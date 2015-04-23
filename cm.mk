## Specify phone tech before including full_phone
$(call inherit-product, vendor/cm/config/gsm.mk)

# Release name
PRODUCT_RELEASE_NAME := GalaxyS4G

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/samsung/telusgalaxys4gmtd/full_telusgalaxys4gmtd.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := telusgalaxys4gmtd
PRODUCT_NAME := cm_telusgalaxys4gmtd
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SGH-T959P

# Build fingerprint / ID / Product name etc.
PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=SGH-T959P TARGET_DEVICE=SGH-T959P BUILD_FINGERPRINT=samsung/SGH-T959V/SGH-T959V:2.3.6/GINGERBREAD/VUVKJ6:user/release-keys PRIVATE_BUILD_DESC="SGH-T959V-user 2.3.6 GINGERBREAD VUVKJ6 release-keys"
