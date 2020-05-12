################################################################################
#
# python-maskin
#
################################################################################

PYTHON_MASKIN_VERSION = refs/tags/v4.0.1
PYTHON_MASKIN_SITE = git@github.com:sbtinstruments/maskin.git
PYTHON_MASKIN_SITE_METHOD = git
PYTHON_MASKIN_SETUP_TYPE = setuptools
PYTHON_MASKIN_LICENSE = PROPRIETARY
PYTHON_MASKIN_REDISTRIBUTE = NO

$(eval $(python-package))

