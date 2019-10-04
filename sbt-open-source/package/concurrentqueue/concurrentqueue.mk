################################################################################
#
# concurrentqueue
#
################################################################################

CONCURRENTQUEUE_VERSION = ffda5a47ffa8c8f4aa411f933b18509234dd4ab4
CONCURRENTQUEUE_SITE = https://github.com/cameron314/concurrentqueue.git
CONCURRENTQUEUE_SITE_METHOD = git
PYBIND11_LICENSE = BSD-2-Clause or BSL-1.0
PYBIND11_LICENSE_FILES = LICENSE.md

define HOST_CONCURRENTQUEUE_INSTALL_CMDS
	$(INSTALL) -D -m 0644 $(@D)/concurrentqueue.h $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 0644 $(@D)/blockingconcurrentqueue.h $(STAGING_DIR)/usr/include/
endef

$(eval $(host-generic-package))
