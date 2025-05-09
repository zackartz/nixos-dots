{
  description = "Nixos config flake";

  nixConfig = {
    extra-substituters = [
      "https://cache.zoeys.computer"
    ];
    extra-trusted-public-keys = [
      "cache.zoeys.computer:0Pvq2E8GWBX9qk1aTQ3RpZ01t4Nu5uWMQy90ippP9Ls="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty.url = "github:ghostty-org/ghostty";

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    awsvpnclient = {
      url = "github:ymatsiuk/awsvpnclient/56ca114e3f7fe4db9d745a0ab8ed70c6bd803a8f";
      inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };

    walker.url = "github:abenz1267/walker";

    resume.url = "path:/home/zoey/dev/resume";
    ags.url = "github:Aylur/ags/v1";
    ags.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    # to replace with sops-nix
    sops-nix.url = "github:Mic92/sops-nix";

    pnpm2nix.url = "github:nzbr/pnpm2nix-nzbr";

    solaar = {
      url = "github:Svenum/Solaar-Flake/main"; # Uncomment line for latest unstable version
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blog.url = "path:/home/zoey/dev/web";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";

    catppuccin.url = "github:catppuccin/nix";

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kb-gui = {
      url = "github:zackartz/kb-gui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      #      inputs.nixpkgs.follows = "nixpkgs";
    };

    rio-term = {
      url = "github:raphamorim/rio";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    zoeycomputer = {
      url = "path:/home/zoey/dev/zoeys.computer";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    posting.url = "github:jorikvanveen/posting-flake";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming.url = "path:/home/zoey/dev/nix-gaming";

    niri-src.url = "github:YaLTeR/niri/c359d248257bdb68785597d2822f9c3a5ccbfdfe";
    niri-src.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake/bc29338ba733e4c1b94c3ed134baabfea587627e";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs = inputs @ {self, ...}: let
    snowfallConfig = inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      overlays = with inputs; [
        rust-overlay.overlays.default
        (final: prev: {
          ghostty = ghostty.packages."x86_64-linux".default;
        })
        (final: prev: {
          shadps4 = prev.shadps4.overrideAttrs {
            src = prev.fetchFromGitHub {
              owner = "shadps4-emu";
              repo = "shadPS4";
              rev = "41b39428335025e65f9e707ed8d5a9a1b09ba942";
              hash = "sha256-5oe2By8TjJJIVubkp5lzqx2slBR7hxIHV4wZLgRYKl8=";
              fetchSubmodules = true;
            };
            patches = [];
          };
        })
        niri.overlays.niri
      ];

      snowfall = {
        namespace = "custom";
      };

      channels-config = {
        allowUnfree = true;

        gcc.arch = "znver3";
        gcc.tune = "znver3";
      };

      homes.modules = with inputs; [
        spicetify-nix.homeManagerModules.default
        catppuccin.homeModules.default
        ags.homeManagerModules.default
        walker.homeManagerModules.default
      ];

      systems.modules.nixos = with inputs; [
        lanzaboote.nixosModules.lanzaboote
        home-manager.nixosModules.home-manager
        catppuccin.nixosModules.catppuccin
        blog.nixosModule
        agenix.nixosModules.default
        sops-nix.nixosModules.sops
        solaar.nixosModules.default
        zoeycomputer.nixosModules.default
        lix-module.nixosModules.default
        mailserver.nixosModule
        disko.nixosModules.disko
        niri.nixosModules.niri
        chaotic.nixosModules.default
      ];
    };
  in
    snowfallConfig
    // {
      hydraJobs = {
        x86_64-linux.earth = self.nixosConfigurations.earth.config.system.build.toplevel;
        x86_64-linux.pluto = self.nixosConfigurations.pluto.config.system.build.toplevel;
        zen-browser = self.packages."x86_64-linux".zen-browser;
      };
    };
}
