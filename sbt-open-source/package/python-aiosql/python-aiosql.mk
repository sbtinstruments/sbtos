################################################################################
#
# python-aiosql
#
################################################################################

PYTHON_AIOSQL_VERSION = 3.0.0
PYTHON_AIOSQL_SITE = $(call github,nackjicholson,aiosql,$(PYTHON_AIOSQL_VERSION))
PYTHON_AIOSQL_SETUP_TYPE = setuptools
PYTHON_AIOSQL_LICENSE = BSD-2-Clause
PYTHON_AIOSQL_LICENSE_FILES = LICENSE

# python-aiosql uses "poetry" as the build system. Buildroot doesn't
# currently have helpers for poetry-based builds. Luckily, python-aiosql
# is a pure-python library so we can simply copy the relevant files over.
define PYTHON_AIOSQL_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -d $(TARGET_DIR)/usr/lib/python3.9/site-packages/aiosql
	$(INSTALL) -m 644 $(@D)/aiosql/*.py $(TARGET_DIR)/usr/lib/python3.9/site-packages/aiosql
	$(INSTALL) -m 755 -d $(TARGET_DIR)/usr/lib/python3.9/site-packages/aiosql/adapters
	$(INSTALL) -m 644 $(@D)/aiosql/adapters/*.py $(TARGET_DIR)/usr/lib/python3.9/site-packages/aiosql/adapters
endef

$(eval $(generic-package))
