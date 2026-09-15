ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
THEOS_PACKAGE_SCHEME = roothide

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TMCChargingCultivation

TMCChargingCultivation_FILES = Tweak.x
TMCChargingCultivation_CFLAGS = -fobjc-arc
TMCChargingCultivation_FRAMEWORKS = UIKit QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk
