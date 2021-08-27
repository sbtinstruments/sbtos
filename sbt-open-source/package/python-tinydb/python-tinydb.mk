################################################################################
#
# python-jsonpatch
#
################################################################################

PYTHON_TINYDB_VERSION = v4.5.1
PYTHON_TINYDB_SITE = $(call github,msiemens,tinydb,$(PYTHON_JSONPATCH_VERSION))
PYTHON_TINYDB_SETUP_TYPE = setuptools
PYTHON_TINYDB_LICENSE = MIT
PYTHON_TINYDB_LICENSE_FILES = LICENSE

# TinyDB uses "poetry" as the build system. Buildroot doesn't
# currently have helpers for poetry-based builds. Luckily, TinyDB
# is a pure-python library so we can simply copy the relevant files over.
define PYTHON_TINYDB_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -d $(TARGET_DIR)/usr/lib/python3.9/site-packages/tinydb
	$(INSTALL) -m 644 $(@D)/tinydb/*.py $(TARGET_DIR)/usr/lib/python3.9/site-packages/tinydb
endef

$(eval $(generic-package))
