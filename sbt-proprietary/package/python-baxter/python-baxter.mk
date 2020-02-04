################################################################################
#
# python-baxter
#
################################################################################

PYTHON_BAXTER_VERSION = refs/tags/v3.0.0-beta.14
PYTHON_BAXTER_SITE = git@github.com:sbtinstruments/baxter.git
PYTHON_BAXTER_SITE_METHOD = git
PYTHON_BAXTER_SETUP_TYPE = setuptools
PYTHON_BAXTER_LICENSE = PROPRIETARY
PYTHON_BAXTER_REDISTRIBUTE = NO
PYTHON_BAXTER_DEPENDENCIES = python-algpy

ifeq ($(BR2_PACKAGE_HOST_PYTHON_CYTHON),y)
PYTHON_BAXTER_DEPENDENCIES += host-python-cython
endif

$(eval $(python-package))

