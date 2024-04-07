{
  config,
  pkgs,
  ...
}: let
  sshKeysPath = "/etc/ssh/ssh_host_ed25519_key";
in {
  imports = [./hw-config.nix];

    nixpkgs.hostPlatform = "x86_64-linux";
    imports = [
    "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
    ];

    localization = {
        hostname = "template";
        timezone = "Europe/Helsinki";
    };

     boot.kernelParams = [ "console=ttyS0,115200n8" ];
      boot.loader.grub.extraConfig = "
        serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1
        terminal_input serial
        terminal_output serial
      ";

      networking = {
        hostName = "nixos-cloudinit";
      };

      fileSystems."/" = {
        label = "nixos";
        fsType = "ext4";
        autoResize = true;
      };
      boot.loader.grub.device = "/dev/sda";

      services.openssh.enable = true;

      services.qemuGuest.enable = true;

      security.sudo.wheelNeedsPassword = false;

      users.users.core = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };

      environment.systemPackages = with pkgs; [
          wget helix vim fish git
      ];

      networking = {
        defaultGateway = { address = "10.1.1.1"; interface = "eth0"; };
        dhcpcd.enable = false;
        interfaces.eth0.useDHCP = false;
      };

      systemd.network.enable = true;

      services.cloud-init = {
        enable = true;
        network.enable = true;
        config = ''
          system_info:
            distro: nixos
            network:
              renderers: [ 'networkd' ]
            default_user:
              name: core
          users:
              - default
          ssh_pwauth: false
          chpasswd:
            expire: false
          cloud_init_modules:
            - migrator
            - seed_random
            - growpart
            - resizefs
          cloud_config_modules:
            - disk_setup
            - mounts
            - set-passwords
            - ssh
          cloud_final_modules: []
          '';
      };
    };

    nixos = nixpkgs.lib.nixosSystem {
      modules = [baseModule];
    };

    make-disk-image = import "${nixpkgs}/nixos/lib/make-disk-image.nix";

  };

  system.stateVersion = "23.11";
}