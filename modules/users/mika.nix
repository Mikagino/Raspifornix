{
	self,
	...
}: {
	flake.nixosModules.mika = { pkgs, ... }: {
		users.users.mika = {
			isNormalUser = true;
			description = "Mika";
			extraGroups = [
				"networkmanager"
				"wheel"
			];
  #   packages = with pkgs; [
  #     tree
  #   ];
		};
	};
}
