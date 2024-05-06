{
  inputs,
  pkgs,
  ...
}: {
  services.nginx.virtualHosts."cv.zackmyers.io" = {
    forceSSL = true;
    enableACME = true;
    locations."/".root = "${inputs.resume.packages.${pkgs.system}.default}";
  };
}
