################################################################################
#
# lab
#
################################################################################

LAB_VERSION = v4.0.0
LAB_SITE = git@github.com:sbtinstruments/lab-buildroot-release.git
LAB_SITE_METHOD = git
LAB_LICENSE = PROPRIETARY
LAB_REDISTRIBUTE = NO

define LAB_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/var/www/lab
	cp -R --no-dereference --preserve=mode,links -v $(@D)/dist/* $(TARGET_DIR)/var/www/lab
endef

$(eval $(generic-package))
