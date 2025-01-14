# Setup the driver

1. Run the setup.sh script with superuser privilege 

```
sudo setup.sh
```

2. You should see the following message:

```
QRNG:  Loading driver...
QRNG:  Driver loaded successfully
QRNG:  module already configured to load at boot
QRNG:  Modprobe config already exists
QRNG:  Updated module dependencies
QRNG:  DONE
```

NB: Use the command below to install the kernel module pre-requisites if they are not installed on the machine yet. 
```bash 
sudo apt install build-essential dkms linux-headers-$(uname -r) -y
```
