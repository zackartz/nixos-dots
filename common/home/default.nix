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

  catppuccin.flavor = "mocha";

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
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  xdg.enable = true;
  # programs.nixvim = ./vim.nix;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
