# Setup the driver

## Prerequisites
1. Install Kernel Module Dependencies
Install the required packages for building kernel modules:
```bash 
sudo apt install build-essential dkms linux-headers-$(uname -r) -y
```

2. Configure User Access
To allow non-root users to access the Vertex cards, follow these steps:
  1. Create a dedicated group for device access:
     ```
     sudo groupadd qdice
     ```
  2. Add users to the group (replace username with actual usernames):
     ```
     sudo usermod -a -G qdice username
     ```
  3. Create a udev rule to automatically set device permissions:
     ```
     sudo nano /etc/udev/rules.d/30-qdice.rules
     ```
     Add the following line:
     ```
     ATTRS{vendor}=="0x10ee", ATTRS{device}=="0x7024", ACTION=="add", GROUP="qdice", MODE="0664"
     ```

## Driver Installation
1. Run the setup.sh script with superuser privileges 
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



