{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.shells.zsh;
in {
  options.apps.music.spotify = with types; {
    enable = mkBoolOpt false "Enable Spotify";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.spotify];

    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        hidePodcasts
      ];
    };
  };
}
