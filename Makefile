TARGET := iphone:clang:latest:15.0
ARCHS = arm64 arm64e
DEBUG = 0
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = cemobile

cemobile_FILES = Tweak.xm
cemobile_CFLAGS = -fobjc-arc
cemobile_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
