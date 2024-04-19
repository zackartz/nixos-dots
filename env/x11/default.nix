{pkgs, ...}: {
  environment.etc."greetd/environments".text = ''
    bspwm
    Hyprland
  '';

  services = {
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "bspwm";
          user = "zack";
        };
        default_session = initial_session;
      };
    };
  };
}
