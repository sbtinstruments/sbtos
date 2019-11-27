#
# Copyright 2019 Frederik Peter Aalund <fpa@sbtinstruments.com>
#
BUILDROOT_SERVER=http://buildroot.uclibc.org/downloads
BUILDROOT_VERSION=2019.08
BUILDROOT_ARCHIVE=buildroot-$(BUILDROOT_VERSION).tar.gz
BUILDROOT_MAKE=$(MAKE) -C buildroot BR2_EXTERNAL=../sbt-open-source:../sbt-proprietary BR2_JLEVEL=$(PROCESSORS)
ROOTFS=buildroot/output/images/rootfs.cpio.uboot
KERNEL=buildroot/output/images/uImage
OSRELEASE=sbt-open-source/board/common/rootfs_overlay/etc/os-release
PROCESSORS=$(shell grep -c ^processor /proc/cpuinfo)
# Hack to always execute the set-version target. This ensures that the
# various files with {VERSION} template variables in them are up-to-date.
ALWAYS_SET_VERSION:=$(shell ./set-version.sh)



all: system.img



###############################################################################
### System image
###############################################################################
SYSTEM_FILES=system/boot/uramdisk.image.gz \
             system/boot/uImage

system.img: $(SYSTEM_FILES)
	@rm -f $@
	mke2fs \
		-L "system" \
		-N 0 \
		-O 64bit \
		-d "system" \
		-m 5 \
		-r 1 \
		-t ext4 \
		"$@" \
		150M \

$(SYSTEM_FILES): $(ROOTFS) $(KERNEL)
	@mkdir -p system/boot
	cp $(ROOTFS) system/boot/uramdisk.image.gz
	cp $(KERNEL) system/boot/uImage



###############################################################################
### Buildroot
###############################################################################
$(ROOTFS): buildroot/.config $(OSRELEASE)
	$(BUILDROOT_MAKE)

$(KERNEL): buildroot/.config
	$(BUILDROOT_MAKE) linux-reinstall

buildroot/.config: sbt-proprietary/configs/zeus_defconfig buildroot/Makefile
	$(BUILDROOT_MAKE) zeus_defconfig

buildroot/Makefile: $(BUILDROOT_ARCHIVE)
	# E.g., extract "buildroot-2019.8.tar.gz" into "buildroot"
	@mkdir -p buildroot
	tar xfz $< -C buildroot --strip-components=1

$(BUILDROOT_ARCHIVE):
	wget $(BUILDROOT_SERVER)/$(BUILDROOT_ARCHIVE)



###############################################################################
### Install remote
###############################################################################
install-remote: REMOTE_HOST_defined $(ROOTFS)
	ssh $(REMOTE_HOST) "/bin/mount -o rw,remount \$$(readlink /media/active_system)"
	scp $(ROOTFS) $(REMOTE_HOST):/boot/uramdisk.image.gz
	ssh $(REMOTE_HOST) "/bin/mount -o ro,remount \$$(readlink /media/active_system)"

kernel-install-remote: REMOTE_HOST_defined install $(KERNEL)
	ssh $(REMOTE_HOST) "/bin/mount -o rw,remount \$$(readlink /media/active_system)"
	scp $(KERNEL) $(REMOTE_HOST):/boot/uImage
	ssh $(REMOTE_HOST) "/bin/mount -o ro,remount \$$(readlink /media/active_system)"

.PHONY: REMOTE_HOST_defined
REMOTE_HOST_defined:
ifndef REMOTE_HOST
	$(error REMOTE_HOST is not set)
endif



###############################################################################
### SWUpdate
###############################################################################
zeus-software.swu: sw-description \
                   swupdate.sh \
                   system.img
	# Add the dependencies (in the listed order) to the CPIO
	# archive. Note that the sw-description file must come first
	# for SWUpdate to work.
	for f in $^; do \
		echo $$f; \
	done | cpio -ov -H crc -O $@



###############################################################################
### Housekeeping
###############################################################################
.PHONY: clean
clean:
	-$(MAKE) -C buildroot clean
	rm -rf system system.img $(OSRELEASE) sw-description *.swu

.PHONY: mrproper
mrproper: clean
	rm -rf buildroot $(BUILDROOT_ARCHIVE)
