################################################################################
#
# zeus-config
#
################################################################################

ZEUS_CONFIG_VERSION = zeus-v3.5.0
ZEUS_CONFIG_SITE = git@github.com:sbtinstruments/green-mango-config.git
ZEUS_CONFIG_SITE_METHOD = git
ZEUS_CONFIG_LICENSE = PROPRIETARY
ZEUS_CONFIG_REDISTRIBUTE = NO

define ZEUS_CONFIG_INSTALL_TARGET_CMDS
	cp -R --no-dereference --preserve=mode,links -v $(@D)/etc/* $(TARGET_DIR)/etc/
endef

$(eval $(generic-package))
