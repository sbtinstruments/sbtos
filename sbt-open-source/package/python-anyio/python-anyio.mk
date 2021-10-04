################################################################################
#
# python-asyncio-mqtt
#
################################################################################

PYTHON_ANYIO_VERSION = 3.3.2
PYTHON_ANYIO_SITE = $(call github,agronholm,anyio,$(PYTHON_ANYIO_VERSION))
PYTHON_ANYIO_SETUP_TYPE = setuptools
PYTHON_ANYIO_LICENSE = MIT
PYTHON_ANYIO_LICENSE_FILES = LICENSE

$(eval $(python-package))

