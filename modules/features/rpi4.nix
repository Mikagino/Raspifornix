{
  inputs,
  ...
}: {
  flake.nixosModules.rpi4 = { pkgs, modulesPath, ... }: {
    imports = [
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    environment.systemPackages = with pkgs; [
      # ubootRaspberryPiAarch64
      raspberrypi-eeprom
    ];

  # Do I need this?!
  #  hardware.raspberry-pi = {
  #    firmware = {
  #      enable = true;
  #      uboot.enable = true;
  #    };
  #  };
  };
}

