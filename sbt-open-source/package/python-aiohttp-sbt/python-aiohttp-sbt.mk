################################################################################
#
# python-aiohttp-sbt
#
################################################################################

PYTHON_AIOHTTP_SBT_VERSION = refs/tags/v3.7.3-sbt.0
PYTHON_AIOHTTP_SBT_SITE = https://github.com/sbtinstruments/aiohttp.git
PYTHON_AIOHTTP_SBT_SITE_METHOD = git
# For the http-parser submodule
PYTHON_AIOHTTP_SBT_GIT_SUBMODULES = YES
PYTHON_AIOHTTP_SBT_SETUP_TYPE = setuptools
PYTHON_AIOHTTP_SBT_LICENSE = Apache-2.0
PYTHON_AIOHTTP_SBT_LICENSE_FILES = LICENSE.txt

ifeq ($(BR2_PACKAGE_HOST_PYTHON_CYTHON),y)
PYTHON_AIOHTTP_SBT_DEPENDENCIES += host-python-cython
# Multidict for the ./tools/gen.py script
# Unfortunately, the built-in "python-multidict" package can't
# install on the host. Therefore, we use the "python-multidict-sbt"
# package.
# Note that at run-time (on the target), the we use the
# built-in "python-multidict".
PYTHON_AIOHTTP_SBT_DEPENDENCIES += host-python-multidict-sbt
endif

define PYTHON_AIOHTTP_SBT_CYTHONIZE
	$(HOST_PKG_PYTHON_SETUPTOOLS_ENV) $(HOST_MAKE_ENV) $(MAKE) -C $(@D) cythonize
endef

PYTHON_AIOHTTP_SBT_PRE_BUILD_HOOKS += PYTHON_AIOHTTP_SBT_CYTHONIZE

$(eval $(python-package))

