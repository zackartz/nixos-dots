{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.sites.jellyfin;
in {
  options.sites.jellyfin = with types; {
    enable = mkBoolOpt false "Enable jellyfin";
  };

  config = mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
      user = "zoey";
      group = "users";
    };

    virtualisation.oci-containers = {
      containers.jellyfin-vue = {
        image = "ghcr.io/jellyfin/jellyfin-vue:unstable";
        environment = {
          "PUBLIC_JELLYFIN_API" = "http://localhost:8096";
        };
        ports = [
          "8065:80"
        ];
      };
    };

    networking.firewall.allowedTCPPorts = [8065];
  };
}
