#!/bin/bash

# script to generate virtual machines through KVM in linux
# eventually will add OPSARGS and switches for VMs / containers

## Global variables
disk_path=/var/lib/libvirt/images/ # location the VM image file is located
iso_path=/mnt/zfs/images/ # ISO location for install
ks_path=
host_name=alma-vm
disk_size=20G
disk_format=qcow2
#isos=/mnt/zfs/isos/  # need to rename the folder eventually

function qcow {
## Test if the qcow2 file is created

# qemu-img create -f ${disk_format} ${disk_path}${host_name}.${disk_format} ${disk_size}
}

function create {

virt-install \
    --name ${host_name} \
    --vcpus 2 \
    --memory 4096 \
    --location ${iso_path}AlmaLinux-9.3-x86_64-dvd.iso \
    --disk ${disk_path}${host_name}.${disk_format},format=${disk_format} \
    --network bridge=virtbr0 \
    --graphics vnc,listen=0.0.0.0 --noautoconsole \
    --os-variant almalinux9 \
    --console pty,target_type=serial \
    --initrd-inject ${ks_path}/${host_name}-ks.cfg \
    --extra-args "ks=file:/ks.cfg",console=tty0,console=ttyS0
}

function run_order {
    qcow
    create
}

run_order
