TA_RELEASE := 3

PRODUCT_PROPERTY_OVERRIDES += \
	ro.goo.developerid=TeamAcid \
	ro.goo.rom=CM9-galaxys4gmtd \
	ro.goo.version=$(TA_RELEASE) \
	ro.goo.board=$(PRODUCT_DEVICE)
