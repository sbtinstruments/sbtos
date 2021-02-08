################################################################################
#
# python-multidict-sbt
#
################################################################################

PYTHON_MULTIDICT_SBT_VERSION = 5.0.0
PYTHON_MULTIDICT_SBT_SOURCE = multidict-$(PYTHON_MULTIDICT_SBT_VERSION).tar.gz
PYTHON_MULTIDICT_SBT_SITE = https://files.pythonhosted.org/packages/d2/5a/e95b0f9ebacd42e094e229a9a0a9e44d02876abf64969d0cb07dadcf3c4a
PYTHON_MULTIDICT_SBT_SETUP_TYPE = setuptools
PYTHON_MULTIDICT_SBT_LICENSE = Apache-2.0
PYTHON_MULTIDICT_SBT_LICENSE_FILES = LICENSE

$(eval $(python-package))
$(eval $(host-python-package))
