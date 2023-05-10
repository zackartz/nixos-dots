{ pkgs, inputs, lib, config, ... }:

let
  dbus-hyprland-environment = pkgs.writeTextFile {
    name = "dbus-hyprland-environment";
    destination = "/bin/dbus-hyprland-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland
      systemctl --user stop pipewire xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  custom = ./nvchad/custom;

  nvchad = pkgs.stdenv.mkDerivation {
    pname = "nvchad";
    version = "2.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "NvChad";
      repo = "NvChad";
      rev = "refs/heads/v2.0";
      # rev = "32b0a008a96a3dd04675659e45a676b639236a98";
      # sha256 = "sha256-s/nnGUGFgJ+gpMAOO3hYJ6PrX/qti6U1wyB6PzTiNtM=";
      sha256 = "sha256-bfDNMy4pjdSwYAjyhN09fGLJguoooJAQm1nKneCpKcU=";
    };

    installPhase = ''
      mkdir $out
      cp -r * "$out/"
      mkdir -p "$out/lua/custom"
      cp -r ${custom}/* "$out/lua/custom/"
    '';

    meta = with lib; {
      description = "NvChad";
      homepage = "https://github.com/NvChad/NvChad";
      platforms = platforms.all;
      maintainers = [ maintainers.zackartz ];
      license = licenses.gpl3;
    };
  };
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zack = {
    isNormalUser = true;
    description = "Zachary Myers";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    packages = with pkgs; [
      kate
      firefox
      #  thunderbird
      kitty
      alacritty
      wl-clipboard
      _1password-gui
      wofi
      wezterm
      hyprpaper
      dunst
      pfetch
      waybar
      spotify
      rofi
      ibm-plex
      unzip
      wlogout
      playerctl
      (pkgs.writeShellScriptBin "discord" ''
        exec ${pkgs.discord}/bin/discord --enable-features=UseOzonePlatform --ozone-platform=wayland
      '')
      ncmpcpp
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  environment.sessionVariables = {
    #GBM_BACKEND = "nvidia-drm";

    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    WLR_DRM_NO_ATOMIC = "1";
    #__GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # Will break SDDM if running X11
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    # GDK_BACKEND = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  environment.systemPackages = with pkgs; [
    dbus-hyprland-environment
    python3
    virt-manager
  ];

  programs.hyprland.enable = true;

  nixpkgs.overlays = [
    inputs.iosevka.overlay
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  fonts = {
    fonts = with pkgs; [
      inter-ui
      noto-fonts
      noto-fonts-emoji

      iosevka-custom-sans.nerd-font
      iosevka-custom-sans.normal
    ];

    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "Iosevka Sans" ];
        sansSerif = [ "Inter" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  home-manager.users.zack = { pkgs, ... }: {
    home.packages = (with pkgs;
      [
        gcc
        cargo
        fzf
        nvchad
        exa
      ]);

    programs.zsh = {
      enable = true;
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "zsh-users/zsh-syntax-highlighting"; }
          { name = "chisui/zsh-nix-shell"; }
          { name = "unixorn/fzf-zsh-plugin"; }
          { name = "Aloxaf/fzf-tab"; }
        ];
      };
      shellAliases = {
        "upd" = "sudo nixos-rebuild switch --flake ~/.files#mars";
        "ls" = "exa --icons --group-directories-first";
      };
      initExtra =
        "bindkey \"^[[1;5C\" forward-word\n
        bindkey \"^[[1;5D\" backward-word";
    };

    programs.git = {
      enable = true;
      userName = "zackartz";
      userEmail = "zackmyers@lavabit.com";
    };

    programs.starship = {
      enable = true;

      settings = {
        format = "$directory$git_branch$character";
        right_format = "$git_status$cmd_duration";
        add_newline = false;

        conda = {
          format = " [$symbol$environment](dimmed green) ";
        };

        character = {
          success_symbol = "[](#a6e3a1 bold)";
          error_symbol = "[](#f38ba8)";
          vicmd_symbol = "[](#f9e2af)";
        };

        directory = {
          format = "[]($style)[ ](bg:#161821 fg:#81A1C1)[$path](bg:#161821 fg:#BBC3DF bold)[ ]($style)";
          style = "bg:none fg:#161821";
          truncation_length = 3;
          truncate_to_repo = false;
        };

        git_branch = {
          format = "[]($style)[[ ](bg:#161821 fg:#A2DD9D bold)$branch](bg:#161821 fg:#86AAEC)[ ]($style)";
          style = "bg:none fg:#161821";
        };

        git_status = {
          format = "[]($style)[$all_status$ahead_behind](bg:#161821 fg:#b4befe)[ ]($style)";
          style = "bg:none fg:#161821";
          conflicted = "=";
          ahead = "⇡\${count}";
          behind = "⇣\${count}";
          diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
          up_to_date = "";
          untracked = "?\${count}";
          stashed = "";
          modified = "!\${count}";
          staged = "+\${count}";
          renamed = "»\${count}";
          deleted = "\${count}";
        };

        cmd_duration = {
          min_time = 1;
          # duration & style 
          format = "[]($style)[[神](bg:#161821 fg:#eba0ac bold)$duration](bg:#161821 fg:#BBC3DF)[ ]($style)";
          disabled = false;
          style = "bg:none fg:#161821";
        };
      };
    };

    home.pointerCursor = {
      name = "phinger-cursors";
      package = pkgs.phinger-cursors;
      size = 24;
      gtk.enable = true;
    };

    services.mpd = {
      enable = true;
      musicDirectory = "/home/zack/Music";
      extraConfig = ''
        audio_output {
            type "pipewire"
            name "My PipeWire Output"
        }
      '';
    };

    services.mpdris2 = {
      enable = true;
    };

    # programs.xwayland.enable = true;

    programs.neovim = {
      enable = true;
      extraPackages = (with pkgs ;[
        tree-sitter
        nodejs
        ripgrep
        fd
        unzip
        rust-analyzer
        gopls
        nil
        rustfmt
        nodePackages.prettier
        nodePackages.typescript-language-server
        nodePackages.vscode-css-languageserver-bin
        #bash-language-server
        lua-language-server
        vscode-extensions.vadimcn.vscode-lldb
      ]);
    };

    xdg.configFile."hypr".source = ./hypr;
    xdg.configFile."nvim".source = "${nvchad}";
    xdg.configFile."rofi".source = ./rofi;

    programs.kitty = lib.mkMerge [
      {
        enable = true;
        font = {
          name = "Iosevka Nerd Font Mono";
        };
        theme = "Rosé Pine";
        settings = {
          window_padding_width = "10";
          background_opacity = "0.75";
          confirm_os_window_close = "0";
        };
      }
    ];

    xdg.configFile.waybar = {
      source = ./waybar;
      recursive = true;
    };

    xdg.configFile.wezterm = {
      source = ./wez;
      recursive = true;
    };

    home.stateVersion = "23.05";
    programs.bash.enable = true;
  };
}

