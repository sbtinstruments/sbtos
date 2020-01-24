################################################################################
#
# python-maskin
#
################################################################################

PYTHON_MASKIN_VERSION = refs/tags/v3.0.0-beta.12
PYTHON_MASKIN_SITE = git@github.com:sbtinstruments/maskin.git
PYTHON_MASKIN_SITE_METHOD = git
PYTHON_MASKIN_SETUP_TYPE = setuptools
PYTHON_MASKIN_LICENSE = PROPRIETARY
PYTHON_MASKIN_REDISTRIBUTE = NO

$(eval $(python-package))

