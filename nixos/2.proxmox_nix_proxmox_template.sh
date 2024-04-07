#!/bin/bash

# Requirements:
# Proxmox
# nixos.img

VMID="9001"
nixos_version="23.11"

qm create $VMID --memory 2048 --core 2 --balloon=768 --machine q35 --name nixos-${nixos_version}-kvm --net0 virtio,bridge=vmbr0,firewall=1
qm importdisk $VMID nixos.img local-lvm
qm set $VMID --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-${VMID}-disk-0,cache=writethrough,discard=on,iothread=1,ssd=1
qm set $VMID --efidisk0 local-lvm:0,efitype=4m,,pre-enrolled-keys=1,size=528K
qm set $VMID --ide2 local-lvm:cloudinit
qm set $VMID --rng0 source=/dev/urandom
qm set $VMID --tablet 0
qm set $VMID --ciuser root
qm set $VMID --ipconfig0 ip=dhcp
qm set $VMID --agent enabled=1,fstrim_cloned_disks=1
qm set $VMID --boot c --bootdisk scsi0
qm set $VMID --serial0 socket --vga serial0
qm set $VMID --ipconfig0 ip=dhcp
qm set $VMID --cpu cputype=x86-64-v2-AES
qm template $VMID

echo "Rember to set ssh public key in cloud-init"