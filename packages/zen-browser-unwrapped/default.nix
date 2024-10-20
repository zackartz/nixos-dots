{pkgs ? import <nixpkgs> {}}: {zen-browser-unwrapped = pkgs.callPackage ./package.nix {};}
