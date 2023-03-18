{ pkgs, inputs, ... }:

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
      ibm-plex
      unzip
      wlogout
      playerctl
      ncmpcpp
    ];
    shell = pkgs.zsh;
  };

  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
    (import ./overlays/discord.nix)
    (final: prev: {
      sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation rec {
      pname = "sf-mono-liga-bin";
      version = "dev";
      src = inputs.sf-mono-liga-src;
      dontConfigure = true;
      installPhase = ''
          mkdir -p $out/share/fonts/opentype
          cp -R $src/*.otf $out/share/fonts/opentype/
        '';
      };
    })
    # inputs.neovim.overlay
  ];

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  environment.sessionVariables = rec {
    GBM_BACKEND = "nvidia-drm";

    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    WLR_DRM_NO_ATOMIC = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # Will break SDDM if running X11
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    GDK_BACKEND = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  fonts = {
    fonts = with pkgs; [ sf-mono-liga-bin ];
  };

  environment.systemPackages = with pkgs; [
    dbus-hyprland-environment
    python3
    virt-manager
    # Work around #159267
    (pkgs.writeShellApplication {
      name = "discord";
      text = "${pkgs.discord}/bin/discord --use-gl=desktop";
    })
    (pkgs.makeDesktopItem {
      name = "discord";
      exec = "discord";
      desktopName = "Discord";
    })

    tree-sitter
    nodejs
    ripgrep
    fd
    unzip
    rust-analyzer
    sumneko-lua-language-server
    rustup
    pinentry-gtk2
  ];

  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  # };
  programs.hyprland.enable = true;

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    enableSSHSupport = true;
  };

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
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-kde
    ];
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
          { name = "chisui/zsh-nix-shell"; }
          { name = "unixorn/fzf-zsh-plugin"; }
          { name = "Aloxaf/fzf-tab"; }
        ];
      };
      plugins = [
        {
          name = "p10k-config";
          src = ./p10k;
          file = ".p10k.zsh";
        }
      ];
      shellAliases = {
        "upd" = "sudo nixos-rebuild switch --flake ~/.files#mars";
      };
      initExtra =
        "bindkey \"^[[1;5C\" forward-word\n
        bindkey \"^[[1;5D\" backward-word";
    };

    programs.git = {
      enable = true;
      userName = " zackartz";
      userEmail = " zackmyers@lavabit.com";
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

    # programs.neovim = {
    #   enable = true;
    #   extraPackages = (with pkgs ;[
    #     tree-sitter
    #     nodejs
    #     ripgrep
    #     fd
    #     unzip
    #     rust-analyzer
    #     sumneko-lua-language-server
    #     rust-analyzer
    #     rustup
    #     #bash-language-server
    #   ]);
    # };

    xdg.configFile.nvim = {
      source = ./NvChad;
      recursive = true;
    };

    xdg.configFile."nvim/lua/custom" = {
      source = ./nvim-cfg;
      recursive = true;
    };

    xdg.configFile."hypr/hyprland.conf".source = ./hypr/hyprland.conf;
    xdg.configFile."hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;
    xdg.configFile."kitty/kitty.conf".source = ./kitty/kitty.conf;

    xdg.configFile.waybar = {
      source = ./waybar;
      recursive = true;
    };

    xdg.configFile.wezterm = {
      source = ./wez;
      recursive = true;
    };

    home.stateVersion = "22.11";
    programs.bash.enable = true;
  };
}

