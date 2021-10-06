################################################################################
#
# python-asyncio-mqtt
#
################################################################################

PYTHON_ANYIO_VERSION = 3.3.2
PYTHON_ANYIO_SOURCE = anyio-$(PYTHON_ANYIO_VERSION).tar.gz
PYTHON_ANYIO_SITE = https://files.pythonhosted.org/packages/bf/3f/4d9972a2190759ac2a576c8fa8b64102a11932ccfb10ed928a116e283f5c
PYTHON_ANYIO_SETUP_TYPE = setuptools
PYTHON_ANYIO_LICENSE = MIT
PYTHON_ANYIO_LICENSE_FILES = LICENSE
PYTHON_ANYIO_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
