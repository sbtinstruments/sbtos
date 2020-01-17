################################################################################
#
# python-daemon-sbt
#
################################################################################

PYTHON_DAEMON_SBT_VERSION = 2.2.4
PYTHON_DAEMON_SBT_SOURCE = python-daemon-$(PYTHON_DAEMON_SBT_VERSION).tar.gz
PYTHON_DAEMON_SBT_SITE = https://pypi.python.org/packages/source/p/python-daemon
PYTHON_DAEMON_SBT_LICENSE = Apache-2.0 (library), GPL-3.0+ (test, build)
PYTHON_DAEMON_SBT_LICENSE_FILES = LICENSE.ASF-2 LICENSE.GPL-3
PYTHON_DAEMON_SBT_SETUP_TYPE = setuptools
PYTHON_DAEMON_SBT_DEPENDENCIES = host-python-docutils

$(eval $(python-package))
