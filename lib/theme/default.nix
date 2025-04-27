{lib}: let
  hexCharToInt = char: let
    charCode = lib.strings.charToInt char;
    zeroCode = lib.strings.charToInt "0";
    nineCode = lib.strings.charToInt "9";
    aCode = lib.strings.charToInt "a";
    fCode = lib.strings.charToInt "f";
    ACode = lib.strings.charToInt "A";
    FCode = lib.strings.charToInt "F";
  in
    if charCode >= zeroCode && charCode <= nineCode
    then charCode - zeroCode
    else if charCode >= aCode && charCode <= fCode
    then charCode - aCode + 10
    else if charCode >= ACode && charCode <= FCode
    then charCode - ACode + 10
    else builtins.throw "Invalid hex character: ${builtins.toString char}";

  hexCompToInt = hexComp: let
    trimmedStr = lib.strings.removePrefix "0x" hexComp;

    chars = lib.strings.stringToCharacters trimmedStr;

    op = acc: char: (acc * 16) + (hexCharToInt char);
  in
    if trimmedStr == ""
    then 0
    else builtins.foldl' op 0 chars;

  intCompToHex = intComp: let
    clampedInt = lib.max 0 (lib.min 255 (builtins.floor (intComp + 0.5)));
    hexString = lib.trivial.toHexString clampedInt;
  in
    lib.strings.fixedWidthString 2 "0" hexString;

  hexToRgb = hexColor: let
    hex = lib.strings.removePrefix "#" hexColor;
  in {
    r = hexCompToInt (lib.strings.substring 0 2 hex);
    g = hexCompToInt (lib.strings.substring 2 2 hex);
    b = hexCompToInt (lib.strings.substring 4 2 hex);
  };

  rgbToHex = rgbColor: "#${intCompToHex rgbColor.r}${intCompToHex rgbColor.g}${intCompToHex rgbColor.b}";

  /**
  * Linearly interpolates between two hex colors.
  *
  * @param color1Hex - The starting color hex string (e.g., "#RRGGBB").
  * @param color2Hex - The ending color hex string (e.g., "#RRGGBB").
  * @param t - The interpolation factor (float, typically 0.0 to 1.0).
  * @return The blended color as a hex string "#RRGGBB".
  */
  lerpColorFunc = color1Hex: color2Hex: t: let
    rgb1 = hexToRgb color1Hex;
    rgb2 = hexToRgb color2Hex;
    lerpedR = (rgb1.r * (1.0 - t)) + (rgb2.r * t);
    lerpedG = (rgb1.g * (1.0 - t)) + (rgb2.g * t);
    lerpedB = (rgb1.b * (1.0 - t)) + (rgb2.b * t);
    resultRgb = {
      r = lerpedR;
      g = lerpedG;
      b = lerpedB;
    };
  in
    rgbToHex resultRgb;
in {
  x = c: "#${c}";

  colors = {
    rosewater = {
      hex = "#f5e0dc";
      rgb = "rgb(245, 224, 220)";
      hsl = "hsl(10, 56%, 91%)";
    };
    flamingo = {
      hex = "#f2cdcd";
      rgb = "rgb(242, 205, 205)";
      hsl = "hsl(0, 59%, 88%)";
    };
    pink = {
      hex = "#f5c2e7";
      rgb = "rgb(245, 194, 231)";
      hsl = "hsl(316, 72%, 86%)";
    };
    mauve = {
      hex = "#cba6f7";
      rgb = "rgb(203, 166, 247)";
      hsl = "hsl(267, 84%, 81%)";
    };
    red = {
      hex = "#f38ba8";
      rgb = "rgb(243, 139, 168)";
      hsl = "hsl(343, 81%, 75%)";
    };
    maroon = {
      hex = "#eba0ac";
      rgb = "rgb(235, 160, 172)";
      hsl = "hsl(350, 65%, 77%)";
    };
    peach = {
      hex = "#fab387";
      rgb = "rgb(250, 179, 135)";
      hsl = "hsl(25, 92%, 75%)";
    };
    yellow = {
      hex = "#f9e2af";
      rgb = "rgb(249, 226, 175)";
      hsl = "hsl(41, 86%, 83%)";
    };
    green = {
      hex = "#a6e3a1";
      rgb = "rgb(166, 227, 161)";
      hsl = "hsl(115, 54%, 76%)";
    };
    teal = {
      hex = "#94e2d5";
      rgb = "rgb(148, 226, 213)";
      hsl = "hsl(170, 57%, 73%)";
    };
    sky = {
      hex = "#89dceb";
      rgb = "rgb(137, 220, 235)";
      hsl = "hsl(190, 71%, 73%)";
    };
    sapphire = {
      hex = "#74c7ec";
      rgb = "rgb(116, 199, 236)";
      hsl = "hsl(200, 77%, 69%)";
    };
    blue = {
      hex = "#89b4fa";
      rgb = "rgb(137, 180, 250)";
      hsl = "hsl(217, 91%, 76%)";
    };
    lavender = {
      hex = "#b4befe";
      rgb = "rgb(180, 190, 254)";
      hsl = "hsl(232, 97%, 85%)";
    };
    text = {
      hex = "#cdd6f4";
      rgb = "rgb(205, 214, 244)";
      hsl = "hsl(226, 64%, 88%)";
    };
    subtext1 = {
      hex = "#bac2de";
      rgb = "rgb(186, 194, 222)";
      hsl = "hsl(227, 36%, 80%)";
    };
    subtext0 = {
      hex = "#a6adc8";
      rgb = "rgb(166, 173, 200)";
      hsl = "hsl(228, 26%, 72%)";
    };
    overlay2 = {
      hex = "#9399b2";
      rgb = "rgb(147, 153, 178)";
      hsl = "hsl(228, 19%, 64%)";
    };
    overlay1 = {
      hex = "#7f849c";
      rgb = "rgb(127, 132, 156)";
      hsl = "hsl(230, 15%, 55%)";
    };
    overlay0 = {
      hex = "#6c7086";
      rgb = "rgb(108, 112, 134)";
      hsl = "hsl(232, 11%, 47%)";
    };
    surface2 = {
      hex = "#585b70";
      rgb = "rgb(88, 91, 112)";
      hsl = "hsl(233, 12%, 39%)";
    };
    surface1 = {
      hex = "#45475a";
      rgb = "rgb(69, 71, 90)";
      hsl = "hsl(234, 13%, 31%)";
    };
    surface0 = {
      hex = "#313244";
      rgb = "rgb(49, 50, 68)";
      hsl = "hsl(237, 16%, 23%)";
    };
    base = {
      hex = "#1e1e2e";
      rgb = "rgb(30, 30, 46)";
      hsl = "hsl(240, 21%, 15%)";
    };
    mantle = {
      hex = "#181825";
      rgb = "rgb(24, 24, 37)";
      hsl = "hsl(240, 21%, 12%)";
    };
    crust = {
      hex = "#11111b";
      rgb = "rgb(17, 17, 27)";
      hsl = "hsl(240, 23%, 9%)";
    };
  };

  fonts = {
    mono = {
      normal = "Iosevka Bold";
      bold = "Iosevka ExtraBold";
      italic = "Iosevka Bold Italic";
      bold_italic = "Iosevka ExtraBold Italic";
    };
  };

  wallpaper = ./svema_26_big.jpg;

  lerpColor = lerpColorFunc;
}
