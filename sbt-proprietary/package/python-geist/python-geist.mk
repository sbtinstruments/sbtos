################################################################################
#
# python-geist
#
################################################################################

PYTHON_GEIST_VERSION = refs/tags/v3.0.0-rc.3
PYTHON_GEIST_SITE = git@github.com:sbtinstruments/geist.git
PYTHON_GEIST_SITE_METHOD = git
PYTHON_GEIST_SETUP_TYPE = setuptools
PYTHON_GEIST_LICENSE = PROPRIETARY
PYTHON_GEIST_REDISTRIBUTE = NO

$(eval $(python-package))

