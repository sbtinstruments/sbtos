# Arguments
INPUT=$1
OUTPUT=$2
# Get version from git
GIT_DESCRIPTION=$(git describe --tags --dirty --always \
	--match [0-9][0-9][0-9][0-9]\.[0-9][0-9]\.[0-9]*)
SBTOS_VERSION=$GIT_DESCRIPTION
# Replace in given file
sed "s/{VERSION}/$SBTOS_VERSION/g" $INPUT \
	> /tmp/sbtos-set-version-output
# Only touch $OUTPUT if the checksum is different. This way,
# we avoid unnecessary rebuilds when make is called.
rsync -c /tmp/sbtos-set-version-output $OUTPUT
