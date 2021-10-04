################################################################################
#
# python-asyncio-mqtt
#
################################################################################

PYTHON_SNIFFIO_VERSION = v1.2.0
PYTHON_SNIFFIO_SITE = $(call github,python-trio,sniffio,$(PYTHON_SNIFFIO_VERSION))
PYTHON_SNIFFIO_SETUP_TYPE = setuptools
PYTHON_SNIFFIO_LICENSE = MIT
PYTHON_SNIFFIO_LICENSE_FILES = LICENSE.MIT

$(eval $(python-package))

