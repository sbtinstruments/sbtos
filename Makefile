#
# Copyright 2019 Frederik Peter Aalund <fpa@sbtinstruments.com>
#
BUILDROOT_SERVER=http://buildroot.uclibc.org/downloads
BUILDROOT_VERSION=2019.08
BUILDROOT_ARCHIVE=buildroot-$(BUILDROOT_VERSION).tar.gz
BUILDROOT_MAKE=$(MAKE) -C buildroot BR2_EXTERNAL=../sbt-open-source:../sbt-proprietary BR2_JLEVEL=$(PROCESSORS)
UIMAGE=buildroot/output/images/rootfs.cpio.uboot
GIT_DESCRIPTION=$(shell git describe --tags --dirty --always --match [0-9][0-9][0-9][0-9]\.[0-9][0-9]\.[0-9]*)
SBTOS_VERSION=$(GIT_DESCRIPTION:v%=%)
OSRELEASE=sbt-open-source/board/common/rootfs_overlay/etc/os-release
PROCESSORS=$(shell grep -c ^processor /proc/cpuinfo)
INSTALL_DIR ?= .

all: $(UIMAGE)

# Build ramdisk image. Ensure that the release version is always up to date
# via the $(OSRELEASE) dependency.
$(UIMAGE): buildroot $(OSRELEASE) symbolic-link-fix
	# Load config
	$(BUILDROOT_MAKE) zeus_defconfig
	# Make image
	$(BUILDROOT_MAKE)

buildroot: $(BUILDROOT_ARCHIVE)
	# E.g., extract "buildroot-2019.8.tar.gz" into "buildroot"
	mkdir -p $@
	tar xfz $< -C $@ --strip-components=1

$(BUILDROOT_ARCHIVE):
	wget $(BUILDROOT_SERVER)/$(BUILDROOT_ARCHIVE)

install: $(UIMAGE)
	mkdir -p $(INSTALL_DIR)
	cp $(UIMAGE) $(INSTALL_DIR)/uramdisk.image.gz

install-remote: remote_host_defined install
	ssh $(remote_host) "/bin/mount -o rw,remount \$$(readlink /media/system)"
	scp uramdisk.image.gz $(remote_host):/boot
	ssh $(remote_host) "/bin/mount -o ro,remount \$$(readlink /media/system)"

.PHONY: symbolic-link-fix
symbolic-link-fix:
	# Manually remove some symbolic links from the rootfs overlay in
	# order to make buildroot happy before building.
	rm -f buildroot/output/target/etc/hostname
	rm -f buildroot/output/target/etc/network/interfaces

.PHONY: clean
clean:
	$(MAKE) -C buildroot clean

.PHONY: mrproper
mrproper: clean
	rm -rf buildroot $(BUILDROOT_ARCHIVE)

.PHONY: $(OSRELEASE)
$(OSRELEASE):
	@( \
		echo "NAME=sbtOS"; \
		echo "VERSION=$(SBTOS_VERSION)"; \
		echo "ID=sbtos"; \
		echo "VERSION_ID=$(SBTOS_VERSION)"; \
		echo "PRETTY_NAME=\"sbtOS $(SBTOS_VERSION)\"" \
	) > $@

.PHONY: remote_host_defined
remote_host_defined:
ifndef remote_host
	$(error remote_host is not set)
endif
