# Note that this post-build script runs after the "rootfs overlay" mechanism.

### Persist /var/log with a symlink
# We need to do this as a post build step (and not in the rootfs overlay) since some packages
# (e.g., nginx) creates a subfolder there (e.g., /var/log/nginx). These subfolders
# conflict with the "rootfs overlay"-based symlink (it can't create a link if there already
# is a folder at the target location).
TARGET="$1"
# Remove the existing folder
rm -rf $TARGET/var/log
# Create a symlink instead
ln -s /media/data/log $TARGET/var/log
