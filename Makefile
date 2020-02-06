#
# Copyright 2019 Frederik Peter Aalund <fpa@sbtinstruments.com>
#

# OUTPUT_DIR is relative to ./buildroot (E.g., ./buildroot/output/zeus)
PROCESSORS=$(shell grep -c ^processor /proc/cpuinfo)
BUILDROOT_SERVER=http://buildroot.uclibc.org/downloads
BUILDROOT_VERSION=2019.11.1
BUILDROOT_ARCHIVE=buildroot-$(BUILDROOT_VERSION).tar.gz
OSRELEASE=sbt-open-source/board/common/rootfs_overlay/etc/os-release
# Hack to always execute the script. This ensures that the
# various files with {PLACEHOLDER} variables in them are up-to-date.
ALWAYS_RUN:=$(shell ./substitute-placeholders.sh)



all: bactobox-system.img zeus-system.img



###############################################################################
### System image
###############################################################################
zeus-system.img: zeus-system/boot/uramdisk.image.gz \
                 zeus-system/boot/uImage
	@rm -f $@
	mke2fs \
		-L "system" \
		-N 0 \
		-O 64bit \
		-d "zeus-system" \
		-m 5 \
		-r 1 \
		-t ext4 \
		"$@" \
		150M
bactobox-system.img: bactobox-system/boot/uramdisk.image.gz \
                     bactobox-system/boot/uImage
	@rm -f $@
	mke2fs \
		-L "system" \
		-N 0 \
		-O 64bit \
		-d "bactobox-system" \
		-m 5 \
		-r 1 \
		-t ext4 \
		"$@" \
		150M

zeus-system/boot/uImage: buildroot/output/zeus/images/uImage
zeus-system/boot/uramdisk.image.gz: buildroot/output/zeus/images/rootfs.cpio.uboot
zeus-system/boot/uImage \
zeus-system/boot/uramdisk.image.gz:
	@mkdir -p zeus-system/boot
	cp $< $@

bactobox-system/boot/uImage: buildroot/output/bactobox/images/uImage
bactobox-system/boot/uramdisk.image.gz: buildroot/output/bactobox/images/rootfs.cpio.uboot
bactobox-system/boot/uImage \
bactobox-system/boot/uramdisk.image.gz:
	@mkdir -p bactobox-system/boot
	cp $< $@



###############################################################################
### Buildroot
###############################################################################
buildroot/output/zeus/images/rootfs.cpio.uboot: buildroot/output/zeus/.config $(OSRELEASE)
buildroot/output/bactobox/images/rootfs.cpio.uboot: buildroot/output/bactobox/.config $(OSRELEASE)
buildroot/output/zeus/images/rootfs.cpio.uboot \
buildroot/output/bactobox/images/rootfs.cpio.uboot:
	$(MAKE) -C buildroot \
		BR2_EXTERNAL=../sbt-open-source:../sbt-proprietary \
		BR2_JLEVEL=$(PROCESSORS) O=$(<D)

buildroot/output/zeus/images/uImage: buildroot/output/zeus/.config
buildroot/output/bactobox/images/uImage: buildroot/output/bactobox/.config
buildroot/output/zeus/images/uImage \
buildroot/output/bactobox/images/uImage:
	$(MAKE) -C buildroot \
		BR2_EXTERNAL=../sbt-open-source:../sbt-proprietary \
		BR2_JLEVEL=$(PROCESSORS) O=$(<D) linux-reinstall

buildroot/output/zeus/.config: sbt-proprietary/configs/zeus_defconfig \
                               buildroot/Makefile
	$(MAKE) -C buildroot \
		BR2_EXTERNAL=../sbt-open-source:../sbt-proprietary \
		BR2_JLEVEL=$(PROCESSORS) O=$(<D) zeus_defconfig
buildroot/output/bactobox/.config: sbt-proprietary/configs/bactobox_defconfig \
                                   buildroot/Makefile
	$(MAKE) -C buildroot \
		BR2_EXTERNAL=../sbt-open-source:../sbt-proprietary \
		BR2_JLEVEL=$(PROCESSORS) O=$(<D) bactobox_defconfig

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
$(TARGET)-software.swu: sw-description \
                        swupdate.sh \
                        $(TARGET)-system.img
	# Add the dependencies (in the listed order) to the CPIO
	# archive. Note that the sw-description file must come first
	# for SWUpdate to work.
	for f in $^; do \
		echo $$f; \
	done | cpio -ov -H crc -O $@



###############################################################################
### Utility
###############################################################################
.PHONY: remove-%
remove-%:
	rm -rf buildroot/output/bactobox/build/$** \
		buildroot/output/zeus/build/$**
	touch sbt-proprietary/configs/bactobox_defconfig \
		sbt-proprietary/configs/zeus_defconfig



###############################################################################
### Housekeeping
###############################################################################
.PHONY: clean
clean:
	-$(MAKE) -C buildroot clean
	rm -rf *-system *-system.img $(OSRELEASE) sw-description *.swu

.PHONY: mrproper
mrproper: clean
	rm -rf buildroot buildroot-*.tar.gz
