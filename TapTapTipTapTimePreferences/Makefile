include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = TapTapTipTapTimePreferences

TapTapTipTapTimePreferences_FILES = TTTRootListController.m TTTRootHeaderView.m TTTSwitchCell.m
TapTapTipTapTimePreferences_INSTALL_PATH = /Library/PreferenceBundles
TapTapTipTapTimePreferences_FRAMEWORKS = UIKit CoreGraphics
TapTapTipTapTimePreferences_PRIVATE_FRAMEWORKS = Preferences
TapTapTipTapTimePreferences_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/TapTapTipTapTimePreferences.plist$(ECHO_END)
