{
  mkShell,
  pkgs,
  ...
}:
mkShell {
  packages = with pkgs; [
    nil
    alejandra
    stylua
    lua-language-server
    luajitPackages.lua-lsp
    python3
    nixos-anywhere
  ];
}
