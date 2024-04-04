#!/bin/bash

utilities_path=/var/lib/kvm/utilities/images
services_path=/var/lib/kvm/services/images
iso=/var/lib/kvm/services/images/ISO
ks=/var/lib/kvm/scripts/ks

virt-install \
    --name redhat \
    --ram 8192 \
    --disk path=${utilities_path}/ha-ansible.img,size=20 \
    --vcpus 2 \
    --os-type linux \
    --os-variant rhel8.2 \
    --network bridge=br0 \
    --console pty,target_type=serial \
        --initrd-inject ${ks}/remote-vm-ks.cfg \
    --extra-args "ks=file:/ks.cfg",console=ttyS0 \
    --location "${iso}"/rhel-8.2-x86_64-dvd.iso;

