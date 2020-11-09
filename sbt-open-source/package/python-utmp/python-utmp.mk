################################################################################
#
# python-utmp
#
################################################################################

PYTHON_UTMP_VERSION = 780831bc7a0e46345d78ad6c17063b1bd1c36b41
PYTHON_UTMP_SITE = https://codeberg.org/hjacobs/utmp.git
PYTHON_UTMP_SITE_METHOD = git
PYTHON_UTMP_SETUP_TYPE = setuptools
PYTHON_UTMP_LICENSE = Apache-2.0
# There are no license files as of yet.
# See this issue for reference: https://codeberg.org/hjacobs/utmp/issues/3
PYTHON_UTMP_REDISTRIBUTE = YES

$(eval $(python-package))

