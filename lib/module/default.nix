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

  enabled = {enable = true;};

  disabled = {enable = false;};

  nixos-stable = import inputs.nixos-stable {
    system = "x86_64-linux";
    config = {};
    overlays = [];
  };
}
