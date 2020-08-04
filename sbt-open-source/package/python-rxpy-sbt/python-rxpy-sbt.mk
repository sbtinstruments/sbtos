################################################################################
#
# python-rxpy-sbt
#
################################################################################

PYTHON_RXPY_SBT_VERSION = v3.1.1-sbt.1
PYTHON_RXPY_SBT_SITE = $(call github,sbtinstruments,rxpy,$(PYTHON_RXPY_SBT_VERSION))
PYTHON_RXPY_SBT_SETUP_TYPE = setuptools
PYTHON_RXPY_SBT_LICENSE = MIT
PYTHON_RXPY_SBT_LICENSE_FILES = LICENSE

$(eval $(python-package))

