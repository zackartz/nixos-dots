{writeShellScriptBin, ...}:
writeShellScriptBin "rebuild" ''
  set -e
  pushd ~/nixos/
  alejandra . &>/dev/null
  git add .
  echo "[REBUILD]: rebuilding nixos"
  nh os switch --update
  gen=$(nixos-rebuild list-generations | grep current)
  git commit -am "$gen"
  git pull origin main
  popd
''
