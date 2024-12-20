{
  lib,
  inputs,
  ...
}:
with lib; rec {
  mkOpt = type: default: description:
    mkOption {inherit type default description;};

  mkOpt' = type: default: mkOpt type default null;

  mkBoolOpt = mkOpt types.bool;

  mkStringOpt = mkOpt types.str;

  mkBoolOpt' = mkOpt' types.bool;

  pkgs-stable = import inputs.nixpkgs-stable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  enabled = {enable = true;};

  disabled = {enable = false;};
}
