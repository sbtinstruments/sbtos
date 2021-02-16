################################################################################
#
# dlib
#
################################################################################

DLIB_VERSION = v19.21
DLIB_SITE = $(call github,davisking,dlib,$(DLIB_VERSION))
DLIB_INSTALL_STAGING = YES
DLIB_LICENSE = BSL-1.0
DLIB_LICENSE_FILES = dlib/LICENSE.txt
DLIB_SUPPORTS_IN_SOURCE_BUILD = NO

DLIB_DEPENDENCIES += \
	openblas \
	jpeg \
	libpng

# Disable cuda support for now.
DLIB_CONF_OPTS = -DDLIB_USE_CUDA=OFF

ifeq ($(BR2_PACKAGE_GIFLIB),y)
DLIB_DEPENDENCIES += giflib
DLIB_CONF_OPTS += -DDLIB_GIF_SUPPORT=ON
else
DLIB_CONF_OPTS += -DDLIB_GIF_SUPPORT=OFF
endif

ifeq ($(BR2_PACKAGE_SQLITE),y)
DLIB_DEPENDENCIES += sqlite
DLIB_CONF_OPTS += -DDLIB_LINK_WITH_SQLITE3=ON
else
DLIB_CONF_OPTS += -DDLIB_LINK_WITH_SQLITE3=OFF
endif

ifeq ($(BR2_PACKAGE_DLIB_PYTHON_MODULE),y)

DLIB_DEPENDENCIES += $(if $(BR2_PACKAGE_PYTHON3),host-python3,host-python)

# python-dlib call cmake to build the python module library, so we have
# to provide at least CMAKE_TOOLCHAIN_FILE to crosscompile.
DLIB_PYTHON_BUILD_OPTS += \
	--set CMAKE_TOOLCHAIN_FILE="$(HOST_DIR)/share/buildroot/toolchainfile.cmake" \
	--set CMAKE_INSTALL_PREFIX="/usr" \
	--set CMAKE_COLOR_MAKEFILE=OFF \
	$(subst -D,--set ,$(DLIB_CONF_OPTS))

define DLIB_PYTHON_BUILD_TGT
	cd $(@D) && $(PKG_PYTHON_SETUPTOOLS_ENV) $(HOST_DIR)/bin/python \
		setup.py build $(DLIB_PYTHON_BUILD_OPTS)
endef
DLIB_POST_BUILD_HOOKS += DLIB_PYTHON_BUILD_TGT

define DLIB_PYTHON_INSTALL_TGT
	cd $(@D) && $(PKG_PYTHON_SETUPTOOLS_ENV) $(HOST_DIR)/bin/python \
		setup.py install --no-compile $(PKG_PYTHON_SETUPTOOLS_INSTALL_TARGET_OPTS)
endef
DLIB_POST_INSTALL_TARGET_HOOKS += DLIB_PYTHON_INSTALL_TGT

endif

$(eval $(cmake-package))