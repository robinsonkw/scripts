#!/bin/bash

# script to generate virtual machines through KVM in linux
# eventually will add OPSARGS and switches for VMs / containers

disk_path=/var/lib/libvirt/images/
isos=/mnt/zfs/images/

virt-install \
    --name alma \
    --vcpus 2 \
    --memory 4096 \
    --location ${isos}AlmaLinux-9.3-x86_64-dvd.iso \
    --disk path=${disk_path}alma.img,size=20 \
    --network bridge=virtbr0 \
    --graphics vnc,port='-1',listen=0.0.0.0 \
    --os-variant almalinux9 \
    --console pty,target_type=serial \
    --extra-args 'console=tty0 console=ttyS0,115200'
