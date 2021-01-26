################################################################################
#
# python-jmespath-sbt
#
################################################################################

PYTHON_JMESPATH_SBT_VERSION = 0.10.0
PYTHON_JMESPATH_SBT_SITE = $(call github,jmespath,jmespath,$(PYTHON_JMESPATH_SBT_VERSION))
PYTHON_JMESPATH_SBT_SETUP_TYPE = setuptools
PYTHON_JMESPATH_SBT_LICENSE = MIT
PYTHON_JMESPATH_SBT_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))

