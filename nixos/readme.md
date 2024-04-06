# NIOS proxmox temlate

## NIXOS BUILD

```
# Build flake image
nix --experimental-features 'nix-command flakes' build .#image

# cd to the 'results' folder (that's where the image gets created)
cd results

# Get shell with 'qemu-img'
nix-shell -p qemu

# Convert the 'qcow2' to 'img'
qemu-img convert nixos.qcow2 -O raw /home/core/nixos.img
```

Copy nixos.img to proxmox host

``` mk_nixos_template.sh
qm create 9001 --memory 2048 --core 2 --name nixos-23.11-kvm --net0 virtio,bridge=vmbr0
qm importdisk 9001 nixos.img local-lvm
qm set 9001 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9001-disk-0
qm set 9001 --ide2 local-lvm:cloudinit
qm set 9001 --boot c --bootdisk scsi0
qm set 9001 --serial0 socket --vga serial0
qm set 9001 --ipconfig0 ip=dhcp
qm template 9001
```

Proxmox: 
- Enable guest agent tools from Options
- SSH public key for user root from cloud-init

console password does not work, ssh key auth only.

## Links

- https://discourse.nixos.org/t/a-cloudinit-image-for-use-in-proxmox/27519
- https://gist.github.com/voidus/1230b200043b7f815e2513663d16353b