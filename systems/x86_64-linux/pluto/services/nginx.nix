{pkgs, ...}: {
  services.nginx = {
    enable = true;
    package = pkgs.nginxStable.override {openssl = pkgs.libressl;};
    recommendedProxySettings = true;
    virtualHosts = {
      "node.nyc.zackmyers.io" = {
        forceSSL = true;
        enableACME = true;
      };
    };
  };
}
