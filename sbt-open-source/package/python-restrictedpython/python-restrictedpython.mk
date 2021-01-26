################################################################################
#
# python-restrictedpython
#
################################################################################

PYTHON_RESTRICTEDPYTHON_VERSION = 5.1
PYTHON_RESTRICTEDPYTHON_SITE = $(call github,zopefoundation,RestrictedPython,$(PYTHON_RESTRICTEDPYTHON_VERSION))
PYTHON_RESTRICTEDPYTHON_SETUP_TYPE = setuptools
PYTHON_RESTRICTEDPYTHON_LICENSE = ZPL-2.1
PYTHON_RESTRICTEDPYTHON_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))

