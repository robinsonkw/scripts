#1/bin/bash

vm_name="opnsense"
path="/var/lib/libvirt/ISOs/"
iso="OPNsense-25.7-vga-amd64.iso"
lan="virt-lan"
wan="virt-wan"

virt-install \
--name $vm_name \
--ram 2048 \
--vcpus 2 \
--os-variant freebsd12.0 \
--disk path=/var/lib/libvirt/images/$vm_name.qcow2,size=20,format=qcow2 \
--network bridge=$wan,model=virtio \
--network bridge=$lan,model=virtio \
--cdrom ${path}${iso} \
--graphics vnc \
--noautoconsole
