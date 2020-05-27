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

$(eval $(python-package))
