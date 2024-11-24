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
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    resume.url = "git+https://git.zoeys.cloud/zoey/resume";
    anyrun.url = "github:anyrun-org/anyrun/a808e6d801d9e216a0c077a003fba22cfc3a1990";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    ags.url = "github:Aylur/ags/v1";
    ags.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";

    pnpm2nix.url = "github:nzbr/pnpm2nix-nzbr";

    solaar = {
      #url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz" # For latest stable version
      #url = "https://flakehub.com/f/Svenum/Solaar-Flake/0.1.1.tar.gz" # uncomment line for solaar version 1.1.13
      url = "github:Svenum/Solaar-Flake/main"; # Uncomment line for latest unstable version
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blog.url = "git+https://git.zoeys.cloud/zoey/web";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";

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

    # lix = {
    #   url = "git+https://git.lix.systems/lix-project/lix?ref=refs/tags/2.90-beta.1";
    #   flake = false;
    # };
    # lix-module = {
    #   url = "git+https://git.lix.systems/lix-project/nixos-module";
    #   inputs.lix.follows = "lix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    zen-browser.url = "github:MarceColl/zen-browser-flake";

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

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs-unstable,
    ...
  }: let
    snowfallConfig = inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      overlays = [inputs.rust-overlay.overlays.default];

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
