{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.sites.hydra;

  sec = config.age.secrets;
in {
  options.sites.hydra = with types; {
    enable = mkBoolOpt false "Enable Hydra";
  };

  config = mkIf cfg.enable {
    services.hydra = {
      enable = true;
      hydraURL = "https://hydra.zoeys.computer";
      useSubstitutes = true;
      notificationSender = "hydra@localhost"; # e-mail of hydra service
    };

    services.nginx.virtualHosts."hydra.zoeys.computer" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:3000";
      };
    };

    users.users.hydra.extraGroups = ["keys"];

    nix = {
      settings.allowed-uris = [
        "github:"
        "https://github.com"
        "git+https://github.com/"
        "git+ssh://github.com/"
        "git+https://git.zoeys.cloud/"
        "git+ssh://git.zoeys.cloud/"
        "path:"
      ];
      trustedUsers = ["hydra"]; # Ensure hydra user is trusted for nix
      buildMachines = [
        {
          hostName = "localhost";
          protocol = null;
          system = "x86_64-linux";
          supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
          maxJobs = 8;
        }
      ];
    };
  };
}
