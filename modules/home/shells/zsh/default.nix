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
  options.shells.zsh = with types; {
    enable = mkBoolOpt false "Enable Zsh Configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gnumake
      # Runs programs without installing them
      comma

      # grep replacement
      ripgrep

      # ping, but with cool graph
      gping

      # dns client
      dogdns

      # neofetch but for git repos
      onefetch

      # neofetch but for cpu's
      cpufetch

      # download from yt and other websites
      yt-dlp

      zsh-history

      # man pages for tiktok attention span mfs
      tealdeer

      # markdown previewer
      glow

      # profiling tool
      hyperfine

      imagemagick
      ffmpeg-full

      # preview images in terminal
      catimg

      # networking stuff
      nmap
      wget

      # faster find
      fd

      # http request thingy
      xh

      # generate regex
      grex

      # json thingy
      jq

      # syncthnig for acoustic people
      rsync

      figlet
      # Generate qr codes
      qrencode

      # script kidde stuff
      hcxdumptool
      hashcat

      unzip
    ];
  };
}
