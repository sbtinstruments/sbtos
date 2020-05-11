################################################################################
#
# python-asyncqt
#
################################################################################

PYTHON_ASYNCQT_VERSION = v0.8.0
PYTHON_ASYNCQT_SITE = $(call github,gmarull,asyncqt,$(PYTHON_ASYNCQT_VERSION))
PYTHON_ASYNCQT_SETUP_TYPE = setuptools
PYTHON_ASYNCQT_LICENSE = BSD-2-Clause
PYTHON_ASYNCQT_LICENSE_FILES = LICENSE

$(eval $(python-package))
