{
  writeShellScriptBin,
  pkgs,
  ...
}:
writeShellScriptBin "rebuild" ''
  set -e
  pushd ~/nixos/
  ${pkgs.alejandra}/bin/alejandra . &>/dev/null
  git add .
  git pull origin main
  echo "[REBUILD]: rebuilding nixos"
  ${pkgs.nh}/bin/nh os switch
  popd
''
