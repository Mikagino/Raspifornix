{
  description = "Raspifornix (Raspberry ForgeJo NixOS) setup for using RPi4 with ForgeJo and other server utils.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixos-hardware = {
      url = "https://github.com/NixOS/nixos-hardware/archive/master.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Necessary for Dendritic
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs ; }
      (inputs.import-tree ./modules);
}
