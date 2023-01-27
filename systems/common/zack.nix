{ pkgs, inputs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zack = {
    isNormalUser = true;
    description = "Zachary Myers";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
      #  thunderbird
      discord
    ];
    shell = pkgs.zsh;
  };

  home-manager.users.zack = { pkgs, ... }: {
    home.packages = (with pkgs ;[
      gcc
      cargo
      nerdfonts
      fzf
    ]);

    programs.zsh = {
      enable = true;
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "zsh-users/zsh-syntax-highlighting"; }
          { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
        ];
      };
      plugins = [
        {
          name = "p10k-config";
          src = ./p10k-config;
          file = ".p10k.zsh";
        }
      ];
      shellAliases = {
        "upd" = "sudo nixos-rebuild switch --flake ~/.files#mars";
      };
    };

    programs.git = {
      enable = true;
      userName = "zackartz";
      userEmail = "zackmyers@lavabit.com";
    };

    programs.neovim = {
      enable = true;
      extraPackages = (with pkgs ;[
        tree-sitter
        nodejs
        ripgrep
        fd
        unzip
      ]);
    };

    #    home.file = {
    #      "nyoom.nvim" = {
    #        source = pkgs.fetchFromGitHub {
    #          owner = "nyoom-engineering";
    #          repo = "nyoom.nvim";
    #          rev = "68992d7d56217bcf433ef0bf48192c5c975628da";
    #          sha256 = "IZDxF8PwzuybhGNl2Is8PekMNx98Xo/x7nbWy5wmrNY=";
    #        };
    #        target = ".config/nvim";
    #        recursive = true;
    #     };
    #    };

    xdg.configFile.nvim = {
      source = pkgs.buildEnv {
        name = "nyoom";
        paths = [
          inputs.nyoom-src
          { outPath = ./config; meta.priority = 4; }
        ];
      };
      recursive = true;
    };

    programs.bash.enable = true;
    home.stateVersion = "22.11";
  };
}
