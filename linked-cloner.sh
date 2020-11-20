#!/bin/bash

# Directory of Storage Pool
POOL_DIR=/home/user/sotrage/pool
# Place the name of the .qcow base image here. 
# This should be located in the POOL_DIR
BASE_IMG=nameOfBaseImage.qcow2

# New machine name is supplied at the command line
if [ $# -lt 1 ] ; then  
    echo "please provide the machine name."
    trap "oh no" SIGABRT
else 
    name=$1
    disk=$POOL_DIR/$name.qcow2
    sudo qemu-img create -f qcow2 -b $POOL_DIR/$BASE_IMG $disk 32G
    sudo virt-install \
    -n $name \
# Edit parameters below this point to modify default vm settings
    --description "A linked clone of $BASE_IMG" \
    --os-type=Linux \
    --os-variant=debiantesting \
    --ram=4096 \
    --vcpus=8 \
    --import \
    --disk path=$disk,bus=virtio,size=10 \
    --video qxl  \
    --channel spicevmc \
    --graphics spice \
    --network default
fi

