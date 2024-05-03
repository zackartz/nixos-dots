{pkgs, ...}: {
  services.nginx = {
    enable = true;
    package = pkgs.nginxStable.override {openssl = pkgs.libressl;};
    virtualHosts = {
    };
  };
}
