{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.shells.nu;
in {
  options.shells.nu = with types; {
    enable = mkBoolOpt false "Enable Nushell Configuration";
  };

  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;

      extraConfig = ''
        $env.config.show_banner = false

        if ('TMUX' in $env == false) {
          exec tmux
        }

        fastfetch --config minimal
      '';

      extraEnv = ''
        # Environment variables
        $env.LC_ALL = "en_US.UTF-8"

        $env.SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh"
        $env.FLAKE = "/home/zoey/nixos/"

        # FZF settings
        $env.FZF_PREVIEW_FILE_CMD = "head -n 10"
        $env.FZF_PREVIEW_DIR_CMD = "ls"
      '';

      # Import aliases (you'll need to convert fish aliases to Nushell format)
      shellAliases = import ./aliases.nix {inherit pkgs lib config;};
    };

    programs.carapace.enable = true;
    programs.carapace.enableNushellIntegration = true;

    home.packages = with pkgs; [
      gnumake
      comma
      ripgrep
      gping
      fzf
      dogdns
      onefetch
      cpufetch
      yt-dlp
      zsh-history
      tealdeer
      glow
      hyperfine
      imagemagick
      ffmpeg-full
      catimg
      nmap
      wget
      fd
      xh
      grex
      jq
      rsync
      figlet
      qrencode
      hcxdumptool
      hashcat
      unzip
    ];
  };
}
