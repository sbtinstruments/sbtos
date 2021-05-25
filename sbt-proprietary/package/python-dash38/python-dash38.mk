################################################################################
#
# python-dash38
#
################################################################################

PYTHON_DASH38_VERSION = refs/tags/v12.15.0
PYTHON_DASH38_SITE = git@github.com:sbtinstruments/dash.git
PYTHON_DASH38_SITE_METHOD = git
PYTHON_DASH38_SETUP_TYPE = setuptools
PYTHON_DASH38_LICENSE = PROPRIETARY
PYTHON_DASH38_REDISTRIBUTE = NO

# HACK: Include binary distribution of python 3.8 as part of dash
#
# This also means that we package all dependencies of dash (and then some) as
# part of this distribution.
#
# This is due to a bug with qasync and python 3.9. All of this is a bit of a
# mess at the moment. Hopefully, we can revert to a single python version soon.
#
# Bug tracker: https://github.com/CabbageDevelopment/qasync/issues/28

define PYTHON_DASH38_INSTALL_TARGET_CMDS
	cp $(PYTHON_DASH38_PKGDIR)/python3.8/bin/python3.8 $(TARGET_DIR)/usr/bin
	cp $(PYTHON_DASH38_PKGDIR)/python3.8/lib/* $(TARGET_DIR)/usr/lib
	cp -r $(PYTHON_DASH38_PKGDIR)/python3.8/python3.8 $(TARGET_DIR)/usr/lib

	cp $(@D)/scripts/dash $(TARGET_DIR)/usr/bin/dash
	cp -r $(@D)/dash $(TARGET_DIR)/usr/lib/python3.8/site-packages
endef

$(eval $(python-package))
