{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.video.mpv;
in {
  options.apps.video.mpv = with types; {
    enable = mkBoolOpt false "Enable MPV video player";
  };

  config = mkIf cfg.enable {
    catppuccin.mpv.enable = false;

    home.packages = with pkgs; [open-in-mpv];

    programs.mpv = {
      enable = true;
      config = {
        profile = "main";
        background-color = "#000000";
      };
      scripts = with pkgs.mpvScripts; [uosc sponsorblock thumbfast quality-menu];
      profiles = {
        main = {
          vo = "gpu-next";
        };

        "protocol.dvd" = {
          profile-desc = "profile for dvd:// streams";
          alang = "en";
        };
      };
    };
  };
}
