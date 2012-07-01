TA_STABLE := 0
TA_RELEASE := 3
TA_VERSION := $(TA_STABLE).$(TA_RELEASE)

PRODUCT_PROPERTY_OVERRIDES += \
	ro.goo.developerid=TeamAcid \
	ro.goo.rom=CM9-galaxys4gmtd \
	ro.goo.version=$(TA_VERSION) \
	ro.goo.board=$(PRODUCT_DEVICE)
