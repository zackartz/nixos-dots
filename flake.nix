{
  description = "Zack's NixOS setup!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
    flake-utils.url = "github:numtide/flake-utils";

    hyprland.url = "github:hyprwm/Hyprland";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim.url = "github:neovim/neovim?dir=contrib";

    sf-mono-liga-src = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };
  };

  outputs = { self, ... } @ inputs:
    {
      nixosConfigurations = import ./systems inputs;
    };
}
