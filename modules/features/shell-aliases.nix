{
	...
}: {
	flake.nixosModules.shell-aliases = { pkgs, ... }: {
    environment.shellAliases = {
      nrebuild = "sudo nixos-rebuild --flake ~/Raspifornix/#raspifornix4";
      laz = "lazygit";
    };
  };
}
