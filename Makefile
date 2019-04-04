#
# Copyright 2019 Frederik Peter Aalund <fpa@sbtinstruments.com>
#
# Based on the Makefile from the Red Pitaya project by
# Ales Bardorfer <ales.bardorfer@redpitaya.com>
#
B_SERVER=http://buildroot.uclibc.org/downloads
B_VERSION=2018.11.1
B_DIR=buildroot-$(B_VERSION)
B_ARCHIVE=$(B_DIR).tar.gz
B_DOWNLOAD=$(B_SERVER)/$(B_ARCHIVE)
UIMAGE=$(B_DIR)/output/images/rootfs.cpio.uboot
GIT_DESCRIPTION=$(shell git describe --tags --dirty --always --match [0-9][0-9][0-9][0-9]\.[0-9][0-9]\.[0-9]*)
SBTOS_VERSION=$(GIT_DESCRIPTION:v%=%)
OSRELEASE=overlay/etc/os-release
processors=$(shell grep -c ^processor /proc/cpuinfo)

INSTALL_DIR ?= .

all: $(UIMAGE)

$(UIMAGE): $(B_DIR) \
           overlay \
           $(B_DIR)/.config \
           $(OSRELEASE)
	rm -f $(B_DIR)/output/target/etc/hostname
	rm -f $(B_DIR)/output/target/etc/network/interfaces
	$(MAKE) -C $(B_DIR) BR2_EXTERNAL=../external BR2_JLEVEL=$(processors)

$(B_DIR):
	wget $(B_DOWNLOAD)
	tar xfz $(B_ARCHIVE)
	ln -s $(B_DIR) buildroot

$(B_DIR)/.config: config.armhf
	cp $< $@

install: $(UIMAGE)
	mkdir -p $(INSTALL_DIR)
	cp $(UIMAGE) $(INSTALL_DIR)/uramdisk.image.gz

install-remote: remote_host_defined install
	ssh $(remote_host) "/bin/mount -o rw,remount \$$(readlink /media/system)"
	scp uramdisk.image.gz $(remote_host):/boot
	ssh $(remote_host) "/bin/mount -o ro,remount \$$(readlink /media/system)"

clean:
	-$(MAKE) -C $(B_DIR) clean
	rm *~ -f

mrproper:
	-rm -rf $(B_DIR) $(B_ARCHIVE)
	-rm *~ -f

$(OSRELEASE):
	( \
		echo "NAME=sbtOS"; \
		echo "VERSION=$(SBTOS_VERSION)"; \
		echo "ID=sbtos"; \
		echo "VERSION_ID=$(SBTOS_VERSION)"; \
		echo "PRETTY_NAME=\"sbtOS $(SBTOS_VERSION)\"" \
	) > $@

.PHONY: clean mrproper $(OSRELEASE)

.PHONY: remote_host_defined
remote_host_defined:
ifndef remote_host
	$(error remote_host is not set)
endif
