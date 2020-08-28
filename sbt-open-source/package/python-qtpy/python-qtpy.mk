################################################################################
#
# python-qtpy
#
################################################################################

PYTHON_QTPY_VERSION = v1.9.0
PYTHON_QTPY_SITE = $(call github,spyder-ide,qtpy,$(PYTHON_QTPY_VERSION))
PYTHON_QTPY_SETUP_TYPE = setuptools
PYTHON_QTPY_LICENSE = MIT
PYTHON_QTPY_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
