################################################################################
#
# python-staten
#
################################################################################

PYTHON_STATEN_VERSION = refs/tags/v0.14.0
PYTHON_STATEN_SITE = git@github.com:sbtinstruments/staten.git
PYTHON_STATEN_SITE_METHOD = git
PYTHON_STATEN_SETUP_TYPE = setuptools
PYTHON_STATEN_LICENSE = PROPRIETARY
PYTHON_STATEN_REDISTRIBUTE = NO

$(eval $(python-package))

