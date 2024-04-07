#!/bin/bash

# Requirements:
# Nixos
# flake.nix

nix --experimental-features 'nix-command flakes' build .#image
cd results
nix-shell -p qemu

qemu-img convert nixos.qcow2 -O raw $HOME/nixos.img

echo "copy nixos.img to Proxmox"