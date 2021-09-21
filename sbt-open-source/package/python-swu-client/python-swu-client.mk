################################################################################
#
# python-swu-client
#
################################################################################

PYTHON_SWU_CLIENT_VERSION = v0.1.1
PYTHON_SWU_CLIENT_SITE = $(call github,sbtinstruments,swu-client,$(PYTHON_SWU_CLIENT_VERSION))
PYTHON_SWU_CLIENT_SETUP_TYPE = setuptools
PYTHON_SWU_CLIENT_LICENSE = MIT
PYTHON_SWU_CLIENT_LICENSE_FILES = LICENSE

$(eval $(python-package))
