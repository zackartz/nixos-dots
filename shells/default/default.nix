{
  mkShell,
  pkgs,
  ...
}:
mkShell {
  packages = with pkgs; [
    nixd
    alejandra
    stylua
    lua-language-server
    luajitPackages.lua-lsp
    python3
  ];
}
