{
  inputs,
  ...
}: {
  flake.nixosModules.rpi4 = { pkgs, ... }:
  let
    forgeconfig = config.services.forgejo;
    server = forgeconfig.settings.server;   
  in
  {
    services.nginx = {
      virtualHosts.${srv.DOMAIN} = {
        forceSSL = true;
        enableACME = true;
        extraConfig = ''
          client_max_body_size 512M;
        '';
        locations."/".proxyPass = "http://localhost:${toString srv.HTTP_PORT}";
      };
    };
    environment.systemPackages = with pkgs; [
    ];
  }

