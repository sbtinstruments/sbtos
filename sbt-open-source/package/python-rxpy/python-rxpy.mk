################################################################################
#
# python-rxpy
#
################################################################################

PYTHON_RXPY_VERSION = v3.0.1
PYTHON_RXPY_SITE = $(call github,reactivex,rxpy,$(PYTHON_RXPY_VERSION))
PYTHON_RXPY_SETUP_TYPE = setuptools
PYTHON_RXPY_LICENSE = MIT
PYTHON_RXPY_LICENSE_FILES = LICENSE

$(eval $(python-package))

