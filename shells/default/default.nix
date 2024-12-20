{
  mkShell,
  pkgs,
  ...
}:
mkShell {
  packages = with pkgs; [
    nil
    nixd
    alejandra
    stylua
    lua-language-server
    luajitPackages.lua-lsp
    python3
  ];
}
