TARGET := iphone:clang:16.5:15.0
INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64 arm64e
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TapTapTipTapTime

TapTapTipTapTime_FILES = Tweak.x
TapTapTipTapTime_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/tweak.mk

SUBPROJECTS += TapTapTipTapTimePreferences
include $(THEOS)/makefiles/aggregate.mk
