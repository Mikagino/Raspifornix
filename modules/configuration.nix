# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ... }:

{
  imports =
    [
      <nixos-hardware/raspberry-pi/4>
      ./hardware-configuration.nix
    ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # Configure network connections interactively with nmcli or nmtui.
  networking = {
    hostName = "Raspifornix";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
  #   font = "Lat2-Terminus16";
    keyMap = "de";
  #   useXkbConfig = true; # use xkb.options in tty.
  };

  hardware.bluetooth.enable = false;

# Do I need this?!
#  hardware.raspberry-pi = {
#    firmware = {
#      enable = true;
#      uboot.enable = true;
#    };
#  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mika = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
  #  ubootRaspberryPiAarch64
    git
    lazygit
    raspberrypi-eeprom
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
    flake = "~/Raspifornix";
  };

  system.stateVersion = "25.11"; # Did you read the comment?
}

