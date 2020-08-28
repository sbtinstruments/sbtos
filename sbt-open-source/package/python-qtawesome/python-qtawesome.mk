################################################################################
#
# python-qtawesome
#
################################################################################

PYTHON_QTAWESOME_VERSION = fe53c2c54dcbf3a22eaca9a911ffd0ad01516e63
PYTHON_QTAWESOME_SITE = https://github.com/spyder-ide/qtawesome.git
PYTHON_QTAWESOME_SITE_METHOD = git
PYTHON_QTAWESOME_LICENSE = MIT
PYTHON_QTAWESOME_LICENSE_FILES = LICENSE.txt
PYTHON_QTAWESOME_SETUP_TYPE = setuptools

$(eval $(python-package))
