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
      package = pkgs.rofi-wayland;

      # Basic configuration
      terminal = "kitty";
      font = "Cantarell";

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
          background = colors.mantle.hex;
          prompt = colors.base.hex;
          border = colors.surface0.hex;
          text = colors.text.hex;
          stext = colors.surface1.hex;
          select = colors.base.hex;
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
          font = mkLiteral ''"Cantarell 16px"'';
        };
      };
    };

    # Create the colors.rasi file with our theme colors
    xdg.configFile."rofi/colors.rasi".text = ''
      * {
        background: ${colors.mantle.hex};
        prompt: ${colors.base.hex};
        border: ${colors.surface0.hex};
        text: ${colors.text.hex};
        stext: ${colors.surface1.hex};
        select: ${colors.base.hex};

        /* Full color palette */
        rosewater: ${colors.rosewater.hex};
        flamingo: ${colors.flamingo.hex};
        pink: ${colors.pink.hex};
        mauve: ${colors.mauve.hex};
        red: ${colors.red.hex};
        maroon: ${colors.maroon.hex};
        peach: ${colors.peach.hex};
        yellow: ${colors.yellow.hex};
        green: ${colors.green.hex};
        teal: ${colors.teal.hex};
        sky: ${colors.sky.hex};
        sapphire: ${colors.sapphire.hex};
        blue: ${colors.blue.hex};
        lavender: ${colors.lavender.hex};
        subtext0: ${colors.subtext0.hex};
        subtext1: ${colors.subtext1.hex};
        overlay0: ${colors.overlay0.hex};
        overlay1: ${colors.overlay1.hex};
        overlay2: ${colors.overlay2.hex};
        surface0: ${colors.surface0.hex};
        surface1: ${colors.surface1.hex};
        surface2: ${colors.surface2.hex};
        base: ${colors.base.hex};
        mantle: ${colors.mantle.hex};
        crust: ${colors.crust.hex};
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
