################################################################################
#
# python-geist
#
################################################################################

PYTHON_GEIST_VERSION = refs/tags/v7.4.0
PYTHON_GEIST_SITE = git@github.com:sbtinstruments/geist.git
PYTHON_GEIST_SITE_METHOD = git
PYTHON_GEIST_SETUP_TYPE = setuptools
PYTHON_GEIST_LICENSE = PROPRIETARY
PYTHON_GEIST_REDISTRIBUTE = NO

$(eval $(python-package))

