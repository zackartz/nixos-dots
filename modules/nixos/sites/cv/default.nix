{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.sites.cv;
in {
  options.sites.cv = with types; {
    enable = mkBoolOpt false "Enable CV site";

    domain = mkStringOpt "cv.zackmyers.io" "The domain for the site";
  };

  config = mkIf cfg.enable {
    warnings =
      lib.optional (!config.services.nginx.enable)
      "CV site is enabled, but it depends on Nginx which is not enabled.";

    services.nginx.virtualHosts.${cfg.domain} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        root = "${inputs.resume.packages.${pkgs.system}.default}";
      };
      extraConfig = ''
        index ZacharyMyersResume.pdf;
      '';
    };
  };
}
