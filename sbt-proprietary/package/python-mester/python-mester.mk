################################################################################
#
# python-mester
#
################################################################################

PYTHON_MESTER_VERSION = refs/tags/v7.0.0
PYTHON_MESTER_SITE = git@github.com:sbtinstruments/mester.git
PYTHON_MESTER_SITE_METHOD = git
PYTHON_MESTER_SETUP_TYPE = setuptools
PYTHON_MESTER_LICENSE = PROPRIETARY
PYTHON_MESTER_REDISTRIBUTE = NO

$(eval $(python-package))

