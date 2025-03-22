{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.mail.aerc;
in {
  options.apps.mail.aerc = with types; {
    enable = mkBoolOpt false "Enable Aerc Mail Client";
  };

  config = mkIf cfg.enable {
    programs.aerc = {
      enable = false;
      package = nixos-stable.aerc;
      extraConfig = {
        general = {
          pgp-provider = "gpg";
        };
        filters = {
          "text/plain" = "colorize";
          "text/calendar" = "calendar";

          "message/delivery-status" = "colorize";
          "message/rfc822" = " colorize";
          "text/html" = "pandoc -f html -t plain | colorize";
        };
        hooks = {
          "mail-received" = "notify-send \"[$AERC_ACCOUNT/$AERC_FOLDER] New mail from $AERC_FROM_NAME\" \"$AERC_SUBJECT\"";
        };
      };
    };
  };
}
