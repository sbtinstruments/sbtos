################################################################################
#
# python-frog
#
################################################################################

PYTHON_FROG_VERSION = refs/tags/v0.0.1
PYTHON_FROG_SITE = git@github.com:sbtinstruments/frog.git
PYTHON_FROG_SITE_METHOD = git
PYTHON_FROG_SETUP_TYPE = setuptools
PYTHON_FROG_LICENSE = PROPRIETARY
PYTHON_FROG_REDISTRIBUTE = NO

$(eval $(python-package))

