GIT_DESCRIPTION=$(git describe --tags --dirty --always --match [0-9][0-9][0-9][0-9]\.[0-9][0-9]\.[0-9]*)
SBTOS_VERSION=$GIT_DESCRIPTION
(
	echo "NAME=sbtOS";
	echo "VERSION=$SBTOS_VERSION";
	echo "ID=sbtos";
	echo "VERSION_ID=$SBTOS_VERSION";
	echo "PRETTY_NAME=\"sbtOS $SBTOS_VERSION\""
) > /tmp/os-release
# Only touch $1 if the checksum is different. This way, we avoid unnecessary
# rebuilds when make is called.
rsync -c /tmp/os-release $1
