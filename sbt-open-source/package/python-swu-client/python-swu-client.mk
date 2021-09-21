################################################################################
#
# python-swu-client
#
################################################################################

PYTHON_SWU_CLIENT_VERSION = refs/tags/v0.1.0
PYTHON_SWU_CLIENT_SITE = git@github.com:sbtinstruments/swu-client.git
PYTHON_SWU_CLIENT_SITE_METHOD = git
PYTHON_SWU_CLIENT_SETUP_TYPE = setuptools
PYTHON_SWU_CLIENT_LICENSE = MIT
PYTHON_SWU_CLIENT_LICENSE_FILES = LICENSE
PYTHON_SWU_CLIENT_REDISTRIBUTE = NO

$(eval $(python-package))
