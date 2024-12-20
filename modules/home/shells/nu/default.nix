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

      # Nushell doesn't need generateCompletions like fish

      extraConfig = ''
        # Environment variables
        let-env LC_ALL = "en_US.UTF-8"
        let-env SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh"
        let-env FLAKE = "/home/zoey/nixos/"

        # FZF settings
        let-env FZF_PREVIEW_FILE_CMD = "head -n 10"
        let-env FZF_PREVIEW_DIR_CMD = "ls"

        def pf [] {
          fzf --bind ctrl-y:preview-up,ctrl-e:preview-down \
              --bind ctrl-b:preview-page-up,ctrl-f:preview-page-down \
              --bind ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down \
              --bind ctrl-k:up,ctrl-j:down \
              --preview='bat --style=numbers --color=always --line-range :100 {}'
        }

        def ff [] {
          let files = (pf)
          for file in $files {
            let cmd = $"v ($file)"
            echo $cmd
            nu -c $cmd
          }
        }
      '';

      # Nushell handles plugins differently, you might want to use modules instead
      # or configure external tools directly

      extraEnv = ''
        # Add any environment-specific configuration here
      '';

      # Import aliases (you'll need to convert fish aliases to Nushell format)
      shellAliases = import ./aliases.nix {inherit pkgs lib config;};
    };

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
