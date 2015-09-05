#
# Makefile for C8815
#
PORT_PRODUCT := c8815_emptying

# The original zip file, MUST be specified by each product
local-zip-file     := stockrom.zip

# The output zip file of MIUI rom, the default is porting_miui.zip if not specified
local-out-zip-file := MIUI_C8815.zip

# All apps from original ZIP, but has smali files chanded
local-modified-apps :=

local-modified-priv-apps :=

local-modified-jars :=

# All apks from MIUI
local-miui-removed-apps := MiuiCompass 

local-miui-removed-priv-apps := MediaProvider

local-miui-modified-apps := MiuiHome Settings QuickSearchBox Phone

# Config density for co-developers to use the aaps with HDPI or XHDPI resource,
# Default configrations are HDPI for ics branch and XHDPI for jellybean branch
local-density := XHDPI

# All apps need to be removed from original ZIP file
#local-remove-apps   := 

include phoneapps.mk

# To include the local targets before and after zip the final ZIP file, 
# and the local-targets should:
# (1) be defined after including porting.mk if using any global variable(see porting.mk)
# (2) the name should be leaded with local- to prevent any conflict with global targets
local-pre-zip := local-pre-zip-misc
local-after-zip:= local-put-to-phone

# The local targets after the zip file is generated, could include 'zip2sd' to 
# deliver the zip file to phone, or to customize other actions

include $(PORT_BUILD)/porting.mk

# To define any local-target
#updater := $(ZIP_DIR)/META-INF/com/google/android/updater-script
#pre_install_data_packages := $(TMP_DIR)/pre_install_apk_pkgname.txt
local-pre-zip-misc:

	@echo Replace custom lib
	cp -rf other/lib/* $(ZIP_DIR)/system/lib/

	@echo Replace custom bin
	cp other/bin/* $(ZIP_DIR)/system/bin/

	@echo Replace custom etc
	cp other/etc/* $(ZIP_DIR)/system/etc/

	@echo Replace custom xbin
	cp other/xbin/* $(ZIP_DIR)/system/xbin/

	@echo Replace custom vendor
	#cp -rf other/vendor/* $(ZIP_DIR)/system/vendor/

	@echo Delete some unneeded files
	rm -rf $(ZIP_DIR)/system/etc/.has_su_daemon
	rm -rf $(ZIP_DIR)/system/etc/install-cm-recovery.sh
	rm -rf $(ZIP_DIR)/system/recovery-from-boot.p
	@echo copy media
	cp -rf other/media/* $(ZIP_DIR)/system/media/
	@echo copy app
	cp -rf other/app/* $(ZIP_DIR)/system/app/

