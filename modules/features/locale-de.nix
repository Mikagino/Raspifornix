{
	inputs,
	...
}: {
	flake.nixosModules.locale-de = { pkgs, ... }: {
    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_US.UTF-8"; # change to german later! de_DE.UTF-8
    console = {
    #   font = "Lat2-Terminus16";
      keyMap = "de";
    #   useXkbConfig = true; # use xkb.options in tty.
    };
  };
}