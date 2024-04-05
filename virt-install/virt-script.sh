#!/bin/bash

# script to generate virtual machines through KVM in linux
# eventually will add OPSARGS and switches for VMs / containers

# qemu-img create -f qcow2 /mnt/zfs/libvirt/images/alma.qcow2 20G

disk_path=/var/lib/libvirt/images/
isos=/mnt/zfs/images/

virt-install \
    --name alma \
    --vcpus 2 \
    --memory 4096 \
    --location ${isos}AlmaLinux-9.3-x86_64-dvd.iso \
    --disk ${disk_path}alma.qcow2,format=qcow2 \
    --network bridge=virtbr0 \
    --graphics vnc,,listen=0.0.0.0 --noautoconsole \
    --os-variant almalinux9 \
    --console pty,target_type=serial \
    --extra-args 'console=tty0 console=ttyS0,115200'
