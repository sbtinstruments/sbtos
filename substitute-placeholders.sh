# Get version from the repository
GIT_DESCRIPTION=$(git describe --tags --dirty --always \
	--match v[0-9][0-9][0-9][0-9]\.[0-9][0-9]\.[0-9]*)
# Strip leading 'v' from GIT_DESCRIPTION
VERSION=${GIT_DESCRIPTION:1}

# Only touch files if the checksum is different. This way, we avoid
# unnecessary rebuilds when make is called.

# INPUT:  sw-description.in
# OUTPUT: sw-description
sed "s/{VERSION}/$VERSION/g; s/{TARGET}/$TARGET/g" sw-description.in > /tmp/sbtos-set-version-output
rsync -c /tmp/sbtos-set-version-output sw-description

# INPUT:  os-release.in
# OUTPUT: $OSRELEASE
OSRELEASE=sbt-open-source/board/common/rootfs_overlay/etc/os-release
sed "s/{VERSION}/$VERSION/g; s/{TARGET}/$TARGET/g" os-release.in > /tmp/sbtos-set-version-output
rsync -c /tmp/sbtos-set-version-output $OSRELEASE

