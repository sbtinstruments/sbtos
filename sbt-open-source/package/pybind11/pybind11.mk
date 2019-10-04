################################################################################
#
# pybind11
#
################################################################################

PYBIND11_VERSION = v2.4.2
PYBIND11_SITE = $(call github,pybind,pybind11,$(PYBIND11_VERSION))
PYBIND11_LICENSE = BSD-3-Clause
PYBIND11_LICENSE_FILES = LICENSE

# Note the use of "cp" instead of "$(INSTALL)" as the latter does not handle
# recursion whereas the former does.
#
# Reference: https://stackoverflow.com/a/47084404/554283
define HOST_PYBIND11_INSTALL_CMDS
	cp -R --no-dereference --preserve=mode,links -v $(@D)/include/pybind11 $(STAGING_DIR)/usr/include/
endef

$(eval $(host-generic-package))
