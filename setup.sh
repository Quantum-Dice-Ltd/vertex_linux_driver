#!/bin/bash
# set -x

MODULE_NAME=xdma
device_id=903f
interrupt_selection=4
QRNG_TAG="QRNG: "

print_m() {
	echo "$QRNG_TAG $1"
}

print_error_clean_up_and_exit() {
	print_m "ERROR: $1"
	make clean > /dev/null 2>&1
	exit 1
}

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
	print_m "This script must be run as root" 
	exit 1
fi

# Change directory and build driver
cd ./xdma
make install > /dev/null #ignore the output but not the error message
#Check if the build is successful
if [ $? -ne 0 ]; then
	print_error_clean_up_and_exit "Driver build failed"
fi

# Remove the existing kernel module
lsmod | grep $MODULE_NAME > /dev/null
if [ $? -eq 0 ]; then
	rmmod $MODULE_NAME
	if [ $? -ne 0 ]; then
		print_error_clean_up_and_exit "rmmod $MODULE_NAME failed"
    else 
		print_m "Existing installation of module removed successfully"
	fi
else 
	print_m "No existing installation of module found"
fi

# Load the driver 
#call the function to print the message		
print_m "Loading driver..."

ret=`insmod ../xdma/xdma.ko poll_mode=1`

if [ ! $ret == 0 ]; then
	print_error_clean_up_and_exit "Driver did not load properly"
else 
	print_m "Driver loaded successfully"
fi

# Check to see if the hardware devices were recognized
cat /proc/devices | grep $MODULE_NAME > /dev/null
returnVal=$?
if [ ! $returnVal == 0 ]; then
	print_m "Warning: no hardware device was recognized." 
fi
 
# Add module to /etc/modules to load at boot
if ! grep -q "$MODULE_NAME" /etc/modules; then
    echo $MODULE_NAME >> /etc/modules
    print_m "Added module to /etc/modules for loading at boot"
else
    print_m "module already configured to load at boot"
fi

# Copy module parameters to modprobe config
if [ ! -f "/etc/modprobe.d/$MODULE_NAME.conf" ]; then
    echo "options $MODULE_NAME poll_mode=1" > /etc/modprobe.d/$MODULE_NAME.conf
    print_m "Created modprobe config for module parameters"
else
    print_m "Modprobe config already exists"
fi

# Run depmod to rebuild module dependencies
depmod
print_m "Updated module dependencies"

#clean up. Run this command without print texts from it 
make clean > /dev/null 2>&1

print_m "DONE"
