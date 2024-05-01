{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    pkgs.gimp
    pkgs.slack

    pkgs.zoom-us

    pkgs.prismlauncher
    pkgs.obs-studio
    inputs.kb-gui.packages.${pkgs.system}.kb

    pkgs.jetbrains.idea-community
    pkgs.jetbrains.datagrip
    pkgs.ungoogled-chromium

    pkgs.thunderbird

    pkgs.mongodb-compass
    pkgs.postman
    pkgs.mosh

    pkgs.parsec-bin
    pkgs.filezilla
    pkgs.ghidra
    pkgs.zed-editor
    pkgs.openvpn
  ];
}
