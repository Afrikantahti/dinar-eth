#!/bin/bash

# Requirements:
# Nixos
# flake.nix
cd
rm -f nixos.img
nix --experimental-features 'nix-command flakes' build .#image
cd result
nix-shell -p qemu

qemu-img convert nixos.qcow2 -O raw $HOME/nixos.img

echo "copy nixos.img to Proxmox"