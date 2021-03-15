################################################################################
#
# python-baxter
#
################################################################################

PYTHON_BAXTER_VERSION = e8151f01287a04a43564a220375b0f497f3ad83c
PYTHON_BAXTER_SITE = git@github.com:sbtinstruments/baxter.git
PYTHON_BAXTER_SITE_METHOD = git
PYTHON_BAXTER_SETUP_TYPE = setuptools
PYTHON_BAXTER_LICENSE = PROPRIETARY
PYTHON_BAXTER_REDISTRIBUTE = NO

ifeq ($(BR2_PACKAGE_HOST_PYTHON_CYTHON),y)
PYTHON_BAXTER_DEPENDENCIES += host-python-cython
endif

$(eval $(python-package))

