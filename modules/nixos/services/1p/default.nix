{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services._1password;
in {
  options.services._1password = with types; {
    enable = mkBoolOpt false "Enable 1Password";

    polkitPolicyOwnerUsername = mkStringOpt "zoey" "The username to own the polkit policy";
  };

  config = mkIf cfg.enable {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      # Certain features, including CLI integration and system authentication support,
      # require enabling PolKit integration on some desktop environments (e.g. Plasma).
      polkitPolicyOwners = [cfg.polkitPolicyOwnerUsername];
    };

    environment.etc = {
      "1password/custom_allowed_browsers" = {
        text = ''
          librewolf
          firefox
        '';
        mode = "0755";
      };
    };
  };
}
