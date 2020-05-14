################################################################################
#
# python-cellmate
#
################################################################################

PYTHON_CELLMATE_VERSION = refs/tags/v5.0.2
PYTHON_CELLMATE_SITE = git@github.com:sbtinstruments/cellmate.git
PYTHON_CELLMATE_SITE_METHOD = git
PYTHON_CELLMATE_SETUP_TYPE = setuptools
PYTHON_CELLMATE_LICENSE = PROPRIETARY
PYTHON_CELLMATE_REDISTRIBUTE = NO

$(eval $(python-package))

