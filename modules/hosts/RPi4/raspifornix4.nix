# ------------------------------------------------------------------------------------------
# Setup for the Raspberry Pi 4.
# ------------------------------------------------------------------------------------------

{
  inputs,
  self,
  lib,
  #modulesPath,
  ...
}: {
  # ----- Modules -----
  flake.nixosConfigurations.raspifornix4 = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      common

      locale-de
      networking
      rpi4

      mika
    ]
    ++ [
      self.nixosModules.raspifornix4
    ];
  };

  # ----- Host Setup -----
  flake.nixosModules.raspifornix4 = {
    networking.hostName = "raspifornix4";
    system.stateVersion = "25.11";

    # ----- Hardware Config -----
    boot = {
      initrd.availableKernelModules = [
        "xhci_pci"
        "usbhid"
        "uas"
        ];
      # initrd.kernelModules = [ ];
      # kernelModules = [ ];
      # extraModulePackages = [ ];
    };

    # ----- Disks -----
    #imports = [
    #  (modulesPath + "/installer/scan/not-detected.nix")
    #];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };

    nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

    # swapDevices = [ ];
  };
}
