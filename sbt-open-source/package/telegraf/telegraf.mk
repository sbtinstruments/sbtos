################################################################################
#
# telegraf
#
################################################################################

TELEGRAF_VERSION = 1.12.3
TELEGRAF_SOURCE = telegraf-$(TELEGRAF_VERSION)_linux_armhf.tar.gz
TELEGRAF_SITE =  https://dl.influxdata.com/telegraf/releases
TELEGRAF_LICENSE = MIT
TELEGRAF_LICENSE_FILES = LICENSE

TELEGRAF_BUILD_BIN_DIR = $(@D)/telegraf/usr/bin
TELEGRAF_BIN_TELEGRAF = ${TELEGRAF_BUILD_BIN_DIR}/telegraf

define TELEGRAF_BUILD_CMDS
	@echo "INFO: Not building. We use a pre-built binary for linux-armhf."
endef

ifeq ($(BR2_PACKAGE_TELEGRAF_COMPRESS_BINARIES),y)
TELEGRAF_DEPENDENCIES += host-upx
HOST_STRIP = $(TARGET_CROSS)strip
HOST_UPX = $(HOST_DIR)/bin/upx
TELEGRAF_BIN_TELEGRAF_COMPR = ${TELEGRAF_BUILD_BIN_DIR}/telegraf_compr
define TELEGRAF_BUILD_CMD_COMPRESS
	@echo "INFO: Packaging the otherwise HUGE binary using UPX."
	rm -f ${TELEGRAF_BIN_TELEGRAF_COMPR}
	${HOST_STRIP} -o ${TELEGRAF_BIN_TELEGRAF_COMPR} $(TELEGRAF_BIN_TELEGRAF)
	$(HOST_UPX) ${TELEGRAF_BIN_TELEGRAF_COMPR}
endef
TELEGRAF_BUILD_CMDS += ${TELEGRAF_BUILD_CMD_COMPRESS}
TELEGRAF_INSTALL_TELEGRAF = ${TELEGRAF_BIN_TELEGRAF_COMPR}
else
TELEGRAF_INSTALL_TELEGRAF = ${TELEGRAF_BIN_TELEGRAF}
endif

define TELEGRAF_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(TELEGRAF_INSTALL_TELEGRAF) $(TARGET_DIR)/usr/bin/telegraf
endef

$(eval $(generic-package))

