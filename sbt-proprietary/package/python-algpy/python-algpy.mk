################################################################################
#
# alg.py
#
################################################################################

PYTHON_ALGPY_VERSION = 53bcc02e8328b1c824634599856d260d90b677f4
PYTHON_ALGPY_SITE = git@github.com:sbtinstruments/alg.py.git
PYTHON_ALGPY_SITE_METHOD = git
PYTHON_ALGPY_LICENSE = PROPRIETARY
PYTHON_ALGPY_REDISTRIBUTE = NO
PYTHON_ALGPY_DEPENDENCIES = alg host-pybind11 python3

$(eval $(cmake-package))
