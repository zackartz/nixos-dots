{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.helpers.rofi;
in {
  options.apps.helpers.rofi = with types; {
    enable = mkBoolOpt false "Enable Rofi";
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;

      # Basic configuration
      terminal = "ghostty";
      font = "Lexend Medium 16px";

      extraConfig = {
        modi = "drun";
        show-icons = true;
        drun-display-format = "{icon} {name}";
        location = 0;
        hide-scrollbar = true;
        disable-history = false;
        display-drun = "  Applications";
        display-run = "  Run";
        display-calc = "  Calculator";
        display-emoji = "  Emojis";
        sidebar-mode = false;

        # # Timeout settings
        # timeout = {
        #   action = "kb-cancel";
        #   delay = 0;
        # };
        #
        # filebrowser = {
        #   "directories-first" = true;
        #   "sorting-method" = "name";
        # };
      };

      # Theme configuration
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          background = "#181825";
          prompt = "#1e1e2e";
          border = "#313244";
          text = "#cdd6f4";
          stext = "#45475a";
          select = "#1e1e2e";
          "background-color" = mkLiteral "transparent";
          "text-color" = mkLiteral "@text";
          margin = 0;
          padding = 0;
        };

        "window" = {
          transparency = "real";
          location = mkLiteral "center";
          anchor = mkLiteral "center";
          width = mkLiteral "32em";
          "x-offset" = mkLiteral "0px";
          "y-offset" = mkLiteral "0px";
          enabled = true;
          border = mkLiteral "2px solid";
          "border-color" = mkLiteral "@border";
          "border-radius" = mkLiteral "4px";
          "background-color" = mkLiteral "@background";
          cursor = mkLiteral "default";
        };

        "inputbar" = {
          enabled = true;
          "background-color" = mkLiteral "@prompt";
          orientation = mkLiteral "horizontal";
          children = mkLiteral "[ \"entry\" ]";
        };

        "entry" = {
          enabled = true;
          padding = mkLiteral "0.75em 1.25em";
          cursor = mkLiteral "text";
          placeholder = "  Search application...";
          "background-color" = mkLiteral "@background";
          "placeholder-color" = mkLiteral "@stext";
        };

        "listview" = {
          enabled = true;
          columns = 1;
          lines = 5;
          cycle = true;
          dynamic = true;
          scrollbar = false;
          layout = mkLiteral "vertical";
          reverse = false;
          "fixed-height" = true;
          "fixed-columns" = true;
          margin = mkLiteral "0.5em 0 0.75em";
          cursor = mkLiteral "default";
        };

        "element" = {
          enabled = true;
          margin = mkLiteral "0 0.75em";
          padding = mkLiteral "0.5em 1em";
          cursor = mkLiteral "pointer";
          orientation = mkLiteral "horizontal";
        };

        "element-icon" = {
          size = mkLiteral "24px";
        };

        "element normal.normal" = {
          "background-color" = mkLiteral "inherit";
          "text-color" = mkLiteral "inherit";
        };

        "element selected.normal" = {
          border = mkLiteral "2px solid";
          "border-color" = mkLiteral "@border";
          "border-radius" = mkLiteral "8px";
          "background-color" = mkLiteral "@select";
        };

        "element-text" = {
          highlight = mkLiteral "bold";
          cursor = mkLiteral "inherit";
          "vertical-align" = mkLiteral "0.5";
          "horizontal-align" = mkLiteral "0.0";
          font = mkLiteral ''"Lexend Medium 16px"'';
        };
      };
    };

    # Create the colors.rasi file
    xdg.configFile."rofi/colors.rasi".text = ''
      * {
        background: #181825;
        prompt: #1e1e2e;
        border: #313244;
        text: #cdd6f4;
        stext: #45475a;
        select: #1e1e2e;
      }
    '';

    # Create the clip theme
    xdg.configFile."rofi/clip.rasi".text = ''
      @theme "cat-mocha"
      @import "./colors.rasi"

      entry {
        placeholder: "  Search clipboard...";
      }

      element-icon {
        enabled: false;
        size: 0;
      }
    '';
  };
}
