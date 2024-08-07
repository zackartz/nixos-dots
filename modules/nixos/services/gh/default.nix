{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.gh;

  sec = config.age.secrets;
  group = config.services.github-runners.pluto.runnerGroup;
in {
  options.services.gh = with types; {
    enable = mkBoolOpt false "Enable GitHub Actions Runner";
  };

  config = mkIf cfg.enable {
    age.secrets = {
      github_runner = {
        file = ./sec/github_runner.age;
      };
    };

    services.github-runners.pluto = {
      enable = true;
      url = "https://github.com/zackartz/nixos-dots";
      tokenFile = sec.github_runner.path;
    };
  };
}
