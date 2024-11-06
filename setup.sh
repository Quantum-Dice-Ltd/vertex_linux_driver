#!/bin/bash
# set -x

#change directory and install xdma driver
cd ./xdma

make install 


#Change dir and load the driver with the 4th option
cd ../tests

./load_driver.sh 4

#clean up 
cd ../xdma
make clean 
