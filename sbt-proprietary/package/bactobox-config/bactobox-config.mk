################################################################################
#
# bactobox-config
#
################################################################################

<<<<<<< HEAD
BACTOBOX_CONFIG_VERSION = bactobox-v3.11.0
=======
BACTOBOX_CONFIG_VERSION = bactobox-v3.10.0
>>>>>>> d8653bb45d13bf774431d4ec426f557e921f50c0
BACTOBOX_CONFIG_SITE = git@github.com:sbtinstruments/green-mango-config.git
BACTOBOX_CONFIG_SITE_METHOD = git
BACTOBOX_CONFIG_LICENSE = PROPRIETARY
BACTOBOX_CONFIG_REDISTRIBUTE = NO

define BACTOBOX_CONFIG_INSTALL_TARGET_CMDS
	cp -R --no-dereference --preserve=mode,links -v $(@D)/etc/* $(TARGET_DIR)/etc/
endef

$(eval $(generic-package))
