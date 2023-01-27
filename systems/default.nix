{
  nixpkgs,
  self,
  ...
}: let
  inputs = self.inputs;
  hmModule = inputs.home-manager.nixosModules.home-manager;
in {
  mars = nixpkgs.lib.nixosSystem { # replace GAMER-PC with your pc name
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs;
      hostname = "mars"; # replace this with your PC name
    };
    modules = [
      ./mars # replace
      ./mars/hardware.nix # replace
      hmModule
    ];
  };
}
