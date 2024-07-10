{
  description = "Nixos config flake";

  nixConfig = {
    extra-substituters = [
      "https://zackartz.cachix.org"
    ];
    extra-trusted-public-keys = [
      "zackartz.cachix.org-1:nrEfVZF8MVX0Lnt73KwYzH2kwDzFuAoR5VPjuUd4R30="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    resume.url = "git+https://git.zackster.zip/zack/resume";
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    ags.url = "github:Aylur/ags";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blog.url = "github:zackartz/zmio";

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
      # inputs.nixpkgs.follows = "nixpkgs";
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

    systems.url = "github:nix-systems/default";
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      overlays = [inputs.neovim-nightly-overlay.overlays.default];

      snowfall = {
        namespace = "custom";
      };

      channels-config = {
        allowUnfree = true;
      };

      templates = import ./templates {};

      homes.modules = with inputs; [
        spicetify-nix.homeManagerModule
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
      ];
    };
}
