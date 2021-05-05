################################################################################
#
# alg
#
################################################################################

ALG_VERSION = c0fcc27d25cf9d6ab4e6910a23a25d669936841b
ALG_SITE = git@github.com:sbtinstruments/alg.git
ALG_SITE_METHOD = git
ALG_LICENSE = PROPRIETARY
ALG_REDISTRIBUTE = NO

ALG_INSTALL_STAGING = YES
ALG_INSTALL_TARGET = NO
ALG_DEPENDENCIES = boost host-concurrentqueue dlib
ALG_SUPPORTS_IN_SOURCE_BUILD = NO

$(eval $(cmake-package))
