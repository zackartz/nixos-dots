{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.music;
in {
  options.services.music = with types; {
    enable = mkBoolOpt false "Enable MPD (Music Player Daemon)";
  };

  config = mkIf cfg.enable {
    services.mpd = {
      enable = true;
      musicDirectory = "/home/zoey/Music";
    };
  };
}
