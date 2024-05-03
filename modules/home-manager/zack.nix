{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [./default.nix ./applications.nix];

  services = {
    udiskie.enable = true;
    gpg-agent = {
      enable = true;
      pinentryPackage = lib.mkForce pkgs.pinentry-gnome3;
      enableSshSupport = true;
      enableZshIntegration = true;
    };
  };

  systemd.user.services.kb-gui = {
    Unit = {
      Description = "KB Time/Date thing";
    };
    Install = {
      WantedBy = ["default.target"];
    };
    Service = {
      ExecStart = "${inputs.kb-gui.packages.${pkgs.system}.kb}/bin/kb";
    };
  };
}
