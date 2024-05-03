{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./vim/default.nix

    # ../rice/sway
    # ../rice/waybar
    # ../rice/dunst.nix
    ../shell

    # inputs.catppuccin.homeManagerModules.catppuccin
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

  # catppuccin.flavour = "mocha";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing it.

  home.packages = [
    pkgs.dconf

    pkgs.nix-output-monitor

    inputs.nixpkgs.legacyPackages.${pkgs.system}.nh

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

  programs.btop = {
    enable = true;
    # catppuccin.enable = true;
  };

  programs.lazygit = {
    enable = true;
    # catppuccin.enable = true;
  };

  programs.fzf = {
    enable = true;
    # catppuccin.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
