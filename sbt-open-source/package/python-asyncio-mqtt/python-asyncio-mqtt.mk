################################################################################
#
# python-asyncio-mqtt
#
################################################################################

PYTHON_ASYNCIO_MQTT_VERSION = v0.7.0
PYTHON_ASYNCIO_MQTT_SITE = $(call github,sbtinstruments,asyncio-mqtt,$(PYTHON_ASYNCIO_MQTT_VERSION))
PYTHON_ASYNCIO_MQTT_SETUP_TYPE = setuptools
PYTHON_ASYNCIO_MQTT_LICENSE = BSD-3-Clause
PYTHON_ASYNCIO_MQTT_LICENSE_FILES = LICENSE

$(eval $(python-package))

