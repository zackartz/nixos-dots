{
  pkgs,
  inputs,
  lib,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  imports = [
    ./swayidle.nix
    ./vim/default.nix
    ./firefox.nix

    ../rice/ags
    ../rice/hyprland
    # ../rice/sway
    ../rice/gtk.nix
    ../rice/kitty.nix
    # ../rice/waybar
    # ../rice/dunst.nix
    ../rice/anyrun
    ../rice/rio.nix
    ../rice/wofi.nix
    ../shell

    inputs.spicetify-nix.homeManagerModule
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
    overlays = [
      inputs.neovim-nightly-overlay.overlay
    ];
  };

  gtk.catppuccin.cursor.enable = false;

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 30d";
  };

  catppuccin.flavour = "mocha";
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

  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "image/png" = "feh.desktop";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing it.

  home.packages = [
    pkgs.wofi
    pkgs.dconf
    pkgs.wl-clipboard
    pkgs.swaybg
    pkgs.pavucontrol
    pkgs.wlogout
    pkgs.sway-audio-idle-inhibit
    pkgs.grim
    pkgs.slurp

    pkgs.xfce.thunar
    pkgs.feh
    pkgs.nitch
    pkgs.nix-output-monitor
    pkgs.fastfetch

    pkgs.nh
    pkgs.dwl

    pkgs.killall
    (pkgs.writeShellScriptBin "rebuild" ''
      #!${pkgs.bash}/bin/bash
      set -e
      pushd ~/nixos/
      alejandra . &>/dev/null
      git add .
      echo "[REBUILD]: rebuilding nixos"
      nh os switch
      gen=$(nixos-rebuild list-generations | grep current)
      git commit -am "$gen"
      git push origin main
      popd
    '')
    (pkgs.writeShellScriptBin "powermenu" ''
      chosen=$(printf "  Power Off\n  Restart\n  Suspend\n  Lock\n󰍃  Log Out" | anyrun --plugins libstdin.so --show-results-immediately true)

      case "$chosen" in
          "  Power Off") systemctl poweroff;;
          "  Restart") systemctl reboot;;
          "  Lock") swaylock;;
          "󰍃 Log Out") hyprctl dispatch exit;;
          *) exit 1 ;;
      esac
    '')
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  xdg.enable = true;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };

  programs.cava = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.btop = {
    enable = true;
    catppuccin.enable = true;
    extraConfig = ''
      update_ms = 100
      vim_keys = true
    '';
  };

  programs.lazygit = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.fzf = {
    enable = true;
    catppuccin.enable = true;
  };

  systemd.user.services.xwaylandvideobridge = {
    Unit = {
      Description = "Tool to make it easy to stream wayland windows and screens to exisiting applications running under Xwayland";
    };
    Service = {
      Type = "simple";
      ExecStart = lib.getExe pkgs.xwaylandvideobridge;
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };

  # programs.nixvim = ./vim.nix;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
