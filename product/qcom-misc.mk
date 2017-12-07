PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sec_config:system/etc/sec_config \
    $(LOCAL_PATH)/configs/msm_irqbalance.conf:system/vendor/etc/msm_irqbalance.conf \
    $(LOCAL_PATH)/configs/perf-profile0.conf:system/vendor/etc/perf-profile0.conf

PRODUCT_PACKAGES += \
    libcurl

# For android_filesystem_config.h
PRODUCT_PACKAGES += \
   fs_config_files

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

# try not to use big cores during dexopt
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.boot-dex2oat-threads=4 \
    dalvik.vm.dex2oat-threads=2 \
    dalvik.vm.image-dex2oat-threads=4
