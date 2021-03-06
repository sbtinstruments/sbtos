#
# Copyright 2019 Frederik Peter Aalund <fpa@sbtinstruments.com>
#

# OUTPUT_DIR is relative to ./buildroot (E.g., ./buildroot/output/zeus)
PROCESSORS?=$(shell grep -c ^processor /proc/cpuinfo)
BUILDROOT_SERVER=http://buildroot.uclibc.org/downloads
BUILDROOT_VERSION=2020.11.1
BUILDROOT_ARCHIVE=buildroot-$(BUILDROOT_VERSION).tar.gz
BUILDROOT_MAKE=$(MAKE) -C buildroot \
	BR2_EXTERNAL=../sbt-open-source:../sbt-proprietary \
	BR2_JLEVEL=$(PROCESSORS)
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
buildroot/output/zeus/images/rootfs.cpio.uboot: $(OSRELEASE) \
                                buildroot/output/zeus/target/etc/legal-info.zip
	$(BUILDROOT_MAKE) O=output/zeus
buildroot/output/bactobox/images/rootfs.cpio.uboot: $(OSRELEASE) \
                            buildroot/output/bactobox/target/etc/legal-info.zip
	$(BUILDROOT_MAKE) O=output/bactobox

buildroot/output/zeus/images/uImage: buildroot/output/zeus/.config
	$(BUILDROOT_MAKE) O=output/zeus linux-reinstall
buildroot/output/bactobox/images/uImage: buildroot/output/bactobox/.config
	$(BUILDROOT_MAKE) O=output/bactobox linux-reinstall

# Legal Information (Licensing and Acknowledgements)
buildroot/output/zeus/target/etc/legal-info.zip: zeus-legal-info.html
buildroot/output/bactobox/target/etc/legal-info.zip: bactobox-legal-info.html
buildroot/output/zeus/target/etc/legal-info.zip \
buildroot/output/bactobox/target/etc/legal-info.zip:
	mkdir -p $(@D)
	rm -f $@
	zip $@ $<
	# Rename file inside the ZIP archive.
	# E.g., "zeus-legal-info.html" --> "legal-info.html"
	printf "@ $(<F)\n@=legal-info.html\n" | zipnote -w $@

.PHONY: zeus-legal-info.html
zeus-legal-info.html: buildroot/output/zeus/.config
	$(BUILDROOT_MAKE) O=output/zeus legal-info
	python3.8 -m legal-info zeus
.PHONY: bactobox-legal-info.html
bactobox-legal-info.html: buildroot/output/bactobox/.config
	$(BUILDROOT_MAKE) O=output/bactobox legal-info
	python3.8 -m legal-info bactobox

buildroot/output/zeus/.config: sbt-proprietary/configs/zeus_defconfig \
                               buildroot/Makefile
	$(BUILDROOT_MAKE) O=output/zeus $(<F)
buildroot/output/bactobox/.config: sbt-proprietary/configs/bactobox_defconfig \
                                   buildroot/Makefile
	$(BUILDROOT_MAKE) O=output/bactobox $(<F)

buildroot/Makefile: $(BUILDROOT_ARCHIVE)
	# E.g., extract "buildroot-2019.8.tar.gz" into "buildroot"
	@mkdir -p buildroot
	tar xfz $< -C buildroot --strip-components=1

$(BUILDROOT_ARCHIVE):
	wget $(BUILDROOT_SERVER)/$(BUILDROOT_ARCHIVE)



###############################################################################
### Install remote
###############################################################################
ROOTFS=${TARGET}-system/boot/uramdisk.image.gz
install-remote: REMOTE_HOST_defined $(ROOTFS)
	ssh $(REMOTE_HOST) "/bin/mount -o rw,remount \$$(readlink /media/active_system)"
	scp $(ROOTFS) $(REMOTE_HOST):/boot/uramdisk.image.gz
	ssh $(REMOTE_HOST) "/bin/mount -o ro,remount \$$(readlink /media/active_system)"

KERNEL=${TARGET}-system/boot/uImage
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
		buildroot/output/zeus/build/$** \
		buildroot/dl/$**
	touch sbt-proprietary/configs/bactobox_defconfig \
		sbt-proprietary/configs/zeus_defconfig



###############################################################################
### Housekeeping
###############################################################################
.PHONY: clean
clean:
	-$(MAKE) -C buildroot clean
	rm -rf *-system *-system.img $(OSRELEASE) sw-description \
		*.swu *-legal-info.html

.PHONY: mrproper
mrproper: clean
	rm -rf buildroot buildroot-*.tar.gz
