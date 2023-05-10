{ inputs
, system
, lib
, platforms
, ...
}:

let
in
{
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
    (import ./discord.nix)
    (inputs.iosevka.overlay)
    (final: prev:
      let
      in
      rec {
        nvchad = prev.callPackage ../packages/nvchad { };
      })
  ];
}
