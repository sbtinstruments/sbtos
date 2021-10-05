################################################################################
#
# python-utmp
#
################################################################################

# We prefer the GitHub mirror over the official Codeberg repo. This is because
# we experienced HTTPS issues (certificate issues) with the latter.
PYTHON_UTMP_VERSION = 80392ab2100577563fff7dd1a98ebcc4beb021e6
PYTHON_UTMP_SITE = https://github.com/sbtinstruments/utmp-mirror.git
PYTHON_UTMP_SITE_METHOD = git
PYTHON_UTMP_SETUP_TYPE = setuptools
PYTHON_UTMP_LICENSE = Apache-2.0
# There are no license files as of yet.
# See this issue for reference: https://codeberg.org/hjacobs/utmp/issues/3
PYTHON_UTMP_REDISTRIBUTE = YES

$(eval $(python-package))

