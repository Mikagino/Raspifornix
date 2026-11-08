{
  ...
}: {
  flake.nixosModules.rpi4 = { pkgs, inputs, ... }: {
    imports =
    [
      inputs.nixos-hardware.modules.raspberry-pi-4
      #<nixos-hardware/raspberry-pi/4>
      #"${fetchTarball "https://github.com/NixOS/nixos-hardware/tarball/master"}/raspberry-pi/4"
      #./hardware-configuration.nix
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

