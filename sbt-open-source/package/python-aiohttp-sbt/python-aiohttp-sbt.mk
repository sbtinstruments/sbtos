################################################################################
#
# python-aiohttp-sbt
#
################################################################################

PYTHON_AIOHTTP_SBT_VERSION = 4.0.0a1
PYTHON_AIOHTTP_SBT_SOURCE = aiohttp-$(PYTHON_AIOHTTP_SBT_VERSION).tar.gz
# We use the 'release' archive (as opposed to the 'source' archive) since the
# 'release' archive contains the auto-generated .c files used for Cython
# modules.
PYTHON_AIOHTTP_SBT_SITE = https://github.com/aio-libs/aiohttp/releases/download/v${PYTHON_AIOHTTP_SBT_VERSION}
PYTHON_AIOHTTP_SBT_SETUP_TYPE = setuptools
PYTHON_AIOHTTP_SBT_LICENSE = Apache-2.0
PYTHON_AIOHTTP_SBT_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))

