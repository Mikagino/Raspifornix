{
  inputs,
  ...
}: {
  flake.nixosModules.traefik = { pkgs, config, ... }:
  let
    ### Variables ###
    httpPort = 80;
    httpsPort = 443;
    traefikDataDir = "/var/lib/traefik";
  in {
    ### sops Secrets ###
    sops.secrets."porkbun/apiKey" = {};
    sops.secrets."porkbun/secretApiKey" = {};
    sops.secrets."porkbun/accessPasswordHash" = {};
    sops.secrets."mika/email" = {};
    sops.secrets."domain" = {};
    services.traefik = {
      enable = true;

      staticConfigOptions = {
        log = {
	        level = "WARN";
        };
        api = {
          entryPoints = {
            web = {
              adress = ":${httpPort}";
              http.redirections.entryPoint = {
                to = "websecure";
                scheme = "https";
              };
	          };
            websecure = {
              adress = ":${httpsPort}";
            };

            certificatesResolvers.porkbun = {
              acme = {
                email = "${config.sops.secrets."mika/email"}";
                storage = "${traefikDataDir}/acme.json";
                dnsChallenge = {
                  provider = "porkbun";
                  resolvers = [
                    "curitiba.ns.porkbun.com"
                    "fortaleza.ns.porkbun.com"
                    "maceio.ns.porkbun.com"
                    "salvador.ns.porkbun.com"
                    ];
                  # propagation.delayBeforeChecks = 60; # uncomment if porkbun is sometimes too slow
                };
              };
            };
	        };
        };
      
        dynamicConfigOptions = {
          routers.api = {
            entryPoint = [ "websecure" ];
            rule = "Host('${config.sops.secrets."domain"}')";
            service = "api@internal";
            middlewares = [ "auth" ];
            tls.certResolver = "porkbun";
          };
        };
      };
    };

      ### Environment File ###
      systemd.services.traefik.serviceConfig = {
        EnvironmentFile = [ "${traefikDataDir}/env" ];
      };

      system.activationScripts.traefikEnv = {
        text = ''
          echo "Creating Traefik env file..."
          cat > ${traefikDataDir}/env << 'EOF' 
          PORKBUN_API_KEY=${config.sops.secrets."porkbun/apiKey".path} 
          PORKBUN_SECRET_API_KEY=${config.sops.secrets."porkbun/secretApiKey".path} 
          EOF
          chmod 600 ${traefikDataDir}/env
        '';
        deps = [ ];
      };

      networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
