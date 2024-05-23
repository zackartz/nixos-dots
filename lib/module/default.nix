{lib, ...}:
with lib; rec {
  mkOpt = type: default: description:
    mkOption {inherit type default description;};

  mkOpt' = type: default: mkOpt type default null;

  mkBoolOpt = mkOpt types.bool;

  mkStringOpt = mkOpt types.string;

  mkBoolOpt' = mkOpt' types.bool;

  enabled = {enable = true;};

  disabled = {enable = false;};
}
