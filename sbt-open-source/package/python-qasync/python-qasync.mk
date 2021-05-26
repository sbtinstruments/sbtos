################################################################################
#
# python-qasync
#
################################################################################

PYTHON_QASYNC_VERSION = aadf90d5c9f74917c4a59926d1b499ddfc48ab78
# This is a fork of the original qasync. The fork contains a fix to the high
# CPU usage issue in qasync:
#   https://github.com/CabbageDevelopment/qasync/pull/40
#
# TODO: Use the original qasync once the authors merge the abovementioned pull
# request.
#
# The original qasync is at:
#   https://github.com/CabbageDevelopment/qasync
PYTHON_QASYNC_SITE = $(call github,occasionallydavid,qasync,$(PYTHON_QASYNC_VERSION))
PYTHON_QASYNC_SETUP_TYPE = setuptools
PYTHON_QASYNC_LICENSE = BSD-2-Clause
PYTHON_QASYNC_LICENSE_FILES = LICENSE

$(eval $(python-package))
