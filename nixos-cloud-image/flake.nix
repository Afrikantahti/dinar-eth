{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      dinar-proxmox-cloud-image = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixosConfigurations/dinar-proxmox-cloud-image
        ];
      };
    };
  };
}