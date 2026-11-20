{
  inputs,
  ...
}: {
  flake.nixosModules.traefik = { pkgs, ... }:
  let
    httpPort = 80;
    httpsPort = 443;
    traefikDataDir = "/var/lib/traefik";
  {
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
              email = "angeli.mika@proton.me";
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
      
      };
    };

  systemd.services.traefik.serviceConfig = {
    EnvironmentFile = [ "${traefikDataDir}/env" ];
  };

  system.activationScripts.traefikEnv = {
        text = ''
          echo "Creating Traefik env file..."
          cat > /env << 'EOF' 
PORKBUN_API_KEY=${config.sops.secrets."porkbun/apiKey".path} 
PORKBUN_SECRET_API_KEY=${config.sops.secrets."porkbun/secretApiKey".path} 
EOF
          chmod 600 ${traefikDataDir}/env
        '';
  networking.firewall.allowedTCPPorts = [ ${httpPort} ${httpsPort} ];
}

