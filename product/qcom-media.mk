# OMX
PRODUCT_PACKAGES += \
    libc2dcolorconvert \
    libdashplayer \
    libdivxdrmdecrypt \
    libextmedia_jni \
    libOmxAacEnc \
    libOmxAmrEnc \
    libOmxCore \
    libOmxEvrcEnc \
    libOmxQcelp13Enc \
    libOmxSwVencMpeg4 \
    libOmxVdec \
    libOmxVdecHevc \
    libOmxVenc \
    libOmxVidcCommon \
    libstagefrighthw \
    libstagefright_soft_flacdec

PRODUCT_PROPERTY_OVERRIDES += \
    mm.enable.smoothstreaming=true \
    media.aac_51_output_enabled=true \
    vidc.debug.level=1 \
    vidc.debug.perf.mode=2 \
    vidc.enc.dcvs.extra-buff-count=2 \
    persist.camera.cpp.duplication=false
   #qcom.hw.aac.encoder=true
