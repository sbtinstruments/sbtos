################################################################################
#
# rm-neue
#
################################################################################

RM_NEUE_VERSION = v1.0.0
RM_NEUE_SITE = git@github.com:sbtinstruments/rm-neue.git
RM_NEUE_SITE_METHOD = git
RM_NEUE_LICENSE = PROPRIETARY
RM_NEUE_REDISTRIBUTE = NO

define RM_NEUE_INSTALL_TARGET_CMDS
	cp -R --no-dereference --preserve=mode,links -v $(@D)/* $(TARGET_DIR)/usr/lib/fonts/
endef

$(eval $(generic-package))
