{
  inputs,
  fetchFromGitHub,
  pkgs,
}: let
  pds = fetchFromGitHub {
    owner = "bluesky-social";
    repo = "pds";
    rev = "main";
    hash = "sha256-dEB5u++Zx+F4TH5q44AF/tuwAhLEyYT+U5/18viT4sw=";
  };
in
  inputs.pnpm2nix.packages.${pkgs.system}.mkPnpmPackage {
    src = "${pds}/service";
    extraBuildInputs = [pkgs.sqlite];
  }
