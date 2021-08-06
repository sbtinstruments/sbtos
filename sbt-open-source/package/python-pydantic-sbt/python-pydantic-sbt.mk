################################################################################
#
# python-pydantic-sbt
#
################################################################################

PYTHON_PYDANTIC_SBT_VERSION = 1.8.2
PYTHON_PYDANTIC_SBT_SOURCE = pydantic-$(PYTHON_PYDANTIC_SBT_VERSION).tar.gz
PYTHON_PYDANTIC_SBT_SITE = https://files.pythonhosted.org/packages/b9/d2/12a808613937a6b98cd50d6467352f01322dc0d8ca9fb5b94441625d6684
PYTHON_PYDANTIC_SBT_SETUP_TYPE = setuptools
PYTHON_PYDANTIC_SBT_LICENSE = MIT
PYTHON_PYDANTIC_SBT_LICENSE_FILES = LICENSE

$(eval $(python-package))
