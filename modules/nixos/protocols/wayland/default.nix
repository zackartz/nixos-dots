{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.protocols.wayland;
in {
  options.protocols.wayland = with types; {
    enable = mkBoolOpt false "Enable Wayland Protocol";
  };

  config = mkIf cfg.enable {
    environment.etc."greetd/environments".text = ''
      sway
    '';

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "niri-session";
          user = "zoey";
        };
      };
    };

    programs.uwsm = {
      enable = false;
      waylandCompositors = {
        # "mwc" = {
        #   prettyName = "MWC";
        #   binPath = "/run/current-system/sw/bin/mwc";
        #   comment = "previously owl";
        # };
        # niri = {
        #   prettyName = "niri";
        #   binPath = "/run/current-system/sw/bin/niri";
        #   comment = "niri";
        # };
      };
    };

    # environment.systemPackages = [
    #   pkgs.custom.mwc
    # ];

    programs.hyprland = {
      withUWSM = true;
      enable = false;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };

    programs.niri.enable = true;
    programs.niri.package = pkgs.niri-unstable;

    environment = {
      variables = {
        NIXOS_OZONE_WL = "1";
        # __GL_GSYNC_ALLOWED = "0";
        # __GL_VRR_ALLOWED = "0";
        _JAVA_AWT_WM_NONEREPARENTING = "1";
        SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
        DISABLE_QT5_COMPAT = "0";
        GDK_BACKEND = "wayland";
        ANKI_WAYLAND = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_QPA_PLATFORM = "wayland";
        DISABLE_QT_COMPAT = "0";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        MOZ_ENABLE_WAYLAND = "1";
        WLR_BACKEND = "wayland";
        WLR_RENDERER = "wayland";
        XDG_SESSION_TYPE = "wayland";
        SDL_VIDEODRIVER = "wayland,x11";
        XDG_CACHE_HOME = "/home/zoey/.cache";
        CLUTTER_BACKEND = "wayland";
        DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";

        # # CachyOS-inspired Nvidia optimizations for gaming
        # __GL_THREADED_OPTIMIZATIONS = "1";
        # __GL_SHADER_DISK_CACHE = "1";
        # __GL_SHADER_DISK_CACHE_SIZE = "1000000000";
        # __GL_MaxFramesAllowed = "1"; # Reduces input latency
        # __GL_YIELD = "USLEEP"; # Better CPU usage when GPU-bound
        # DXVK_ASYNC = "1";
        # DXVK_FRAME_RATE = "0"; # No frame rate cap from DXVK
        # PROTON_ENABLE_NVAPI = "1";
        # PROTON_HIDE_NVIDIA_GPU = "0";
        # WINE_FULLSCREEN_FSR = "1"; # Enable FSR upscaling for Wine/Proton games
        # MANGOHUD = "1"; # Enable MangoHud by default
        # MANGOHUD_CONFIG = "cpu_temp,gpu_temp,vram,ram,position=top-left,height=500,font_size=20";
      };
    };

    services.pulseaudio.support32Bit = true;

    xdg.portal = {
      enable = true;
      extraPortals = [
        # pkgs.xwaylandvideobridge
      ];
    };
  };
}
