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
      dataDir = "/mnt/lul";
      openFirewall = true;
    };
  };
}
