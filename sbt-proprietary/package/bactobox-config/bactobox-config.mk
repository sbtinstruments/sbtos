################################################################################
#
# bactobox-config
#
################################################################################

BACTOBOX_CONFIG_VERSION = bactobox-v4.3.0
BACTOBOX_CONFIG_SITE = git@github.com:sbtinstruments/green-mango-config.git
BACTOBOX_CONFIG_SITE_METHOD = git
BACTOBOX_CONFIG_LICENSE = PROPRIETARY
BACTOBOX_CONFIG_REDISTRIBUTE = NO

define BACTOBOX_CONFIG_INSTALL_TARGET_CMDS
	cp -R --no-dereference --preserve=mode,links -v $(@D)/etc/* $(TARGET_DIR)/etc/
endef

$(eval $(generic-package))