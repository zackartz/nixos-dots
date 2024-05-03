{pkgs, ...}: {
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.redis = {
    enable = true;
  };
}
