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
# A hack to ensure that the version file is always up-to-date.
ALWAYS_EXECUTE_THIS_SCRIPT:=$(shell ./update-os-release.sh $(OSRELEASE))



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
	mkdir -p $@
	tar xfz $< -C $@ --strip-components=1

$(BUILDROOT_ARCHIVE):
	wget $(BUILDROOT_SERVER)/$(BUILDROOT_ARCHIVE)



###############################################################################
### Install remote
###############################################################################
install-remote: remote_host_defined $(ROOTFS)
	ssh $(remote_host) "/bin/mount -o rw,remount \$$(readlink /media/system)"
	scp $(ROOTFS) $(remote_host):/boot/uramdisk.image.gz
	ssh $(remote_host) "/bin/mount -o ro,remount \$$(readlink /media/system)"

kernel-install-remote: remote_host_defined install $(KERNEL)
	ssh $(remote_host) "/bin/mount -o rw,remount \$$(readlink /media/system)"
	scp $(KERNEL) $(remote_host):/boot/uImage
	ssh $(remote_host) "/bin/mount -o ro,remount \$$(readlink /media/system)"

.PHONY: remote_host_defined
remote_host_defined:
ifndef remote_host
	$(error remote_host is not set)
endif



###############################################################################
### SWUpdate
###############################################################################
zeus.swu: sw-description \
          system.img \
          umount.sh
	@rm -rf /tmp/zeus-swu-staging
	@mkdir -p /tmp/zeus-swu-staging
	cp $^ /tmp/zeus-swu-staging
	cd /tmp/zeus-swu-staging && \
		echo sw-description $$(ls | grep -v sw-description) \
		| tr " " "\n" \
		| cpio -ov -H crc -O $(shell pwd)/$@

# Phony, so that the version is always up to date
.PHONY: sw-description
sw-description: sw-description.in
	@mkdir -p $(@D)
	sed 's/{VERSION}/vtest/g' sw-description.in > $@



###############################################################################
### Housekeeping
###############################################################################
.PHONY: clean
clean:
	$(MAKE) -C buildroot clean
	rm -rf system system.img .os-release

.PHONY: mrproper
mrproper: clean
	rm -rf buildroot $(BUILDROOT_ARCHIVE)
