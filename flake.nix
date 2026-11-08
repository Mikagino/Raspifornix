{
  description = "Raspifornix (Raspberry ForgeJo NixOS) setup for using RPi4 with ForgeJo and other server utils.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixos-hardware.url = "https://github.com/NixOS/nixos-hardware/archive/master.tar.gz";
    # Necessary for Dendritic
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs ; }
      (inputs.import-tree ./modules);
}
