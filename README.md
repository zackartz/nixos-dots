# zack's nixos dotfiles

![image](https://github.com/zackartz/nixos-dots/assets/34588810/0f4c85c2-f9e8-4de3-89c1-0a95c0ab681f)

my customized versions of other's dotfiles

major credits to [sioodmy](https://github.com/sioodmy/dotfiles) and [luckasRanarison](https://github.com/luckasRanarison/nvimrc).

could not have done this without their work :)

## Installation Instructions

### Step 0: Install NixOS Normally

Grab the [nixos iso](https://nixos.org/download/) and install nixos on to your computer using the graphical installer.

> [!WARNING]
> You can choose whatever desktop environment you want, but make sure the username you choose is the one you will want to continue with!

> [!TIP]
> You can use [nixos anywhere](https://github.com/nix-community/nixos-anywhere) to install your config to other systems (or like, a server) via ssh once you have your desktop installed :)

### Step 1: Enable Flakes and the Nix command

Right now the configuration you installed resides in `/etc/nixos/configuration.nix`, we want to edit that file to enable the `nix` command and the Flake feature. Simply add this line to that file:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

After this is done, go ahead and run `sudo nixos-rebuild switch`.

### Step 2: Cloning the Github Repo

Go ahead and create a nix shell with git with the following:

```bash
nix shell nixpkgs#git
git clone https://github.com/zackartz/nixos-dots.git nixos
```

> [!WARNING]
> Various scripts expect your local config to be at `~/nixos`, by changing the `FLAKE` sessionVariable in `modules/home/shells/zsh/default.nix` you can choose a different path.

### Step 3: Adding a new `system` and `home`

This config is built with [home-manager](https://github.com/nix-community/home-manager), which allows us to declare config files in our home directory and install user-specific applications.

With this, it also uses [snowfall](https://github.com/snowfallorg/lib) which is a directory-oriented opinionated way of structuring your flake, files added to `systems` or `homes` get picked up and auto exported from our flake, and anything in `lib`, `packages`, or `overlays` are exported and automatically shared within our flake.

Let's start with the `system`.

Create a new file in `systems/x86_64-linux/<your-hostname>/default.nix` with the following contents.

```nix
{
  pkgs,
  lib,
  system,
  inputs,
  config,
  ...
}: {
  imports = [./hardware-configuration.nix];

  hardware.audio.enable = true;
  hardware.nvidia.enable = false; # Enable if you have a nvidia GPU
  ui.fonts.enable = true;

  protocols.wayland.enable = true;

  services.fstrim.enable = true; # Optional, improve SSD lifespan
  services.xserver.enable = true; # Optional, but recommended (allows XWayland to work)
  services.gnome.gnome-keyring.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "earth"; # Define your hostname. MUST BE THE SAME AS THE HOSTNAME YOU SPECIFIED EARLIER!!!

  # services.openssh = {
  #   enable = true;
  #   PasswordAuthentication = true;
  # };

  time.timeZone = "America/Detroit"; # Change to your TZ

  programs.zsh.enable = true;
  # REMEMBER TO CHANGE TO YOUR USERNAME
  users.users.zoey = {
    isNormalUser = true;
    description = "zoey";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };

  # CHANGE USERNAME HERE TOO
  snowfallorg.users.zoey = {
    create = true;
    admin = false;

    home = {
      enable = true;
    };
  };

  catppuccin.enable = true; # If you want your TTY to be catppuccin too haha
}
```

One note, change the `# Bootloader` section to what is currently in `/etc/nixos/configuration.nix` so that the bootloader config stays the same.

Nice! We're also going to need the `hardware-configuration.nix` for your system, copy that file from `/etc/nixos/hardware-configuration.nix` so it sits alongside the `default.nix` file.

Now, lets add a file to define your home. Create a file at `homes/x86_64-linux/<your-username>@<your-hostname>/default.nix`.

```nix
{
  inputs,
  pkgs,
  system,
  lib,
  ...
}: {
  wms.hyprland.enable = true; # Hyprland is the only fully-supported window manager in my config atm.
  apps = {
    web.librewolf.enable = true; # can also use firefox
    web.librewolf.setDefault = true;

    tools.git.enable = true;
    tools.tmux.enable = true;
    tools.neovim.enable = true;
    tools.skim.enable = true;
    tools.starship.enable = true;
    tools.direnv.enable = true;
    tools.tealdeer.enable = true;
    tools.bat.enable = true;

    tools.gh.enable = true;

    term.kitty.enable = true;

    music.spotify.enable = true; # disable if you don't use spotify

    helpers = {
      anyrun.enable = true;
      ags.enable = true;
    };
  };

  shells.zsh.enable = true;

  rice.gtk.enable = true;

  services.lock.enable = true;

  xdg.enable = true;

  programs = {
    gpg.enable = true;
    man.enable = true;
    eza.enable = true;
    dircolors = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
  };

  catppuccin.enable = true;
  catppuccin.flavor = "macchiato";
  catppuccin.accent = "pink";

  # Add any packages you want in your path here!
  home.packages = [
    pkgs.ungoogled-chromium

    pkgs.postman
    pkgs.mosh

    pkgs.dconf
    pkgs.wl-clipboard
    pkgs.pavucontrol
    pkgs.wlogout
    pkgs.sway-audio-idle-inhibit
    pkgs.grim
    pkgs.slurp

    pkgs.xfce.thunar
    pkgs.feh
    pkgs.nitch
    pkgs.nix-output-monitor

    pkgs.nh
    pkgs.dwl

    pkgs.custom.rebuild
    pkgs.custom.powermenu
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };

  programs.cava.enable = true;

  programs.btop = {
    enable = true;
    extraConfig = ''
      update_ms = 100
      vim_keys = true
    '';
  };

  programs.lazygit.enable = true;
  programs.fzf.enable = true;

  systemd.user.services.xwaylandvideobridge = {
    Unit = {
      Description = "Tool to make it easy to stream wayland windows and screens to exisiting applications running under Xwayland";
    };
    Service = {
      Type = "simple";
      ExecStart = lib.getExe pkgs.xwaylandvideobridge;
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentryPackage = lib.mkForce pkgs.pinentry-gnome3;
      enableSshSupport = true;
      enableZshIntegration = true;
    };
  };
}
```

This is a pretty minimal config, (with some neat applications), but feel free to disable any you don't want or need!

### Step 4: Installing the config

Once you have all that, run these two commands to install and build the config!

```bash
git add -A # add the new files you created
sudo nixos-rebuild switch --flake ~/nixos#<your-hostname> # replace the ~/nixos with the location of the config if you changed it.
```

Go ahead and reboot and you should be in the new config, tada!
