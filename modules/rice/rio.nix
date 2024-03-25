{inputs, ...}: {
  programs.rio = {
    enable = true;
    package = inputs.rio-term.packages.x86_64-linux.default;
    settings = {
      padding-x = 10;
      colors = {
        background = "#1a1b26";
        foreground = "#e0def4";
        selection-background = "#e0def4";
        selection-foreground = "#191724";
        cursor = "#e0def4";
        black = "#26233a";
        red = "#eb6f92";
        green = "#9ccfd8";
        yellow = "#f6c177";
        blue = "#31748f";
        magenta = "#c4a7e7";
        cyan = "#ebbcba";
        white = "#e0def4";
        light_black = "#6e6a86";
        light_red = "#eb6f92";
        light_green = "#9ccfd8";
        light_yellow = "#f6c177";
        light_blue = "#31748f";
        light_magenta = "#c4a7e7";
        light_cyan = "#ebbcba";
        light_white = "#e0def4";
      };

      fonts = {
        size = 18;

        # family = "Iosevka Nerd Font Mono";
        regular = {
          family = "Iosevka Nerd Font Mono";
          style = "normal";
          weight = 600;
        };
        bold = {
          family = "Iosevka Nerd Font Mono";
          style = "normal";
          weight = 800;
        };
        italic = {
          family = "Iosevka Nerd Font Mono";
          style = "italic";
          weight = 600;
        };
        bold-italic = {
          family = "Iosevka Nerd Font Mono";
          style = "italic";
          weight = 800;
        };
      };

      window = {
        # background-opacity = 0.75;
      };
    };
  };
}
