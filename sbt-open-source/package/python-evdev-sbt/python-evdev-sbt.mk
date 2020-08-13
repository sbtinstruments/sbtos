################################################################################
#
# python-evdev-sbt
#
################################################################################

PYTHON_EVDEV_SBT_VERSION = 9871fad77e89dde3d32c433d5414f43fe5ede85a
PYTHON_EVDEV_SBT_SITE = https://github.com/sbtinstruments/python-evdev.git
PYTHON_EVDEV_SBT_SITE_METHOD = git
PYTHON_EVDEV_SBT_LICENSE = BSD-3-clause
PYTHON_EVDEV_SBT_LICENSE_FILES = LICENSE
PYTHON_EVDEV_SBT_SETUP_TYPE = setuptools

# Per default the setup.py script will use the linux headers from the
# build computer. This is bad. We can use the headers from staging
# (belonging to the target) instead via the "--evdev-headers" parameters.
define PYTHON_EVDEV_SBT_BUILD_ECODES
	(cd $(PYTHON_EVDEV_SBT_BUILDDIR)/; \
		$(PYTHON_EVDEV_SBT_BASE_ENV) $(PYTHON_EVDEV_SBT_ENV) \
		$(PYTHON_EVDEV_SBT_PYTHON_INTERPRETER) setup.py \
		build_ecodes --evdev-headers $(STAGING_DIR)/usr/include/linux/input.h:$(STAGING_DIR)/usr/include/linux/input-event-codes.h \
	)
endef

PYTHON_EVDEV_SBT_PRE_BUILD_HOOKS += PYTHON_EVDEV_SBT_BUILD_ECODES

$(eval $(python-package))
