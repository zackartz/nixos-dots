{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.dlna;
in {
  options.services.dlna = with types; {
    enable = mkBoolOpt false "Enable MiniDLNA service";
  };

  config = mkIf cfg.enable {
    services.minidlna = {
      enable = true;
      openFirewall = true;
      settings = {
        notify_interval = 60;
        friendly_name = "workstation";
        media_dir = ["A,/home/zoey/Music"];
        inotify = "yes";
      };
    };

    users.users.minidlna = {
      extraGroups = ["users"];
    };
  };
}
