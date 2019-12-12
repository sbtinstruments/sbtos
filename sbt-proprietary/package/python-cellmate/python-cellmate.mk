################################################################################
#
# python-cellmate
#
################################################################################

PYTHON_CELLMATE_VERSION = refs/tags/v1.0.0-beta.4
PYTHON_CELLMATE_SITE = git@github.com:sbtinstruments/cellmate.git
PYTHON_CELLMATE_SITE_METHOD = git
PYTHON_CELLMATE_SETUP_TYPE = setuptools
PYTHON_CELLMATE_LICENSE = PROPRIETARY
PYTHON_CELLMATE_REDISTRIBUTE = NO

$(eval $(python-package))

