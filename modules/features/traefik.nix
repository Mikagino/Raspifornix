{
  inputs,
  ...
}: {
  flake.nixosModules.traefik = { pkgs, config, ... }:
  let
    ### Variables ###
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
        api.dashboard = true;

        log = {
	        level = "WARN";
        };

        entryPoints = {
          ### Access with http redirects to https ###
          web = {
            adress = ":80";
            http.redirections.entryPoint = {
              to = "websecure";
              scheme = "https";
            };
          };

          ### Access with https ###
          websecure = {
            adress = ":443";
            transport.respondingTimeouts = {
              readTimeout = 600;
              idleTimeout = 600;
              writeTimeout = 600;
            };
            http.tls = {
              certResolver = "porkbun";
              domains = [
                {
                  main = "${config.sops.secrets."domain"}";
                  sans = [ "*.${config.sops.secrets."domain"}" ];
                }
              ];
            };
          };
        };

        ### Certificate Resolver ###
        certificatesResolvers.porkbun.acme = {
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
      
      ### Dynamic Configuration ###
      dynamicConfigOptions.http = {
        middlewares.auth.basicAuth.users = ["${user.name}:${config.sops.secrets."accessPasswordHash".path}"];
        routers.api = {
          entryPoint = [ "websecure" ];
          rule = "Host('${config.sops.secrets."domain"}')";
          service = "api@internal";
          middlewares = [ "auth" ];
          tls.certResolver = "porkbun";
        };
      };
    };

      ### Environment File ###
    systemd.services.traefik.serviceConfig.EnvironmentFile = [ "/var/lib/traefik/env" ];

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
