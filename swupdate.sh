#!/bin/sh

function get_systems_as_of_boot_time
{
	active_system=`readlink /media/active_system | awk 'BEGIN {FS="system"}; {print $2}'`
	if [ $active_system == "0" ]; then
		inactive_system=1
	elif [ $active_system == "1" ]; then
		inactive_system=0
	else
		echo "Could not determine which system is the active one. Aborting."
		exit 1
	fi
	active_device=/dev/mmcblk0p$(($active_system+1))
	inactive_device=/dev/mmcblk0p$(($inactive_system+1))
}

# Before SWUpdate updates the images
if [ $1 == "preinst" ]; then
	get_systems_as_of_boot_time
	# Choose device to update (the 'inactive' one)
	ln -sf $inactive_device /dev/mmcblk0update
	# Unmount said system before we update the underlying storage
	umount $inactive_device
fi

# After SWUpdate has updated the images
if [ $1 == "postinst" ]; then
	get_systems_as_of_boot_time
	# Switch the 'active' system to the updated one
	fw_setenv active_system $inactive_system
fi
