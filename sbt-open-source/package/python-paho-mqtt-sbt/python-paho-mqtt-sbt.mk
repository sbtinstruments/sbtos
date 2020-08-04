################################################################################
#
# python-paho-mqtt-sbt
#
################################################################################

PYTHON_PAHO_MQTT_SBT_VERSION = 1.5.0
PYTHON_PAHO_MQTT_SBT_SOURCE = paho-mqtt-$(PYTHON_PAHO_MQTT_SBT_VERSION).tar.gz
PYTHON_PAHO_MQTT_SBT_SITE = https://files.pythonhosted.org/packages/59/11/1dd5c70f0f27a88a3a05772cd95f6087ac479fac66d9c7752ee5e16ddbbc
PYTHON_PAHO_MQTT_SBT_LICENSE = EPL-1.0 or EDLv1.0
PYTHON_PAHO_MQTT_SBT_LICENSE_FILES = LICENSE.txt edl-v10 epl-v10
PYTHON_PAHO_MQTT_SBT_SETUP_TYPE = setuptools

$(eval $(python-package))
