################################################################################
#
# python-babel-sbt
#
################################################################################

PYTHON_BABEL_SBT_VERSION = 2.9.1
PYTHON_BABEL_SBT_SOURCE = Babel-$(PYTHON_BABEL_SBT_VERSION).tar.gz
PYTHON_BABEL_SBT_SITE = https://files.pythonhosted.org/packages/17/e6/ec9aa6ac3d00c383a5731cc97ed7c619d3996232c977bb8326bcbb6c687e
PYTHON_BABEL_SBT_SETUP_TYPE = setuptools
PYTHON_BABEL_SBT_LICENSE = BSD-3-Clause
PYTHON_BABEL_SBT_LICENSE_FILES = LICENSE

# Remove leading and trailing quotes
PYTHON_BABEL_SBT_FIND_ARGS := $(subst $\",,$(BR2_PACKAGE_PYTHON_BABEL_SBT_LOCALE_DATA_PURGE_EXPR))

define PYTHON_BABEL_SBT_LOCALE_DATA_PURGE
	echo ${PYTHON_BABEL_SBT_FIND_ARGS}
	find $(@D)/babel/locale-data -type f -not -name root.dat ${PYTHON_BABEL_SBT_FIND_ARGS} -delete
endef

ifneq ($(BR2_PACKAGE_PYTHON_BABEL_SBT_LOCALE_DATA_PURGE_EXPR),)
PYTHON_BABEL_SBT_PRE_BUILD_HOOKS += PYTHON_BABEL_SBT_LOCALE_DATA_PURGE
endif

$(eval $(python-package))
