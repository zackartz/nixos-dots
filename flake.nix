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
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty.url = "github:ghostty-org/ghostty";

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    awsvpnclient = {
      url = "github:ymatsiuk/awsvpnclient/56ca114e3f7fe4db9d745a0ab8ed70c6bd803a8f";
      inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };

    resume.url = "git+https://git.zoeys.cloud/zoey/resume";
    anyrun.url = "github:anyrun-org/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    ags.url = "github:Aylur/ags/v1";
    ags.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";

    pnpm2nix.url = "github:nzbr/pnpm2nix-nzbr";

    solaar = {
      url = "github:Svenum/Solaar-Flake/main"; # Uncomment line for latest unstable version
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blog.url = "git+https://git.zoeys.cloud/zoey/web";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      # inputs.nixpkgs.follows = "nixpkgs";
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

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    zoeycomputer = {
      url = "git+https://git.zoeys.cloud/zoey/zoeys.computer";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    g2claude.url = "git+https://git.zoeys.cloud/zoey/g2claude.git";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, ...}: let
    snowfallConfig = inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      overlays = [
        inputs.rust-overlay.overlays.default
        (final: prev: {
          ghostty = inputs.ghostty.packages."x86_64-linux".default;
        })
      ];

      snowfall = {
        namespace = "custom";
      };

      channels-config = {
        allowUnfree = true;
      };

      homes.modules = with inputs; [
        spicetify-nix.homeManagerModules.default
        catppuccin.homeManagerModules.catppuccin
        anyrun.homeManagerModules.default
        ags.homeManagerModules.default
      ];

      systems.modules.nixos = with inputs; [
        lanzaboote.nixosModules.lanzaboote
        home-manager.nixosModules.home-manager
        catppuccin.nixosModules.catppuccin
        blog.nixosModule
        agenix.nixosModules.default
        solaar.nixosModules.default
        zoeycomputer.nixosModules.default
        lix-module.nixosModules.default
        disko.nixosModules.default
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
