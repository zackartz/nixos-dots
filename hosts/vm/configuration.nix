{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../common/default.nix
  ];

  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zack = {
    isNormalUser = true;
    description = "zack";
    extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "plugdev"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
      kate
      rio
      telegram-desktop
      kitty
    ];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "zack" = {
        imports = [../../modules/home-manager/zack.nix];
        _module.args.theme = import ../../core/theme.nix;

        home.username = "zack";
        home.homeDirectory = "/home/zack";
      };
    };
  };
}
