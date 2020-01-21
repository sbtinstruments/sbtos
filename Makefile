#
# Copyright 2019 Frederik Peter Aalund <fpa@sbtinstruments.com>
#

# OUTPUT_DIR is relative to ./buildroot (E.g., ./buildroot/output/zeus)
PROCESSORS=$(shell grep -c ^processor /proc/cpuinfo)
OUTPUT_DIR=output/$(TARGET)
BUILDROOT_SERVER=http://buildroot.uclibc.org/downloads
BUILDROOT_VERSION=2019.11.1
BUILDROOT_ARCHIVE=buildroot-$(BUILDROOT_VERSION).tar.gz
BUILDROOT_MAKE=$(MAKE) -C buildroot \
	BR2_EXTERNAL=../sbt-open-source:../sbt-proprietary \
	BR2_JLEVEL=$(PROCESSORS) O=$(OUTPUT_DIR)
ROOTFS=buildroot/$(OUTPUT_DIR)/images/rootfs.cpio.uboot
KERNEL=buildroot/$(OUTPUT_DIR)/images/uImage
OSRELEASE=sbt-open-source/board/common/rootfs_overlay/etc/os-release
# Hack to always execute the script. This ensures that the
# various files with {PLACEHOLDER} variables in them are up-to-date.
ALWAYS_RUN:=$(shell ./substitute-placeholders.sh)



all: $(TARGET)-system.img



###############################################################################
### System image
###############################################################################
SYSTEM_FILES=$(TARGET)-system/boot/uramdisk.image.gz \
             $(TARGET)-system/boot/uImage

$(TARGET)-system.img: $(SYSTEM_FILES)
	@rm -f $@
	mke2fs \
		-L "system" \
		-N 0 \
		-O 64bit \
		-d "$(TARGET)-system" \
		-m 5 \
		-r 1 \
		-t ext4 \
		"$@" \
		150M \

$(SYSTEM_FILES): $(ROOTFS) $(KERNEL)
	@mkdir -p $(TARGET)-system/boot
	cp $(ROOTFS) $(TARGET)-system/boot/uramdisk.image.gz
	cp $(KERNEL) $(TARGET)-system/boot/uImage



###############################################################################
### Buildroot
###############################################################################
$(ROOTFS): buildroot/$(OUTPUT_DIR)/.config $(OSRELEASE)
	$(BUILDROOT_MAKE)

$(KERNEL): buildroot/$(OUTPUT_DIR)/.config
	$(BUILDROOT_MAKE) linux-reinstall

buildroot/$(OUTPUT_DIR)/.config: TARGET_defined \
                                 sbt-proprietary/configs/$(TARGET)_defconfig \
                                 buildroot/Makefile
	$(BUILDROOT_MAKE) $(TARGET)_defconfig

buildroot/Makefile: $(BUILDROOT_ARCHIVE)
	# E.g., extract "buildroot-2019.8.tar.gz" into "buildroot"
	@mkdir -p buildroot
	tar xfz $< -C buildroot --strip-components=1

$(BUILDROOT_ARCHIVE):
	wget $(BUILDROOT_SERVER)/$(BUILDROOT_ARCHIVE)

.PHONY: TARGET_defined
TARGET_defined:
ifndef TARGET
	$(error TARGET is not set)
endif



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
