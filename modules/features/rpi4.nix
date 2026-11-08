{
	inputs,
	...
}: {
	flake.nixosModules.rpi4 = { pkgs, ... }: {
    imports =
    [
      <nixos-hardware/raspberry-pi/4>
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

