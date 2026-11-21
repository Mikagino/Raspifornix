{
	inputs,
  ...
}: {
	flake.nixosModules.sops = { pkgs, user, ... }: {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    environment.systemPackages = with pkgs; [
      age
      sops
	  ];

    sops.defaultSopsFile = ./secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "/home/mika/.config/sops/age/keys.txt";
  };

  flake.homeModules.sops = { pkgs, config, ... }: {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
    ];
  };
}