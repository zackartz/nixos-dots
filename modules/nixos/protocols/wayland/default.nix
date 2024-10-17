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

    services = {
      greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            # command = "sway --unsupported-gpu";
            command = "Hyprland";
            user = "zoey";
          };
          default_session = initial_session;
        };
      };
    };

    programs.hyprland = {
      enable = true;
    };

    environment = {
      variables = {
        NIXOS_OZONE_WL = "1";
        __GL_GSYNC_ALLOWED = "0";
        __GL_VRR_ALLOWED = "0";
        _JAVA_AWT_WM_NONEREPARENTING = "1";
        SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
        DISABLE_QT5_COMPAT = "0";
        GDK_BACKEND = "wayland,x11";
        ANKI_WAYLAND = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        DISABLE_QT_COMPAT = "0";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        MOZ_ENABLE_WAYLAND = "1";
        WLR_BACKEND = "wayland";
        WLR_RENDERER = "wayland";
        XDG_SESSION_TYPE = "wayland";
        SDL_VIDEODRIVER = "wayland";
        XDG_CACHE_HOME = "/home/zoey/.cache";
        CLUTTER_BACKEND = "wayland";
        DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
      };
      loginShellInit = ''
        dbus-update-activation-environment --systemd DISPLAY
        eval $(gnome-keyring-daemon --start --components=ssh,secrets)
        eval $(ssh-agent)
      '';
    };

    hardware.pulseaudio.support32Bit = true;

    # xdg.portal = {
    #   enable = true;
    #   wlr.enable = false;
    #   config.common.default = "*";
    #   extraPortals = [
    #     pkgs.xdg-desktop-portal-gtk
    #     # pkgs.xdg-desktop-portal-wlr
    #     pkgs.xwaylandvideobridge
    #   ];
    # };
  };
}
