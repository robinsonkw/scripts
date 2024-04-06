#!/bin/bash

# script to generate virtual machines through KVM in linux
# eventually will add OPSARGS and switches for VMs / containers

## Global variables
disk_path=/var/lib/libvirt/images/  # location the VM image file is located
iso_path=/mnt/zfs/images/           # ISO location for install
ks_path=/mnt/zfs/kickstart/         # location of ks.cfg files
host_name=alma-vm                   # host name of VM
disk_size=20                       # disk size of VM
disk_format=qcow2                   # format of disk image file
#isos=/mnt/zfs/isos/  # need to rename the folder eventually

function create {

virt-install \
    --name ${host_name} \
    --vcpus 2 \
    --memory memory=4096,currentMemory=2048 \
    --location ${iso_path}AlmaLinux-9.3-x86_64-dvd.iso \
    --disk size=${disk_size},format=${disk_format},cache=none,discard=unmap \
    --network bridge=virtbr0 \
    --graphics vnc,listen=0.0.0.0 --noautoconsole \
    --os-variant almalinux9 \
    --tpm model='tpm-crb',type=emulator,version='2.0' \
    --channel type=unix,target.type=virtio,target.name=org.qemu.guest_agent.0 \
    --console pty,target_type=serial \
    --initrd-inject ${ks_path}/${host_name}-ks.cfg \
    --extra-args "ks=file:/ks.cfg",'console=tty0 console=ttyS0,115200n8 --- console=tty0 console=ttyS0,115200n8'
#    --boot uefi
}

create
