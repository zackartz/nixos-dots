{
  description = "Zack's NixOS setup!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
    flake-utils.url = "github:numtide/flake-utils";
    nyoom-src = {
      url = "github:nyoom-engineering/nyoom.nvim";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... } @ inputs:
    {
      nixosConfigurations = import ./systems inputs;
    };
}
